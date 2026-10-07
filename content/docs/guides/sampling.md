---
title: "Sampling"
linkTitle: "Sampling"
type: "docs"
weight: 30
description: >
  How to control which token the model takes next.
---

A model doesn't output a single token. It scores every token in the vocabulary. The sampler chain turns those scores into one token.

## The chain

Each sampler in the chain either changes the scores or picks a token. The samplers run in the order that you add them.

```go
sampler := llama.SamplerChainInit(llama.SamplerChainDefaultParams())
llama.SamplerChainAdd(sampler, llama.SamplerInitTopK(40))
llama.SamplerChainAdd(sampler, llama.SamplerInitTopP(0.95, 1))
llama.SamplerChainAdd(sampler, llama.SamplerInitMinP(0.05, 1))
llama.SamplerChainAdd(sampler, llama.SamplerInitTemp(0.8))
llama.SamplerChainAdd(sampler, llama.SamplerInitDist(llama.DefaultSeed))
defer llama.SamplerFree(sampler)
```

Put the sampler that picks the token at the end. That is `SamplerInitDist` or `SamplerInitGreedy`.

## Take the token

```go
token := llama.SamplerSample(sampler, ctx, -1)
```

The last argument is the token's index in the batch. Use `-1` for the last one.

## The samplers

| Sampler | What it does |
| --- | --- |
| `SamplerInitGreedy` | Always picks the token with the highest score. The answer is the same every time. |
| `SamplerInitDist` | Picks a token at random, with the scores as the probability. |
| `SamplerInitTopK(k)` | Keeps the k best tokens. |
| `SamplerInitTopP(p, keep)` | Keeps the best tokens whose combined probability reaches p. |
| `SamplerInitMinP(p, keep)` | Removes tokens that are much less likely than the best one. |
| `SamplerInitTemp(t)` | A higher t gives more variation. A lower t gives a safer answer. |
| `SamplerInitTempExt` | A temperature that changes with the model's certainty. |
| `SamplerInitTypical(p, keep)` | Keeps the tokens with a typical amount of information. |
| `SamplerInitTopNSigma(n)` | Keeps the tokens within n standard deviations of the best one. |
| `SamplerInitXTC` | Sometimes removes the most probable tokens, to make the text less predictable. |
| `SamplerInitPenalties` | Lowers the score of tokens that already appeared. This stops repetition. |
| `SamplerInitDry` | Stops the model from repeating a sequence. |
| `SamplerInitMirostat` | Keeps the text's surprise near a target value. |
| `SamplerInitMirostatV2` | The newer version of Mirostat. |
| `SamplerInitLogitBias` | Adds a value to the scores of the tokens that you name. |
| `SamplerInitGrammar` | Makes the answer follow a GBNF grammar. |
| `SamplerInitAdaptiveP` | Changes the cutoff with the model's certainty. |
| `SamplerInitInfill` | For a model that fills in the middle of the text. |

## A chain that is made for you

`NewSampler` builds a chain from a list of sampler types.

```go
params := llama.DefaultSamplerParams()
params.Temp = 0.7
params.TopK = 40

sampler := llama.NewSampler(model, samplers, params)
```

`NewSampler` adds the samplers in the order of the list. It adds the distribution sampler last, or the Adaptive-P sampler when the list has `SamplerTypeAdaptiveP`.

- When `IgnoreEos` is set, it first adds a logit bias that stops the model from ever giving an end of generation token.
- When `Mirostat` is 1 or 2, it ignores the list and makes a chain of temperature and then Mirostat, as `llama.cpp` does.
- It returns a zero `Sampler` when the list is empty, the parameters are nil, or `Mirostat` is not 0, 1 or 2. Check for this before you use the sampler.

## The defaults

`DefaultSamplerParams` gives these values.

| Field | Default |
| --- | --- |
| `Temp` | 0.8 |
| `TopK` | 40 |
| `TopP` | 0.95 |
| `MinP` | 0.05 |
| `PenaltyLastN` | 64 |
| `TypP` | 1.0, which is off |
| `XTCProbability` | 0.0, which is off |
| `DynatempRange` | 0.0, which is off |
| `AdaptiveTarget` | -1.0, which is off |
| `IgnoreEos` | false |

## Which values to use

- For a factual answer, use a low temperature, such as 0.2, or use a greedy sampler.
- For a chat, use a temperature near 0.7 or 0.8.
- For a creative text, use a temperature near 1.0.
- Set `Seed` to a fixed value when you want the same answer every time.

## Make the answer valid JSON

A grammar sampler makes the answer follow a shape. Use it when your program must read the answer.

```go
grammar := `root ::= "{" ws "\"name\"" ws ":" ws string "}"`
llama.SamplerChainAdd(sampler, llama.SamplerInitGrammar(vocab, grammar, "root"))
```

## Measure the sampler

```go
llama.PerfSamplerPrint(sampler)
```

This prints how much time the sampler took.
