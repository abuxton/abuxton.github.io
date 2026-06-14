---
layout: post
title: "Using HashiCorp Packer to Build a Private Docker Registry"
date: 2026-06-14 19:00:00 +0000
categories: [development, docker, terraform]
tags: [packer, hashicorp, docker-registry, private-registry, terraform, aws, infrastructure]
---

I have been using [HashiCorp Packer](https://developer.hashicorp.com/packer) to build machine images for a few related problems, and one of the more interesting ones has been the question of how to make container images available quickly and reliably when you do not want to depend on a public registry at runtime.

That is the background to [abuxton/packer](https://github.com/abuxton/packer), a repository of Packer templates for building images across GCP, AWS, Azure, and VMware. The thread running through several of those templates is simple: build images that already know how to serve, cache, or preload the containers you need.

## Why a Docker registry matters

A Docker registry is the service that stores and distributes container images. In the public internet case that usually means Docker Hub or a vendor registry. In a more controlled environment it can also mean a private or local registry that sits close to the workloads using it.

That distinction matters. A local or private registry can:

- reduce repeated pulls from public registries
- lower egress costs
- improve startup times for frequently used images
- make environments more resilient when outbound internet access is restricted
- give you tighter control over what images are available internally

The [Sysdig overview of Docker registries](https://www.sysdig.com/learn-cloud-native/what-is-a-docker-registry) is a useful general explanation of the model. What interested me here was not the theory on its own, but the practical question of how to bake that model directly into machine images.

## Why Packer is a good fit

Packer is useful because it lets you define image creation as code. Instead of documenting a long manual build process for a base VM, you describe the desired image once and let Packer reproduce it consistently.

That is especially helpful for registry-based workflows. If the goal is to have a machine boot with Docker installed, a local registry configured, and selected images already available, that is exactly the kind of repeatable setup Packer is designed for.

In the [packer documentation](https://developer.hashicorp.com/packer/docs), the core idea is repeatable image builds across platforms. In practice, that means the same pattern can be applied to GCE images, AMIs, Azure managed images, or vSphere templates without treating the image as a one-off snowflake.

## What the `abuxton/packer` repository is doing

The repository currently includes a few related builds, but the most relevant ones are these:

- `ubuntu-docker-mirror` builds an Ubuntu image with a Docker Registry v2 pull-through cache
- `ubuntu-docker-local-container` builds an image that preloads a chosen container into a local registry
- the `tfe-local-mirror-*` builds preload Terraform Enterprise into a local registry for GCP, AWS, Azure, and VMware

The `ubuntu-docker-mirror` image is probably the clearest expression of the idea. It installs Docker, runs `registry:2`, configures it as a pull-through cache for Docker Hub, and points the local Docker daemon at `http://localhost:5000` as its registry mirror.

That means first use pulls from upstream and caches locally, while later pulls are served from the machine itself. It is a small architectural change with useful operational consequences.

## Private registry versus local registry

It is worth being precise here because the terms are often blurred together.

A **private registry** is mainly about ownership and access control. It is not public, and you decide who can push and pull.

A **local registry** is about placement. It lives close to the runtime environment, often on the same machine or inside the same network boundary, to reduce dependency on distant external services.

A system can of course be both. The pattern I have been working towards is usually local first, and then private as the surrounding infrastructure matures.

That is also why these images are useful beyond simple caching. If you are deploying into restricted networks, running Terraform Enterprise in controlled environments, or trying to reduce the blast radius of external registry outages, a baked-in local registry becomes part of the deployment design rather than an afterthought.

## Where the Terraform work fits

The next logical step after building the image is deploying it properly.

That is what [PR #10 in `abuxton/packer`](https://github.com/abuxton/packer/pull/10) moves towards. It adds Terraform code to deploy the `ubuntu-docker-mirror` concept as a horizontally scalable service on AWS, including:

- an Auto Scaling Group across private subnets
- an Application Load Balancer across public subnets
- CloudWatch alarms and scale policies
- Route 53 DNS wiring
- encrypted storage and IMDSv2-enforced instances
- Terraform native tests and example configuration

That matters because a useful registry pattern should not stop at image creation. Packer gives you the image. Terraform gives you the repeatable runtime shape around it.

Taken together, the two tools define a clearer workflow:

1. build a machine image that already contains the registry behaviour you want
2. deploy that image as infrastructure with explicit networking, scaling, and DNS
3. consume the registry through a stable internal endpoint rather than relying directly on public image sources

## Why I find this pattern interesting

There is a broader engineering point here. We often talk about infrastructure as code at the provisioning layer, but image construction is part of the same story. If the reliability of your platform depends on what is inside the machine at boot time, then that build process deserves the same level of repeatability as the Terraform that follows it.

Using Packer for registries makes that relationship very explicit. The image is no longer just a generic Ubuntu base. It is an opinionated runtime artifact that already carries operational intent: cache this upstream, keep this container local, make this service available even when the internet is slow, expensive, or unavailable.

That is the direction I have been pushing in the `abuxton/packer` repository. Less manual setup after instance launch. More intentional image construction before deployment. And increasingly, Terraform alongside it so the resulting registry can be deployed as a real service rather than a clever one-off VM.

If you want to follow the work, the starting points are the main [packer repository](https://github.com/abuxton/packer), the [Packer documentation](https://developer.hashicorp.com/packer/docs), and the ongoing infrastructure work in [PR #10](https://github.com/abuxton/packer/pull/10).
