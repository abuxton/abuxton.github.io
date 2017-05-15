---
layout: post
title: "Puppet Adoption 123 - part 3"
category:
tags: [post,article,blog,abc,puppet,devops,workflow,adoption]
image:
 feature:
 credit:
 creditlink:
comments: false
share: true
---
Obviously if you're here reading this post you have first read [Puppet Adoption 123 - part one](https://abuxton.github.io/puppet-adoption-123/), and [Puppet Adoption 123 - part 2]https://abuxton.github.io/puppet-adoption-123-part-2/yeah, yeah quick go do that, or remeber to do it later.

## Do we do everything at once?
This was the second of our three questions, and the easiest to answer. Although the question comes up in many forms.

* How do we do everything at once? You don't!
* Who should do all the things? No one, work out your prioritise and scope of responsibilities.
* Would you change this? No, not unless that is what is causing your problems, then see prioritise and scope.
* We like using this script and it's a lot of work to rewrite it. Ok, don't but how do you deploy it and see how successful it was? can puppet help with that for you?
* We have really long runbooks, templates where do we put Puppet. At the end, to start with.

That's right I am not saying install Puppet and then replace everything, I know you can't, won't, and will fail if you try.
In part 2 I simply said `By assessing your current process and putting Puppet at the end of it. Honestly simply install Puppet every where.` And i went on to discuss using Facter and custom or external facts, and the MCollective inventory to understand your platform, to take inventory. Now we are going to carry on with that slow ramp up approach.

We are not even at this stage going to manage any of your package, or services directly with Puppet. We're going to talk about what you want to do, and where you are currently.

### What do you want to do?
So even in DevOps (*Ops, SRE, what ever you want to call it and how ever you want to spell, hyphen or capatilize it) you have 2 leanings, your either dealing with development tasks and considering ops or dealing with operations tasks and considering operations. (gee that's a really over simplified version, please forgive me)

Either way you want to do the same things, stabalise your environment and deploy your applications. For operations leaning staff that's ensureing each node, server or host is deployed and patched with key servcies that support the infrastructure deployed, configured and running or disabled, with access controlled. While the development leaning people want to have access to a dependable host, server or node(let us use server from here on out) they can deploy their application to and any supporting dependancies, such that they can control the configuration dependancies and successfully run the application. Wow, that is a mouthful, and i've not even mentioned Puppet.

That's becouse to do either of these simplified tasks, unless through some miracle you are in an unopinionated nirvana with a [Greenfield](https://en.wikipedia.org/wiki/Greenfield_project) project, you have existing tools, processes and configuration. That brings us to the where.

### Where you are?
Most likely you are building infrastructure and or deploying applications with a mixture of images (AMI, ISO, etc...) and  running complex impirative scripts on them to deploy applications and configuration change.  You may be even have a build pipeline, Continuos X, Intergration, or Deployment (CX, C*, CI, CD) and some form of deployment tooling. But we are talking about Puppet and Configuration Management (CM). So `Where do we start?` in that case.

### Where do we start?
Well if you followed the other parts, you've installed Puppet, you've simply added it to the image or to the run book applied to the image, or it's simplified All-in-one installation to the relevant script you run as part of a server deployment. Now we need to look at how you should look at those images, scripts and processes.

#### Puppet and Images
Images are static components that are deployed or `spun up` when a server is required. I would never tell you to replace them, they are you tool of choice. What I would tell you to examine is how do you build them! Do you build your own images at all? If so what applications, or packages do you add or remove to make your image specific to your needs, and how? Could simply installing Puppet first and running codified resources help make the process quicker, auditable , repeatable and more manageable. I can't promise it will but these are what you should be considering. Also take a look at  [forge.puppet.com](http://forge.puppet.com), are some or all of your current regular tools and tasks already available has Puppet modules, why reinvent the wheel if you don't need to. Also consider any code you write in Puppet for this task can be made available on the live service for assurance that these configuration changes are not over written or if they are, they are infact regressed and reported.

#### Puppet and customization, runbooks and custom tools
For one reason or another (access, preferance, existing process) even once you deploy the server from an image I imagine you run further scripts on the server to make further changes, deploy packages, and applications whether tools, or your product.

Runbooks are a popular mechanism and or concept that run after boot and generally make changes at the operating system level to prepare the servers infrastructure for the developers product deployment. I told you add Puppet at the end, but once your happy with that it's simply a case of reviewing the runbook to see if you can move Puppet up the flow, and or replace components of what it does with Puppet core resources such as Package, File, Service, or resources from modules such as the Firewall module( [puppetlabs-firewall](http://forge.puppet.com/puppetlabs/firewall)), leading to reordering the flow and Puppets deployment.

Additionally even after the Image and the Runbook have been deployed and run, most organisations from experiance have custom scripts or CX pipelines that make further changes. 
