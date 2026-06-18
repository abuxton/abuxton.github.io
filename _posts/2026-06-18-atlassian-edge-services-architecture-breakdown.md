---
layout: post
title: "Eight Years of Edge: Atlassian's Load Balancing Platform Explained"
date: 2026-06-18 14:00:00 +0000
categories: [infrastructure, architecture]
tags: [atlassian, envoy, xds, edge-services, load-balancing, aws, cloudformation, packer, saltstack, fastapi, open-service-broker, infrastructure-as-code, platform-engineering]
---

There is a genre of technical content I find more useful than almost anything else. Not the conference talk that describes a finished system as if it arrived fully formed. Not the blog post that explains the happy path. The one I mean is the retrospective: someone who has worked on a thing for a long time, walking through what was actually built, why it was built that way, and what they learned. Those tend to be honest in ways that polished documentation is not.

A recently published YouTube video — [*I was laid off by Atlassian*](https://www.youtube.com/watch?v=55pTFVoclvE) — is exactly that kind of content. The speaker worked at Atlassian for roughly eight years and was affected by recent layoffs. Rather than disappear quietly, they recorded a 40-minute technical retrospective on the edge infrastructure platform they built: the load balancing layer that sits in front of Jira, Confluence, Bitbucket, Statuspage, and everything else Atlassian exposes publicly.

I want to write about what they built, because the architecture is genuinely interesting, and because a few of the design choices reflect a kind of engineering rigour that I think is worth naming explicitly.

## Why This Existed

The starting point is an unglamorous business problem. Atlassian was running enterprise load balancers with licensing costs. An architect had the idea to replace them with an open-source, cloud-native proxy. The goals were self-service for development teams, cost reduction by eliminating enterprise licensing, and centralised control over TLS termination and traffic policy enforcement.

The technology chosen for the proxy layer was [Envoy](https://www.envoyproxy.io/).

That choice matters a great deal, and the reason is specific: Envoy has an API — the [xDS (Envoy Discovery Service) protocol](https://www.envoyproxy.io/docs/envoy/latest/api-docs/xds_protocol) — that allows you to push configuration changes to running proxies without restarting them. Every configuration update — new backend cluster, updated routing rule, new HTTP filter, changed auth policy — lands on the fleet dynamically. The proxies keep running. Traffic keeps flowing.

If you pick NGINX instead, you do not get this. You get a reload. In a small fleet, that is fine. At the scale Atlassian was operating — around two thousand Envoy instances across roughly thirteen AWS regions — the xDS API is not an optimisation. It is the architectural foundation the entire system is built on.

## The Provisioning Side: Open Service Broker

The first component the speaker built was an internal provisioning API. Atlassian's internal developers should be able to get a load balancer, DNS record, or CloudFront distribution set up for their service without opening a ticket to a platform team or calling AWS APIs directly.

The API follows the [Open Service Broker specification](https://www.openservicebrokerapi.org/), an open standard for service provisioning that gives consumers a consistent interface regardless of what is being provisioned. The implementation is a [FastAPI](https://fastapi.tiangolo.com/) application (having gone through Connexion and Flask on the way there), backed by an [AWS SQS](https://aws.amazon.com/sqs/) queue for async job dispatch and [DynamoDB](https://aws.amazon.com/dynamodb/) for state storage.

A provisioning request from a developer triggers a worker that writes state to DynamoDB and creates the corresponding AWS resources — a Route 53 record here, a CloudFront distribution there. The developer polls the broker for status via a well-defined async endpoint. The broker reads DynamoDB.

What I find interesting about the design is the GitOps alignment. At Atlassian, provisioning is not triggered through a UI or direct API call. Configuration files committed to version control are uploaded during a CI build, and the build triggers the provisioning request. The infrastructure is treated as a declaration, not a command. That is exactly the right instinct.

## The Control Plane: Sovereign

The second component is where the real work is. It is a custom Envoy [xDS control plane](https://www.envoyproxy.io/docs/envoy/latest/configuration/overview/xds_api) — a management server that the Envoy fleet calls home to, asking: what should my current configuration be?

The speaker open-sourced this under the name **Sovereign**, and it is available on Bitbucket (search for "Sovereign"). It is also a FastAPI application. Its inputs are templates (Jinja-style representations of Envoy resource types) and context — live data sourced from the DynamoDB state database and an S3 bucket. When an Envoy proxy polls Sovereign for its current config, Sovereign renders templates against the current context and serves back valid Envoy resources: clusters, routes, listeners, and HTTP filter chains.

The elegance of this split is worth pausing on. The broker owns *what to provision* — it is the domain logic, the developer-facing API, the async workflow. Sovereign owns *how to translate provisioned state into proxy configuration*. Each can change independently. The broker does not know anything about Envoy. Sovereign does not know anything about the business logic of who wants what. The interface between them is a DynamoDB table.

When a developer provisions a new service via the OSB, DynamoDB is updated. On the next xDS poll from an Envoy instance, Sovereign produces a config that includes the new service. The proxy starts routing traffic. No restart, no deployment, no ticket.

## The Deployment Topology

The Envoy fleet itself lives on [AWS EC2](https://aws.amazon.com/ec2/), provisioned via [AWS CloudFormation](https://aws.amazon.com/cloudformation/) using an immutable AMI pattern. CloudFormation brings up a VPC, subnets, security groups, an [Auto Scaling Group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/auto-scaling-groups.html), a [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) in front of the Envoy instances, IAM roles, and [Route 53](https://aws.amazon.com/route53/) records for DNS-level traffic routing. [AWS ACM](https://aws.amazon.com/certificate-manager/) handles TLS certificate provisioning.

The AMI is built with [HashiCorp Packer](https://www.packer.io/) and [SaltStack](https://saltproject.io/). Packer launches a temporary EC2 instance, uploads the SaltStack configuration (states), runs the provisioning step, snapshots the instance, and produces an AMI. Everything needed to run Envoy is baked in: the proxy binary, logging agents, security hardening, network tuning, the container runtime for sidecars, and the observability agent covering logging, tracing, and metrics.

Nothing is SSH'd into and configured after deployment. Every change to the fleet goes through the Packer pipeline, producing a new AMI, which the Auto Scaling Group picks up on the next rotation. Immutable infrastructure as a genuine operational discipline, not just a talking point.

## Edge Capabilities as Platform Features

Once the migration of Atlassian's products was underway, the team built out centralised edge capabilities — security and traffic features applied at the proxy layer so that individual product teams do not have to implement them.

The list is worth reading:

- **DDoS protection**: handled at the [AWS CloudFront](https://aws.amazon.com/cloudfront/) layer, placed in front of the NLB/Envoy fleet to absorb volumetric attacks
- **Authentication**: a custom sidecar written in Rust by the speaker, called out from Envoy via the [`ext_authz`](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_authz_filter) filter
- **Authorization**: a sidecar contributed by another team
- **Rate limiting**: a sidecar contributed by another team
- **Access logging**: Envoy native, inside the HTTP connection manager filter chain
- **Routing, path matching, websocket handling**: Envoy native, via the template system in Sovereign

The sidecar model here is worth unpacking. For the simpler edge features, Envoy handles everything natively via filter chains. For features complex enough to require separate logic — authentication in particular — the team ran containers co-located on the Envoy host, communicating via Envoy's [external processing (`ext_proc`)](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_proc_filter) or `ext_authz` gRPC interfaces. The sidecars also receive dynamic configuration at runtime, following the same controllable-at-runtime principle as the proxy configuration itself.

The value proposition the speaker states directly: imagine if a thousand development teams each had to implement all of this themselves. The cost — in engineering time, in inconsistency, in security surface — would be enormous. The centralised platform absorbs that cost once.

## The Migration Problem

Building the platform took roughly two years. Getting Atlassian's existing products — Jira, Confluence, Bitbucket, Statuspage, and others — onto it took another two years.

Adoption was enforced rather than encouraged. The underlying internal deployment platform was changed so that services could no longer expose themselves publicly via the old basic load balancer. If you wanted your service to be publicly accessible, you had to configure the centralised edge infrastructure. That is a stronger move than it might appear. It removed the path of least resistance. It made using the platform the only option rather than the better option.

It also surfaced a real engineering principle: building something is the easy part. The hard part is changing an existing system piece by piece, while it is running, without breaking it, while other teams depend on it. The speaker describes this well:

> *"Building something is easy. Changing it and making sure that you can still change it over time is difficult. Because as you change things, it slowly becomes harder to change. Things start to get coupled."*

That observation about coupling and code churn is one of the more quietly useful things in the video. The speaker describes churn — the areas of a codebase that keep changing — as a smell. Once you notice where the churn is concentrated, that tells you something about where the design is under stress. The parts that should be stable are not. Something is coupled that should not be.

This is also where the video has something to say about AI-assisted development, and I think it is exactly the right thing: the concern is not AI writing code. The concern is code written by someone who does not fully understand the system, which then becomes someone else's long-term maintenance problem. The churn gets worse. The coupling gets denser. And the next person who needs to change it inherits the cost.

## The Non-Technical Bits Are Interesting Too

The final eight minutes of the video cover things that do not often appear in architecture retrospectives: diplomacy, conflict, mentoring, and what it means to stay curious in a large organisation for a long time.

The speaker is honest about having experienced personality conflicts across eight years and multiple managers. Their observation is that the only productive response is self-awareness — understanding your own patterns, understanding the other person's patterns, and trying to see conflicts coming before they escalate into something that affects the work.

On mentoring, they make a distinction I find useful: the difference between structured mentoring (answering questions, guiding development deliberately) and peer knowledge-sharing (breaking down complex topics for colleagues, building shared mental models). The speaker says they struggled more with the former and excelled at the latter. I think a lot of experienced engineers would recognise that distinction. Formal mentoring requires a specific discipline of restraint — letting someone figure something out rather than solving it for them — that is genuinely harder than it sounds.

## A Few Links Worth Following

This is the kind of architecture that has real depth you can explore outside the video:

- [Envoy Proxy](https://www.envoyproxy.io/) — the data plane at the heart of this platform
- [xDS API Protocol](https://www.envoyproxy.io/docs/envoy/latest/api-docs/xds_protocol) — the dynamic configuration protocol that makes the whole thing viable
- [Open Service Broker API specification](https://www.openservicebrokerapi.org/) — the provisioning interface standard the broker implements
- [Sovereign on Bitbucket](https://bitbucket.org/) — the speaker's open-sourced xDS control plane (search for "Sovereign" — they mention it is public at time of recording)
- [FastAPI](https://fastapi.tiangolo.com/) — the Python framework both the broker and Sovereign are built in
- [HashiCorp Packer](https://www.packer.io/) — the AMI build pipeline tooling
- [SaltStack](https://saltproject.io/) — the configuration management layer inside the AMI build
- [Envoy ext_authz filter](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_authz_filter) — how the authentication sidecar is connected to the proxy
- [Envoy ext_proc filter](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/ext_proc_filter) — the external processing filter for more complex sidecar logic
- [AWS CloudFormation](https://aws.amazon.com/cloudformation/) — the infrastructure-as-code layer for the fleet deployment

The video itself is worth the forty minutes. The speaker is clear, the architecture is coherent, and the honesty about the parts that were hard — adoption, migration, the slow accumulation of coupling — makes it more useful than most conference talks. If you are building platform infrastructure or thinking about centralised edge services, this is a superb working example of what that looks like at real scale.
