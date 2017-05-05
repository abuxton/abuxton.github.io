---
layout: post
title: "Puppet Adoption 123 - part 1"
category:
tags: [post,article,blog,abc,puppet,devops,workflow,adoption]
image:
 feature:
 credit:
 creditlink:
comments: false
share: true
---
What are the three most common questions about the adoption of Puppet? Simple;

* Where do we start?
* Do we do everything at once?
* What should we manage with Puppet?

Even on my return to Puppet, these are still the three most common questions I get asked, at least these are the questions we can't simply answer with RTFM or LMGTFY! (If you don't know what they mean google them, ironically).

Before I try to answer them let me talk about what normally gets people and organisations to these questions.

## Learning how to Puppet
Puppet provides what I consider the best of the online documentation for any of the configuration management products, it's not perfect but everything is there when you get used to the idiocies of how the search works and the divergance between Puppet Enterprise (PE) and Puppet Open Source Sollution (POSS).

Seriously want to know how to use Puppet go try (learn.puppet.com)[learn.puppet.com) work your way through the various Quests. Want to skip that and just install it [htts://docs.puppet.com/pe/latest/install_basic.html](htts://docs.puppet.com/pe/latest/install_basic.html),  [htts://docs.puppet.com/pe/latest/quick_start.html](htts://docs.puppet.com/pe/latest/quick_start.html) and [htts://docs.puppet.com/pe/latest/console_cert_mgmt.html](htts://docs.puppet.com/pe/latest/console_cert_mgmt.html) will get you there. Understand how to deploy it, but need to understand the work flow Puppet support as best practices [htts://docs.puppet.com/pe/latest/cmgmt_managing_code.html](htts://docs.puppet.com/pe/latest/cmgmt_managing_code.html) and [htts://docs.puppet.com/pe/latest/code_mgr.html](htts://docs.puppet.com/pe/latest/code_mgr.html) are the current best practices.
If you just want to want to get straight to managing your servers or nodes, even just your desk top then Roles and Profiles [htts://docs.puppet.com/pe/latest/r_n_p_intro.html](htts://docs.puppet.com/pe/latest/r_n_p_intro.html) relates to how you use the modules you develop [htts://docs.puppet.com/puppet/4.9/modules_fundamentals.html](htts://docs.puppet.com/puppet/4.9/modules_fundamentals.html) or how you impliment community modules from the Forge [htts://forge.puppet.com](htts://forge.puppet.com).

Yeah even writing out that wall of text provides a small insight into what eventually raises the three questions I origionally presented. So let me put a question in our head.

## What do you do instead of Configuration Management?

* Manual efforts.
* Reuse images whether they are AMIs, ISOs or templates.
* Make use of custom scripts, or in reality various custom scripts depending on your staff and their individual skill levels and choices of prefered technology stack.

The various levels of engagement with these concepts and processes, the various issues with their reuse and usability and the varying cost in money, time and effort in both use of infrastructure, hardware and personell development terms, are what make configuration  management so appealing.

So as part of these articles on Puppet adoption or indeed adoption of `Configuration Management` let me give you the short answer to the three questions.

* Where do we start? By assessing your current process and putting Puppet at the end of it. Honestly simply install Puppet every where.
* Do we do everything at once? No, see that was easy.
* What should we manage with Puppet? The smallest possible things first, after you have assessed the gains and benefits to prioritise which one of them you want to do first.

Really it's that easy. You won't believe me, I know you won't, after all I've told dozens of customers this over several years now and noone ever does. i will grow these articles out to discuss the Hows, Whys and Wherefores with Puppet and Configuration Management Systems. But you'll have to stay tuned.  
