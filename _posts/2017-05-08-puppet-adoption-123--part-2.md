---
layout: post
title: "Puppet Adoption 123 - part 2"
category:
tags: [post,article,blog,abc,puppet,devops,workflow,adoption]
image:
 feature:
 credit:
 creditlink:
comments: false
share: true
---
Obviusly if you're here reading this post you have first read [Puppet Adoption 123 - part one](https://abuxton.github.io/puppet-adoption-123/). yeah, yeah quick go do that.

Ok so now `Part 2`. Part one linked to all the things you really know to get Puppet installed, but it also answered 3 simple questions that are repeated by everyone, everywhere.

* Where do we start?
* Do we do everything at once?
* What should we manage with Puppet?

And I did answer them.

* Where do we start? By assessing your current process and putting Puppet at the end of it. Honestly simply install Puppet every where.
* Do we do everything at once? No, see that was easy.
* What should we manage with Puppet? The smallest possible things first, after you have assessed the gains and benefits to prioritise which one of them you want to do first.

I also said you won't believe me, no one ever does. So for Part Two, I'm going to answer the first question in more detail.

##  Where do we start?
The answer is simply `By assessing your current process and putting Puppet at the end of it. Honestly simply install Puppet every where`.

Right now you are either building each server or node from scratch with repetative practices, re using AMIs, templates, ISOs or Golden Images of some form, or mixing the two practices with a set of custom tools or workflows that at least apply the same scripts semi dependably on each new server. You may even have installed Puppet in a selection of hosts and found gains on those hosts that is now driving you here to work out how to best repeat those gains on the rest of your estate.

What I'm saying is don't actually Puppertize (yes it's a term) anything. Simply install Puppet and take a look around.

Puppet out of the box brings you [Facter](https://puppet.com/blog/facter-part-1-facter-101) a configurable and extensible system information query tool. Puppet infact does not work very well without it, so it's a dependable component of Puppet regardless of if you're utilising the enterprise (PE) or Open Source Solution (POSS).
When you marry this with one of the other independant tools of Puppet [Mcollective or MCO](https://docs.puppet.com/mcollective/) or even just by making use of the [Puppet Console (PE only)](https://docs.puppet.com/pe/latest/CM_overview.html)
You can simply see inventory of your estate in it's default state, and you can use these tools to expand that inventory [https://puppet.com/blog/guest-post-puppet-mcollective-make-for-quick-inventory-queries-part-1-of-2](https://puppet.com/blog/guest-post-puppet-mcollective-make-for-quick-inventory-queries-part-1-of-2)

Your soul commitment to Puppet to get this capability is deployment of a Puppet Master and an agent per node or server, if using PE you even can include certain [network devices](https://docs.puppet.com/pe/latest/sys_req_os.html#supported-network-devices), and you can use this on any of the [agent supported platforms](https://docs.puppet.com/pe/latest/sys_req_os.html#puppet-agent-platforms).
The only update required is to add Puppet install to your build scripts or workflows, and you can get all this information on a per server or node bases with out the data correlation. That's not all this gives you, every thirty minutes as a service with a centralised Puppet Master you will get an updated report of these Facter Facts, and the capability to adhoc query them. Think about if just that feature as value to you and your organisation. If you want more ideas than simple reports take a look at [Mcollective agents](https://docs.puppet.com/mcollective/plugin_directory/index.html#agents) which let you do a number of orchestration or query actions with or without use of Puppet, and can be extended with a veriety of plugins such as the [Yum agent](https://github.com/wolfspyre/mcollective-yum), which allows you to query and drive the yum query, functionality and reporting across yum dependant Operating Systems.

So start there, install Puppet Enterprise, build a central Puppet Master and deploy a Puppet agent as standard on your hosts, servers or nodes. Get used to the data this gives you access to and think about how you can make use of that data or what data you could use to get further use of simply that level of Puppet deployment.

I'll be back with further parts.. Salute
