---
title: "Embeddings"
linkTitle: "Embeddings"
type: "docs"
weight: 40
description: >
  Turn text into a vector of numbers.
---

An embedding is a vector of numbers that stands for a piece of text. Two pieces of text with a similar meaning give two similar vectors. Use embeddings for search, for grouping, and for comparison.

## Before you start

Download a model:

```shell
yzma model get -u https://huggingface.co/QuantFactory/SmolLM-135M-GGUF/resolve/main/SmolLM-135M.Q2_K.gguf
```

## Run the example

```shell
$ go run ./examples/embeddings/ -model ~/models/SmolLM-135M.Q2_K.gguf -p "Hello World"
-0.009294 -0.003438 0.004629 -0.005551 0.003048 ...
```

[See the code](https://github.com/hybridgroup/yzma/blob/main/examples/embeddings/main.go).

## The steps

**1. Turn on embeddings in the context parameters.**

```go
params := llama.ContextDefaultParams()
params.Embeddings = 1
params.PoolingType = llama.PoolingTypeMean

ctx, err := llama.InitFromModel(model, params)
```

The pooling type says how to make one vector from many tokens. `PoolingTypeMean` takes the mean of every token. There is also `PoolingTypeCLS`, `PoolingTypeLast`, and `PoolingTypeNone`.

**2. Tokenize the text and run one decode.**

```go
tokens := llama.Tokenize(vocab, text, true, false)
batch := llama.BatchGetOne(tokens)
llama.Decode(ctx, batch)
```

There is no loop. An embedding needs one pass only.

**3. Read the vector.**

```go
nEmbd := llama.ModelNEmbd(model)
embd, err := llama.GetEmbeddingsSeq(ctx, 0, nEmbd)
```

`ModelNEmbd` gives the length of the vector.

## Compare two vectors

Use the cosine of the angle between the two vectors. A value near 1 means the two pieces of text have a similar meaning.

```go
func cosine(a, b []float32) float32 {
	var dot, na, nb float32
	for i := range a {
		dot += a[i] * b[i]
		na += a[i] * a[i]
		nb += b[i] * b[i]
	}
	return dot / (float32(math.Sqrt(float64(na))) * float32(math.Sqrt(float64(nb))))
}
```

## Choose a model

A model that was trained for embeddings gives better results than a general text model. Look for a model with `embed` or `bge` or `nomic` in the name.

## Next steps

Go to [Tool calling](/docs/tutorials/tool-calling/).
