---
title: "Your first program"
linkTitle: "First program"
type: "docs"
weight: 30
description: >
  Write a Go program that uses a language model.
---

This page shows the smallest yzma program. It sends a prompt to a model and prints the answer.

## Before you start

- Install yzma and the `llama.cpp` libraries. See [Quick install](/getting-started/install/).
- Set the `YZMA_LIB` environment variable.
- Download the model:

```shell
yzma model get -u https://huggingface.co/QuantFactory/SmolLM2-135M-GGUF/resolve/main/SmolLM2-135M.Q4_K_M.gguf
```

## The program

```go
package main

import (
	"fmt"
	"os"
	"path/filepath"

	"github.com/hybridgroup/yzma/pkg/download"
	"github.com/hybridgroup/yzma/pkg/llama"
)

var (
	modelFile            = "SmolLM2-135M.Q4_K_M.gguf"
	prompt               = "Are you ready to go?"
	libPath              = os.Getenv("YZMA_LIB")
	responseLength int32 = 12
)

func main() {
	llama.Load(libPath)
	llama.LogSet(llama.LogSilent())

	llama.Init()

	model, _ := llama.ModelLoadFromFile(filepath.Join(download.DefaultModelsDir(), modelFile), llama.ModelDefaultParams())
	ctx, _ := llama.InitFromModel(model, llama.ContextDefaultParams())

	vocab := llama.ModelGetVocab(model)

	tokens := llama.Tokenize(vocab, prompt, true, false)

	batch := llama.BatchGetOne(tokens)

	sampler := llama.SamplerChainInit(llama.SamplerChainDefaultParams())
	llama.SamplerChainAdd(sampler, llama.SamplerInitGreedy())

	for pos := int32(0); pos < responseLength; pos += batch.NTokens {
		llama.Decode(ctx, batch)
		token := llama.SamplerSample(sampler, ctx, -1)

		if llama.VocabIsEOG(vocab, token) {
			fmt.Println()
			break
		}

		buf := make([]byte, 36)
		len := llama.TokenToPiece(vocab, token, buf, 0, true)

		fmt.Print(string(buf[:len]))

		batch = llama.BatchGetOne([]llama.Token{token})
	}

	fmt.Println()
}
```

## Run it

```shell
$ go run ./examples/hello/


"Yes, I'm ready to go."
```

No C compiler is necessary. The normal `go run` command is sufficient.

## What each step does

1. `llama.Load` opens the `llama.cpp` shared libraries at run time.
2. `llama.Init` starts the backend.
3. `ModelLoadFromFile` reads the GGUF file.
4. `InitFromModel` makes a context. The context holds the state of one conversation.
5. `Tokenize` turns the prompt into tokens.
6. The sampler chain selects the next token. This program uses a greedy sampler, which always takes the token with the highest score.
7. The loop calls `Decode` to run the model, and `SamplerSample` to take a token. `TokenToPiece` turns the token back into text.
8. The loop stops at the end of generation token.

## Next steps

Go to [Next steps](/getting-started/next-steps/).
