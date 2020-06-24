---
layout: post
title: "Puppet Multi Tenancy "
category:
tags: [post,article,blog,abc,puppet,multi-tenancy]
image:
 feature:
 credit:
 creditlink:
comments: false
share: true
---
So in a brake from my articles on Puppet adoption, I decided that I'd like to write up some of my experiance and thoughts on `Multi-Tenancy`. Before I go any further, this is not thoughts on multiple users having access to shared or segregated Puppet and the configuration and instilation of Puppet per user with segregated or shared masters, That's a whole subject in it's own right. For this discussion I am speaking to the segregation of concern in any organisation in regards the tasks required of Puppet and the management of configuration in regard these concerns. With that in mind I won't be just speaking about Puppet, but ITIL and change management, security concerns and deligation, segregation of duty and concerns. The too long did not read (TL:DR) of that is who profides what requirments and why, and who fulfills what requirements where, with what and how, or the Where, What, Who and Why of DevOps.

If you were hoping for more on the Puppet Adoption series or you've not read them they're linked in the footer I'm sure, but just incase, they start with [Puppet Adoption 123 - part one](https://abuxton.github.io/puppet-adoption-123/) and I'll get back to them with Part 4 soon.

## Where, What, Who and Why of DevOps.

I realised when I started to think more deeply about this subject it quickly became clear that what we are talking about is really scope of `Influence`, `Concern`, `Capability` and `Visibility`, and the keys are knowing `Who` influences `Who` and `How`, `What` each party is `concerned` with, `Who` as the `capability` to affect the requirements, and `Who` needs visibility of `What` from the system.

So I broke this down, now it was `Who`, `What`, and `Where` in relation to `Influence`, `Concern`, `Capability` and `Visibility`. But I also realised this subject needs or warrents it's own multi-part artciles on multi-tenancy. Damn it.  So without much further adue.

## Who, What and Where of multi-tenancy
I'm going to think about it a little more and then provide articles on the subject, but my initial mind map looked like the below
![`Who`, `What`, and `Where` in relation to `Influence`, `Concern`, `Capability` and `Visibility` mind map]( https://abuxton.github.io/assets/images/pmt-mm.jpg)

**edit** 24th June 2020, 3 years and many miles later I came back to this.. Puppet as changed * A LOT * as such some of my thoughts have been norn out and others are now invalid. So you'll never see the rest of this post.
