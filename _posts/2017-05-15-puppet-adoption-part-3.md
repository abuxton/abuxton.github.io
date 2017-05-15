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
Obviously, if you're here reading this post you have first read [Puppet Adoption 123 - part one](https://abuxton.github.io/puppet-adoption-123/), and [Puppet Adoption 123 - part 2]https://abuxton.github.io/puppet-adoption-123-part-2/yeah, yeah quick do that or remember to do it later.

## Do we do everything at once?
This is the second of our three questions, and the easiest to answer. Although the question comes up again and again, in many forms.

* How do we do everything at once? You don't!
* Who should do all the things? No one, work out your prioritize and scope of responsibilities.
* Would you change this? No, not unless that is what is causing your problems, then see prioritize and scope.
* We like using this script, and it's a lot of work to rewrite it. Ok, don't but how do you deploy it and see how successful it was? Can puppet help with that for you?
* We have really long runbooks, or templates where do we put Puppet. At the end, to start with.

That's right I am not saying install Puppet and then replace everything, I know you can't, won't, and will fail if you try.
In part two, I simply said `By assessing your current process and putting Puppet at the end of it. Honestly just install Puppet everywhere.` And I went on to discuss using Facter and custom or external facts, and the MCollective inventory to understand your platform, to take inventory. Now we are going to carry on with that slow ramp up approach.

We are not even at this stage going to manage any of your package, or services directly with Puppet. We're going to talk about what you want to do, and where you are currently.

### What do you want to do?
So even in DevOps (*Ops, SRE, whatever you want to call it and however you want to spell, hyphen or capitalize it), you have two leanings, you are either dealing with development tasks and considering ops or dealing with operations tasks and considering operations. (gee that's a really over simplified version, please forgive me)

Either way, you want to do the same things, stabilise your environment and deploy your applications. For operations leaning staff that's ensuring each node, server or host is deployed and patched with key services that support the infrastructure deployed, configured and running or disabled, with access controlled. While the development approach leaning people want to have access to a dependable host, server or node(let us use a server from here on out) they can deploy their application to and any supporting dependancies, such that they can control the configuration dependancies and successfully run the application. Wow, that is a mouthful, and I've not even mentioned Puppet.

That's be cause to do either of these simplified tasks, unless through some miracle you are in an unopinionated nirvana with a [Greenfield](https://en.wikipedia.org/wiki/Greenfield_project) project, you have existing tools, processes, and configuration. That brings us to the where.

### Where you are?
Most likely you are building infrastructure and or deploying applications with a mixture of images (AMI, ISO, etc...) and running complex imperative scripts on them to deploy applications and configuration change.  You may even have a build pipeline, Continuos X, Integration, or Deployment (C(X), C*, CI, CD) and some form of deployment tooling. But we are talking about Puppet and Configuration Management (CM). So `Where do we start?` in that case.

### Where do we start?
Well if you followed the other parts, you've installed Puppet, you've simply added it to the image or the runbook applied to the image, or it's simplified All-in-one installation to the relevant script you run as part of a server deployment. Now we need to look at how you should look at those images, scripts, and processes.

#### Puppet and Images
Images are static components that are deployed or `spun up` when a server is required. I would never tell you to replace them; they are your tool of choice. What I would tell you to examine is how do you build them! Do you build your images at all? If so what applications or packages do you add or remove to make your image specific to your needs, and how? Could simply installing Puppet first and running codified resources help make the process quicker, auditable, repeatable and more manageable. I can't promise it will, but these are what you should be considering. Also, take a look at  [forge.puppet.com](http://forge.puppet.com), are some or all of your current regular tools and tasks already available has Puppet modules, why reinvent the wheel if you don't need to. Also consider any code you write in Puppet for this task can be made available on the live service for assurance that these configuration changes are not overwritten or if they are, they are in fact regressed and reported.

#### Puppet and customization, runbooks and custom tools
For one reason or another (access, preference, existing process) even once you deploy the server from an image I imagine you run further scripts on the server to make further changes, deploy packages, and applications whether tools or your product.

Runbooks are a popular mechanism and or concept that run after boot and generally make changes at the operating system level to prepare the servers infrastructure for the developer's product deployment. I told you to add Puppet at the end, but once your happy with that it's simply a case of reviewing the runbook to see if you can move Puppet up the flow, and or replace components of what it does with Puppet core resources such as Package, File, Service, or resources from modules such as the Firewall module( [puppetlabs-firewall](http://forge.puppet.com/puppetlabs/firewall)), leading to reordering the flow and Puppets deployment.

Additionally even after the Images and the Runbook have been deployed and run, most organizations from experience have custom scripts or C(X) pipelines that make further changes. Maybe it's also a case that you do not have the responsibility, capability or access to alter the use of Images. As such Puppet is either the last step in the images or last step in your runbooks etc. Maybe it's a step in your customization tools and or scripts.  As such with the additional scripts you should be considering how you use them as well as what they contain.

When considering custom scripts and tools, look at how you deploy them today, how you manage them. Are they all contained and documented? If not maybe simply deploying them as files from a module with File resources to assure their presence when you need to apply them is the first step with Puppet.
Do the scripts install packages? If so can the Package resource be used to replace that functionality, similarly can any services on the host managed by these scripts be managed with the Puppet Service resource. As you start to think about those things, Puppet classes, modules even will grow from the scripts and the scripts will reduce in complexity and requirement. You do not have to replace them wholesle at step one. There is real value in simply deploying them with a File resource and looking at the features of the [Exec](https://docs.puppet.com/puppet/latest/types/exec.html) resource for executing them, while also providing reporting, auditing and assurance mechanisms.
In this way you can bring all these scripts, tools and applications under unified processes, maybe that is all you need to chain them into your intended C(X) processes.

Obviously, this is first steps, but small iterated changes will always be more attainable and more acceptable and accessable to those involved in the changes. Meaning that success in small changes will open the door to more small changes and iterated successes in adoption, allowing for expansion of your coverage with configuration management and Puppet.

Anyway, that's enough for you to digest for now, chack back later for part four. 
