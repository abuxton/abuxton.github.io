---
layout: post
title: "Local Git Remotes: Backups, Hand-offs, and Temporary History"
date: 2026-11-12 11:41:56 +0000
categories: [development, git]
tags: [git, backup, command-line, filesystem, version-control]
---

There is a point in most terminal sessions where I want permission to try
something without first arranging a full change-management ceremony. It might
be an Nginx configuration, a script copied from a ticket, or a directory of
notes that is about to become a small pile of experiments.

For one file, Bash has a very good answer:

```bash
cp nginx.conf{,.bak}
```

Brace expansion turns that into `cp nginx.conf nginx.conf.bak`. It is fast,
obvious, and has almost no setup cost. If I need to undo one edit, I can
compare the files or copy the backup back. That is a real tool, not a bad
version of Git.

It stops being comfortable when the change crosses several files, I want to
know *why* I made a change, or I need to compare two attempts. At that point,
a small local Git repository earns its place. If I later need to move the
repository or keep a copy on independent storage, a bare local remote is the
next tool. The distinction matters: local history, a local remote, and a
backup solve different problems.

<figure>
  <a href="https://xkcd.com/1296/">
    <img src="https://imgs.xkcd.com/comics/git.png"
         alt="XKCD comic 1296, Git"
         style="max-width: 100%; height: auto;">
  </a>
  <figcaption>
    <a href="https://xkcd.com/1296/">XKCD 1296: Git</a> by Randall Munroe.
  </figcaption>
</figure>

## A `.bak` file solves a small, real problem

The copy is the right choice when all of these are true: one file is changing,
one rollback point is enough, and nobody needs to inspect a history.

```bash
cp nginx.conf{,.bak}
vim nginx.conf
diff -u nginx.conf.bak nginx.conf
```

It is worth knowing the limits before a useful shortcut turns into a false
sense of safety. Running the same command again overwrites `nginx.conf.bak`.
Use a different suffix, a timestamp, or `cp -i` when that matters. More
importantly, the copy says nothing about related changes in `sites-enabled/`,
an accompanying systemd unit, or the reason the configuration changed. A
collection of files named `.bak`, `.bak2`, and `.final-really` is history, but
not history that helps much under pressure.

That is where Git becomes useful. The point is not to convert every scratch
directory into a project with an issue tracker. It is to get named,
inspectable checkpoints over the files that change together.

## Start with disposable local history

For a directory where I expect to make a few reversible changes, this is the
smallest useful repository:

```bash
cd ~/work/config-experiment

# Write .gitignore first if the directory contains secrets, build output,
# machine-specific values, or other files that must not enter history.
git init
git add .
git commit -m "Checkpoint before experimenting"
```

The ordering is deliberate. `git add .` stages files; it is not `git -a .`.
The latter is not a Git command. `git commit -a` is real, but it stages only
modifications and deletions of files Git already tracks. It will not pick up a
new configuration file, and it cannot rescue an ignored file you never meant
to commit.

Then work normally:

```bash
# Edit the proxy settings, then check exactly what changed.
git status
git diff

git add nginx.conf sites-enabled/app.conf
git commit -m "Try alternate proxy settings"
```

This keeps the useful questions close to the work. What changed? `git diff`.
What did I try yesterday? `git log --oneline`. Which exact version of one file
should I put back?

```bash
git log --oneline
git diff HEAD~1 -- nginx.conf
git restore --source=HEAD~1 -- nginx.conf
```

`git restore` makes the intent clearer than older checkout-based examples:
take this tracked path from that revision and write it into my working tree.
Review the diff before committing the restoration. It is still a change, even
when it feels like an undo button.

This repository can be temporary. When the experiment is genuinely over, the
following removes Git's metadata but leaves the working files in place:

```bash
rm -rf .git
```

That is a deliberate disposal step, not a backup strategy. It removes every
local commit, branch, tag, stash, and repository setting. If the history has
not been copied or pushed elsewhere, it is gone.

## A local remote is a repository without a working tree

A remote is useful when the history needs to live somewhere other than the
working directory, or when another machine needs to clone it. The conventional
target is a **bare repository**: Git data without a checkout alongside it.

