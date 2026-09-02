---
layout: post
title: "Decoding a Billboard URL with an AI Tokenizer"
date: 2026-09-01 14:40:58 +0000
categories: [ai, puzzles]
tags: [tokenization, o200k-base, openai, go, puzzles, billboards]
---
I saw a photo of an SF billboard with what looked like a broken URL:
`https:// {64659, 123310, 75584, 8138, 38271}` 

It led to Listen Labs' [Berghain Challenge](https://berghain.challenges.listenlabs.ai/),
where you act as a nightclub bouncer and must fill a venue while meeting rules
about the people admitted. The whole thing was actually a job application and puzzle. 

Credit for identifying the tokenizer solution goes
to [@0x686967](https://x.com/0x686967/status/1962953670703841724).

At first glance it invites the usual decoding guesses. Are the numbers decimal
character codes? Hex values? Bytes for Base64? An IP address? A hash? None of
those questions has a convincing answer without an extra rule. The numbers do
not form a valid hostname, and trying ordinary base conversions simply produces
different ways to write the same numbers.

The trick is that they are not a conventional text encoding at all. They are
token IDs from an AI tokenizer.

## A dictionary of text pieces

A tokenizer is a large dictionary used by a language model. It turns text into
numbers before the model processes it. Rather than assigning a number to every
individual letter, it often assigns one to a commonly occurring text fragment:
a word, part of a word, a space followed by a word, punctuation, or a short
piece of code.

It works in both directions:

```text
text -> tokenizer -> token IDs
token IDs -> tokenizer -> text
```

The billboard showed the second form. The five IDs belong to `o200k_base`, an
OpenAI token vocabulary used by newer models. Decoding them in that vocabulary
produces:

```text
listenlabs.ai/puzzle
```

So the address on the billboard is:

```text
https://listenlabs.ai/puzzle
```

## Explain it like I am five

The billboard was the signpost to that game, but it hid the web address. Imagine
a giant book where little pieces of text are given number labels. The book might
have entries for parts of words, whole words, dots, or slashes. Instead of
writing the address on the billboard, someone wrote the labels:

```text
64659, 123310, 75584, 8138, 38271
```

Those labels look like nonsense unless you have the same giant book. The
`o200k_base` tokenizer is that book. When it looks up the five labels in order,

Imagine a giant book where every tiny piece of text has a number.

For example, the book might say:

- number  64659  means  "listen"
- another number means  "labs"
- another means  ".ai"
- another means  "/"
- another means  "puzzle" 

The billboard showed only the numbers:

```text
64659, 123310, 75584, 8138, 38271
```

They look meaningless until you use the same giant book—called the  `o200k_base`  tokenizer—to look each number up. It turns the number pieces back into text:

```text
listenlabs.ai/puzzle
```

Then we add  https://  at the front, like putting an address on an envelope:

https://listenlabs.ai/puzzle

It was a secret web address written using an AI’s word-number dictionary, not ordinary encryption

```text
listenlabs.ai/puzzle
```

Adding `https://` is like writing the beginning of an address on an envelope:

```text
https://listenlabs.ai/puzzle
```

So the solution is not a secret-number trick: it is the right lookup book for
an AI's word-and-number dictionary. The exact pieces do not have to be whole
words; together, they spell the address to the challenge. 

## Why `o200k_base`?

There is no reliable mathematical test that identifies `o200k_base` from those
five values alone. Token IDs only have meaning within the vocabulary that
assigned them. The same integer could represent completely different text in
another tokenizer.

There are clues, though. The largest value is `123310`, which is above the
roughly 100,000-token limit of older OpenAI encodings such as `cl100k_base`.
The AI context makes a tokenizer a plausible puzzle mechanism, and
`o200k_base` has a large enough vocabulary to contain every value. Once the
decoded output looks like a real domain and path, the hypothesis is easy to
confirm.

This is closer to looking up words in the right dictionary than cracking a
secret code. The difficult part is recognising which dictionary the puzzle
expects.

> Effectively, we cheated and used an abstraction of every possible Agnetic tokeniser to get a sane answer and test.
If you are bored, try printing out every answer and test them... 

## Reproducing the decode

Here is a small Go program using
[`tiktoken-go`](https://github.com/tiktoken-go/tokenizer):

```go
package main

import (
	"fmt"
	"log"

	"github.com/tiktoken-go/tokenizer"
)

func main() {
	enc, err := tokenizer.Get(tokenizer.O200kBase)
	if err != nil {
		log.Fatalf("failed to get encoding: %v", err)
	}

	text, err := enc.Decode([]uint{64659, 123310, 75584, 8138, 38271})
	if err != nil {
		log.Fatalf("failed to decode tokens: %v", err)
	}

	fmt.Println(text)
}
```

The output is:

```text
listenlabs.ai/puzzle
```

The detail worth noticing is `[]uint`, not `[]int`: the Go package's `Decode`
method accepts unsigned token IDs. That small type distinction is enough to
make an otherwise correct example fail to compile.

## The useful lesson

When a puzzle gives you a short list of large, positive integers, do not assume
they are bytes or character codes. In an AI-flavoured setting they may be token
IDs. There are several token vocabularies, so the process is not magic:
identify likely vocabularies from the number range and context, decode the
sequence, then check whether the result is meaningful.

In this case, the meaning was a URL hiding in plain sight.


> 🤖 **AI co-author:** [GitHub Copilot](https://github.com/features/copilot)
