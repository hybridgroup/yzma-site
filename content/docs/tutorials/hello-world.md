---
title: "Hello world"
linkTitle: "Hello world"
type: "docs"
weight: 10
description: >
  Send a prompt to a model and print the answer.
---

This is the smallest yzma program.

## Before you start

Install yzma and the `llama.cpp` libraries. See [Quick install](/getting-started/install/). Then set `YZMA_LIB`.

Download the model:

```shell
yzma model get -u https://huggingface.co/QuantFactory/SmolLM2-135M-GGUF/resolve/main/SmolLM2-135M.Q4_K_M.gguf
```

## Run the example

```shell
$ go run ./examples/hello/


"Yes, I'm ready to go."
```

The complete program is on the [Your first program](/getting-started/first-program/) page.

## The steps

**1. Open the libraries.**

```go
llama.Load(libPath)
llama.LogSet(llama.LogSilent())
llama.Init()
```

`LogSilent` stops the messages that `llama.cpp` prints. Remove that line to see what the library does.

**2. Load the model and make a context.**

```go
model, _ := llama.ModelLoadFromFile(path, llama.ModelDefaultParams())
ctx, _ := llama.InitFromModel(model, llama.ContextDefaultParams())
```

The model holds the weights. The context holds the state of one conversation.

**3. Turn the prompt into tokens.**

```go
vocab := llama.ModelGetVocab(model)
tokens := llama.Tokenize(vocab, prompt, true, false)
batch := llama.BatchGetOne(tokens)
```

The third argument of `Tokenize` adds the beginning of sequence token.

**4. Make a sampler chain.**

```go
sampler := llama.SamplerChainInit(llama.SamplerChainDefaultParams())
llama.SamplerChainAdd(sampler, llama.SamplerInitGreedy())
```

A greedy sampler always takes the token with the highest score. The answer is then the same every time. See [Sampling](/docs/guides/sampling/) for the other samplers.

**5. Run the loop.**

```go
for pos := int32(0); pos < responseLength; pos += batch.NTokens {
	llama.Decode(ctx, batch)
	token := llama.SamplerSample(sampler, ctx, -1)

	if llama.VocabIsEOG(vocab, token) {
		break
	}

	buf := make([]byte, 36)
	len := llama.TokenToPiece(vocab, token, buf, 0, true)
	fmt.Print(string(buf[:len]))

	batch = llama.BatchGetOne([]llama.Token{token})
}
```

`Decode` runs the model. `SamplerSample` takes the next token. `TokenToPiece` turns that token into text. The new token becomes the next batch.

`VocabIsEOG` reports the end of generation token. The model gives this token when it has no more to say.

## Next steps

Go to [Chat](/docs/tutorials/chat/) to keep a conversation.
