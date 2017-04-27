---
layout: post
title: Complimentary not Competition 
modified: 2016-02-29
category: articles
tags: [post,article,blog,blogger,digitaladept]
image:
  feature:  CMs.jpg
  credit:   https://www.getfilecloud.com/blog/
  creditlink: https://www.getfilecloud.com/blog/
comments: false
share: true
---

Competition in the technology sector is alive and well, several parties promoting their variant of similar ideas with alternative technology stacks, mind sets and approaches to providing the same platforms, applications or services. All competing for hearts and minds of Developers, System Administrators and technology department leadership at all levels.

Personally I feel some times the line between where they are competitive and complimentary is more than blurred, Why can't these solutions co exist?  Does it have to be Puppet or Salt Stack?  When is the right place to deploy a Wordpress install over a  plain HTML and CSS website. What is the use case for MySQL and PostgreSQL or even Oracle. I work for PuppetLabs as one of the EMEA Professional Services Engineers, time and time again I’m seeing where what are considered competitors by the majority are being used in complimentary manners. 

Ansible, Salt Stack, CFEngine, Chef, Foreman and Puppet are normally involved in some Frankenstienesq competitive free for all in peoples minds. This leads to them being discussed(read argued about) with passion and venom between the developers, administrators and architects, but what about treating them differently! I know very little about CFEngine, but feel free to expand this discussion under your own thoughts to that product. Lets take a look at these products and the cross over in their application and use case.

Ansible and Salt Stack genuinely and generally are System administrators favourites both have the ability to arbitrarily deploy and run scripts conveniently and with little over head, Foreman is seen as a provisioning service more than a configuration manager leveraging Puppet for that role. Puppet is favoured by the administrators and architects for its auditing and control approach, while Chef is seen as the developers favourite, if the developer knows Ruby or is willing to learn it. It's comments like the last one that create the cross over, what if they are not? what if it's a Python developer house, then surely Salt Stack is the obvious choice with it's Python based language. What if your running Windows  then your not even going to be able to use Ansible, and some fear with its acquisition by RedHat, then maybe its days on anything but RedHat are numbered.    

I've been lucky in my various guises as a developer, system admin, launch manager , Ops guy, various Devops based roles and Professional Services Engineer to see a large number of varying quality deployments and utilisations of most technology stacks.  This leads me to this article to be honest, and a understanding of the boundaries they cross and how to use them in a complimentary way.

More than once now I’ve seen Forman provision the technology stack that deploys Puppet using either Ansible or Salt to deploy Puppet for Brown field systems to maintain functional equality in the infrastructure. Puppet is used for to audit the system for the operations team and deploy the application deployment tools of choice, and that tools more than once as been Octopus, Chef or Salt Stack. 

I’ve seen this process in a number of variants all with good reason and with well developed roll outs and dependability. AWS and VSphere used to deploy nodes driven by Puppet, Foreman or even Vagrant. Puppet and or Salt boot strapped onto the nodes. Ansible, Salt and MCollective used interchangeably for orchestration, while Facter and Ohai are used for inventory or discovery. Puppet and Chef deployed for configuration management Puppet used by the operations team for auditing alone, while Chef is used for application deployment, or Octopus for those solely Windows based teams. But this is not a single case, this is one example of the matrix of variants I’ve seen, encountered and heard of successfully running the infrastructure of major enterprises around the world.

So I’m not talking about a new idea! I’m talking about it because it’s a successfully used approach. Though crossing the barrier between products is not just a thing that happens, you need to plan it, document it, define the spheres of responsibility and communicate with the product users. Chef can’t edit a file Puppet manages! well it can but first it should be communicated so that they compliment each other and not compete for control of the resources. But how do you accomplish that?
 
Communication and tooling is how, from simply advertising the sphere of responsibility, to messaging where these complimentary products are in effect. 

I started to write the rest of this post, I started to list out the communication methods, the tools, possible solutions. Then I started to realise the expanse of that task, and I stopped. I’ve planted the thought, I have some ideas on how to progress those lists of tools. So maybe a few posts will appear on this subject or a talk to let me give it that thousand feet overview I think it needs, for now let me leave you thinking how to communicate this, and what tools would you create or use. 






 [jekyll]:    http://jekyllrb.com
