---
title: ":ramen: Indigo, minimalist Jekyll theme, updates for manifest"
layout: post
date: 2017-04-29 00:00
tag: jekyll
image: https://koppl.in/indigo/assets/images/jekyll-logo-light-solid.png
headerImage: true
projects: true
hidden: true # don't count this post in blog pagination
description: "Project post about updating Jekyll themes to have manifests."
category: project
author: adambuxton
externalLink: false
---

![Screenshot](https://raw.githubusercontent.com/sergiokopplin/indigo/gh-pages/assets/screen-shot.png)

This blog uses - Indigo Minimalist Jekyll Template - [Demo](http://sergiokopplin.github.io/indigo/).

Amusingly this allowed me to provide a demo project page as the theme as not been maintained and Jekyll now requires a manifest for a theme to install successfully.

---

First I registered a bug [Check it out](https://github.com/sergiokopplin/indigo/issues/226) here to register the issue.

```shell
$rake theme:install git=https://github.com/sergiokopplin/indigo.git
Cloning into './_theme_packages/_tmp'...
remote: Counting objects: 2019, done.
remote: Total 2019 (delta 0), reused 0 (delta 0), pack-reused 2019
Receiving objects: 100% (2019/2019), 2.85 MiB | 228.00 KiB/s, done.
Resolving deltas: 100% (1086/1086), done.
Checking connectivity... done.
rake aborted!
Errno::ENOENT: No such file or directory - ./_theme_packages/_tmp/manifest.yml
/Users/abuxton/src/abuxton.github.io/Rakefile:335:in initialize' /Users/abuxton/src/abuxton.github.io/Rakefile:335:inopen'
/Users/abuxton/src/abuxton.github.io/Rakefile:335:in verify_manifest' /Users/abuxton/src/abuxton.github.io/Rakefile:316:intheme_from_git_url'
/Users/abuxton/src/abuxton.github.io/Rakefile:217:in `block (2 levels) in <top (required)>'
Tasks: TOP => theme:install
(See full trace by running task with --trace)
```

Then as is good practice I created a fork and development branch
[Check that out here](https://github.com/abuxton/indigo/tree/add-manifest%23226). Which I simply created a `manifest.yml` file for Segio.

```json
---
name : indigo
website : http://koppl.in/indigo/
description :  "A minimumlist theme for Jekyll + Jekyll-Bootstrap."
git_url : https://github.com/sergiokopplin/indigo
source_url : http://github.com/sergiokopplin/indigo
author:
  name : sergio kopplin
  email : sergiokopplin@gmail.com
  website : http://koppl.in

```

This means I could install the theme in local from my repository by cloning it from branch and using the `Rake theme:install name=indigo` command in Jekyll [read more about that here](http://jekyllbootstrap.com)

Finally before I forgot (as I commonly do) I commited the pull-request

```shell
abuxton@da-abuxton-mbp00:~/src/forks/indigo (add-manifest#226) $g remote -v
origin	https://github.com/abuxton/indigo.git (fetch)
origin	https://github.com/abuxton/indigo.git (push)
upstream	https://github.com/sergiokopplin/indigo (fetch)
upstream	https://github.com/sergiokopplin/indigo (push)
abuxton@da-abuxton-mbp00:~/src/forks/indigo (add-manifest#226) $g pull-request -m'update with manifest trivial new file to fix use of Rake theme:install'
https://github.com/sergiokopplin/indigo/pull/227
```

Hopefully Sergio will merge that for anyone else to use, in the meantime my blog is up and running.
