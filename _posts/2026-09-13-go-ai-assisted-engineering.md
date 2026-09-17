---
layout: post
title: "Go Is a Better Review Surface for AI-Assisted Engineering"
date: 2026-09-13 09:00:00 +0100
categories: [development, go]
tags: [go, ai-agents, software-engineering, code-review, developer-tools]
---

> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)

Google's recent article, [Why Go is an ideal language for AI-assisted software
engineering](https://developers.googleblog.com/why-go-is-an-ideal-language-for-ai-assisted-software-engineering/),
makes a useful argument: as agents produce more code, our bottleneck moves from
writing it to reviewing, verifying, and maintaining it.

That shift makes Go more interesting. Not because an agent needs a special
language, or because Go makes generated code safe, but because Go reduces the
number of ways a change can be surprising. Its deliberately small language,
standard formatting, fast feedback loops, and integrated tools give both the
agent and the reviewer a clearer surface to work with.

I think that is a stronger case than "Go is good for AI." It is a case for
choosing tools that make engineering judgement easier when code arrives faster
than before.

## The scarce resource is review

An agent can write a plausible package, a set of tests, and a refactor in a
few minutes. That is useful, but it changes what needs protecting. The scarce
resource is now the attention needed to decide whether the change fits the
system, handles the awkward cases, and deserves to become someone else's
maintenance problem.

This was already true on teams. Most of us spend more time reading code than
writing it. Agent-assisted work turns up the volume. A pull request that once
took a day to produce can appear after a single well-scoped prompt, complete
with enough surrounding code to look reassuring.

The risk is not that the code looks unusual. It is that it looks familiar
enough to pass a tired review while being wrong at a system boundary: the
assumption about an API response, the retry that changes semantics, the
permission check omitted from a happy path, or the migration that only works
against an empty database.

Google describes Go as a platform rather than only a language. That matters
here. `gofmt`, the test runner, modules, static analysis, fuzzing, profiling,
tracing, and vulnerability tooling are not a collection of optional
afterthoughts. They establish common checkpoints for a change before a human
starts trusting it.

## Consistency is a practical advantage

Go's lack of syntactic novelty can feel restrictive when you first meet it.
There are fewer ways to express the same idea, and the formatter settles many
arguments before they begin. In an agent workflow, that restraint is useful.

When generated code follows familiar shapes, a reviewer can spend less effort
decoding style and more effort asking the important questions: is the error
handled at the right layer? Does this interface express the real boundary?
What happens with a partial response, a cancelled context, or an unexpected
input?

The same consistency helps an agent make smaller, more useful corrections.
Formatting is mechanical, so run it. Types are explicit, so compile the
package. Tests are part of the standard toolchain, so add a focused test and
run it before proposing the next change. The feedback is concrete rather than
an invitation to write a longer explanation of what might be correct.

None of this means Go has one perfect idiom. It does mean a codebase can make
its local conventions visible without needing a large framework to enforce
them. That is helpful for humans joining a project, and it is helpful when an
agent has only a limited view of the repository.

## The tools make a useful feedback loop

The compiler is an effective early filter for an agent's most ordinary
mistakes: invented fields, the wrong function signature, unused variables, or
a value passed across the wrong boundary. Go's fast edit-compile-test cycle
makes it cheap to use that filter repeatedly.

There is more available than compilation. The standard
[testing package](https://pkg.go.dev/testing) covers ordinary tests, benchmarks,
and fuzz targets. Native [fuzzing](https://go.dev/doc/security/fuzz/) is
particularly useful for code that parses, decodes, normalises, or handles
untrusted input: it gives the agent and the reviewer a way to explore cases
neither initially thought to name.

Dependency management is another quiet advantage. The
[module system](https://go.dev/ref/mod) gives a project a shared description
of its dependencies, while the checksum database records expected module
content. Go also provides [vulnerability management
guidance](https://go.dev/security/vuln/) and `govulncheck`, which reports known
vulnerabilities in packages that the code actually reaches.

That does not make the supply chain harmless. An agent can still suggest the
wrong dependency, misuse a safe package, or produce an unsafe design from
entirely standard-library code. But a strong standard library and a common
toolchain remove some reasons to add a new dependency for every small task.
Fewer moving parts are easier to review.

The maintainability argument extends beyond the first patch. Go's
[compatibility policy](https://go.dev/doc/devel/release#policy), portable static
binaries where they fit, `gopls`, and the evolving `go fix` tooling all support
code that can keep moving without a rewrite every time the surrounding
ecosystem changes. Agent-driven change makes that property more valuable, not
less. Fast generation can otherwise turn a modest amount of drift into a
large amount of cleanup.

## What I have found with tf-slate

While building [tf-slate](https://github.com/abuxton/tf-slate) with agent
assistance, I have found Go to be a good medium for getting from a described
task to a reviewable first pass. An agent can produce the unglamorous but
necessary structure quickly: a package boundary, command wiring, a small
interface, tests for a few expected cases, and the surrounding error handling.

The useful word there is *first*. The agent's output is a starting point for
engineering, not evidence that the design is right.

The best results have come from giving it a narrow contract, asking it to use
the existing patterns, and making it run the smallest relevant checks. That
usually produces a diff I can read. When the task is vague, the output becomes
more speculative: extra abstractions, assumptions about state, or plausible
behaviour that does not match the command's actual users.

Go helps expose some of those mistakes quickly, but it cannot decide whether a
new abstraction belongs in the project. It cannot infer the operational
constraints that were never written down. It cannot tell me whether a passing
test checks the behaviour that matters or merely confirms its own
implementation.

That remains my job.

## Guardrails are not a proof

It would be easy to oversell this. Go is not uniquely safe, and idiomatic Go
is not correct merely because it looks like the code around it. A compiler
proves that a program satisfies its type rules, not that it implements the
right business rule. A formatter improves consistency, not architecture. A
scanner knows about published vulnerabilities, not the threats specific to a
deployment.

Tests deserve the same caution. They are a feedback mechanism, not a
certificate of production safety. An agent can write tests that pass while
preserving the same mistaken assumption as the implementation. Fuzzing can
find surprising inputs, but it needs a useful target and an oracle for what
should be true.

The practical response is not to stop using these tools. It is to use their
evidence in the right order:

1. Define the boundary and the behaviour before asking for a change.
2. Let formatting, compilation, targeted tests, and scanners reject the cheap
   mistakes.
3. Review the diff for the assumptions those tools cannot evaluate.
4. Exercise the change where it meets real services, users, permissions, and
   operations.
5. Keep a human accountable for deciding whether it should ship.

That is not specific to Go. It is the discipline AI-assisted engineering
needs in every language.

## Go is a good place to be sceptical

The most persuasive part of Google's argument is not that Go makes agents
cleverer. It is that Go rewards the habits that make agents less dangerous to
maintain: small explicit changes, fast feedback, ordinary tools, predictable
code, and codebases that remain understandable after the original author has
gone.

Those are useful guardrails. They leave the essential work untouched: setting
the architecture, recognising a bad assumption, understanding the system
outside the repository, and accepting responsibility for the change.

AI can make code appear quickly. A language and toolchain that make that code
easier to question are worth taking seriously.

## Further reading

- [Why Go is an ideal language for AI-assisted software engineering](https://developers.googleblog.com/why-go-is-an-ideal-language-for-ai-assisted-software-engineering/) — the Google article discussed here
- [The Go module reference](https://go.dev/ref/mod)
- [Go security and vulnerability management](https://go.dev/security/vuln/)
- [Go fuzzing](https://go.dev/doc/security/fuzz/)
- [Go release and compatibility policy](https://go.dev/doc/devel/release#policy)