For example, an external drive mounted at `/Volumes/BackupDrive` can hold a
repository for this experiment:

```bash
mkdir -p /Volumes/BackupDrive/git
git init --bare /Volumes/BackupDrive/git/config-experiment.git
```

Connect the working repository to it with a name that says what it is:

```bash
cd ~/work/config-experiment
git remote add backup /Volumes/BackupDrive/git/config-experiment.git

git push backup --all
git push backup --tags
```

I prefer `backup` to `origin` here. It tells the next person--which is often
me next month--that this is not necessarily the canonical hosted repository.
`--all` pushes local branches and `--tags` pushes tags. Neither command makes
a complete filesystem backup: untracked and ignored files are absent unless
they were deliberately included in Git.

The remote supports normal Git workflows. Recover the work, or create a
second checkout on another machine, with:

```bash
git clone /Volumes/BackupDrive/git/config-experiment.git restored-config-experiment
```

This pattern works well for an encrypted mounted volume, a private LAN share,
an external disk used to hand work between machines, or a network-isolated
environment where a hosted service is unavailable. It is also a good way to
learn push, fetch, and clone without sending test repositories to a public
host.

## The word "backup" has an important condition

A bare repository on the same physical disk as its working tree is not a
backup against disk failure, theft, ransomware, or accidental deletion of the
disk. It separates repository state from the directory; it does not create
independent storage. The external drive example is useful because it supplies
that independence, at least until it is mounted back into the same failure
domain.

Git also asks you to be explicit about what belongs in history. Do not solve
that by casually adding credentials, private keys, or generated secrets.
Those are security boundaries, not missing backup files. Use the appropriate
secret store and a proper backup system for data Git should not contain.

A remote is only as current as the most recent successful push. Check it:

```bash
git remote show backup

# Replace main with the branch you are using.
git log backup/main..main --oneline
```

The final command lists commits present locally but absent from the remote
branch. An empty result is a useful signal, not proof that every required file
is protected. Check untracked files with `git status`, and test restores for
work that matters.

Avoid putting an actively written bare repository inside a synchronised folder
and hoping the sync client behaves like Git. Concurrent writes and sync
conflicts can corrupt the expectation of a remote. Use an external drive, a
managed network share with a clear ownership model, or a supported hosted
service for active multi-machine collaboration. I would also leave
`git push --mirror` out of a default backup recipe: it can delete remote refs
to make the remote match the local repository.

## A bundle is another useful offline tool

When the goal is one portable repository snapshot rather than a remote that
accepts pushes, `git bundle` is often simpler:

```bash
git bundle create config-experiment.bundle --all
git clone config-experiment.bundle config-experiment-copy
```

The result is a single file that Git can clone or fetch from. It is useful for
archival hand-offs and isolated environments. It still contains Git objects,
not every file in the directory, and it still needs independent storage if it
is meant to protect against loss of the source device.

## Pick the smallest tool that preserves the thing you need

| Need | Prefer | Why |
| --- | --- | --- |
| One rollback for one file | `cp file{,.bak}` | Lowest setup cost |
| Reviewable checkpoints across related files | Local Git repository | Named commits and useful diffs |
| Offline transfer of repository history | Bare local remote | Normal clone, fetch, and push workflow |
| One portable archive | `git bundle` | A single Git-readable file |
| Protection from device loss | Separate backup system or hosted remote | Independent storage and retention |

The useful rule is straightforward. Copy a file when you need one quick
rollback. Initialise a local repository when you need to understand a series
of related changes. Add a remote when the history must leave the working
directory or travel to another machine. Call it a backup only when the copy
is on storage that can survive the failure you are planning for.

For the details behind these commands, see Git's documentation for
[`git init`](https://git-scm.com/docs/git-init),
[`git push`](https://git-scm.com/docs/git-push), and
[`git bundle`](https://git-scm.com/docs/git-bundle), plus the useful starting
points from [Love the Penguin](https://lovethepenguin.com/the-fastest-way-to-back-up-a-file-in-bash-youre-probably-not-using-it/)
and [The Horrors](https://thehorrors.org.uk/snippets/git-local-filesystem-remotes/).

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
