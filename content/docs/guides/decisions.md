---
title: "Typed decisions"
linkTitle: "Decisions"
type: "docs"
weight: 55
description: >
  Ask a System One model a typed question and get a probability for each answer.
---

The `exp/decide` package runs System One models. You give one of these models a state and a typed question, and it gives back a probability for each option instead of text. One decode gives the answer, so it is fast, and the probabilities are calibrated so you can trust them as a confidence.

Use it to route a ticket to a team, to check a fact against a text, or to rate a reply.

The package is experimental. Its API can change in a later release.

## The models

| Family | How to load | Config |
| --- | --- | --- |
| [Jev-Style](https://huggingface.co/chaoliangUNSW/Jev-Style-0.8B-Decision-v3-GGUF) | `decide.New` | `readout_config.json` |
| [JevK5](https://huggingface.co/alibiserikbay/JevK5-GGUF) | `decide.NewJevK5` | `jevk5_config.json` |
| [decider](https://huggingface.co/Mapika/decider-0.8b) | `decide.NewDeciderModel` | `decider_config.json` |
| [Lev](https://huggingface.co/ggml-org/lev-GGUF), [OpenJev](https://huggingface.co/ggml-org/OpenJev-GGUF), [Laya](https://huggingface.co/ggml-org/Laya-GGUF), [Julia-1](https://huggingface.co/ggml-org/Julia-1-GGUF), [Kev](https://huggingface.co/ggml-org/Kev-4B-GGUF) | `decide.Open` | None. The GGUF file holds it. |

The config file holds the token ids and the calibration temperatures. Download it from the same model page as the GGUF file. Laya, Julia-1 and Kev need `llama.cpp` v0.6.0 or later.

## Three kinds of question

| Type | Helper | Answer |
| --- | --- | --- |
| Choice | `decide.Choice`, `decide.ChoiceDesc` | One option from a list. |
| Score | `decide.Score` | One of 2 to 10 ordered levels, level 0 first. |
| True or false | `decide.Noul` | `true` or `false`. |

## Ask a question

```go
package main

import (
	"fmt"
	"log"

	"github.com/hybridgroup/yzma/exp/decide"
	"github.com/hybridgroup/yzma/pkg/llama"
)

func main() {
	if err := llama.Load(""); err != nil {
		log.Fatal(err)
	}
	llama.LogSet(llama.LogSilent())
	if err := llama.Init(); err != nil {
		log.Fatal(err)
	}
	defer llama.Close()

	d, err := decide.Open("lev-Q8_0.gguf", decide.Options{})
	if err != nil {
		log.Fatal(err)
	}
	defer d.Close()

	q := decide.ChoiceDesc("Which team should handle this?",
		decide.Option{Name: "billing", Description: "Charges, invoices, refunds"},
		decide.Option{Name: "technical", Description: "Bugs, outages"},
	)

	res, err := d.Decide("I was charged twice for order A-104.", q, "")
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(res.Answer, res.TopProbability)
}
```

The state can be a string or any value that encodes as JSON. The last argument of `Decide` is a category, such as `theme_routing` or `general_sentiment`. A Jev-Style model has a calibration temperature for each category. An empty category uses the global temperature.

`Result` holds the answer, the options, a probability for each option, and the number of input tokens. `res.Probability("billing")` gives the probability of one option.

## Many questions about one state

`DecideMany` reads the state once and then asks each question.

```go
results, err := d.DecideMany(state, []decide.Question{q1, q2, q3}, "")
```

`Options.ManyMode` picks how.

| Mode | What it does |
| --- | --- |
| `decide.ManyExact` | The default. The results are the same as from `Decide`. |
| `decide.ManyBatched` | Decodes up to 16 questions at once. It is faster, but a probability can move by a few hundredths. |

## Options

| Field | What it does |
| --- | --- |
| `Threads` | The CPU threads. 0 uses the default. |
| `ContextSize` | The context in tokens. 0 uses the default for the model family. |
| `MaxOptions` | The most options one question can have. 0 uses 256. |
| `BothOrders` | Also reads each choice question with the options in reverse order, and averages the two. This cancels a preference for the first option. |

## The llama-server API

`decide.ParseRequest` reads the JSON of the `/v1/systemone` API that `llama-server` serves, and `Decider.Answer` answers it. So a Go program can take the same requests as the server.

## In the browser

The package also builds with TinyGo for the browser and runs on `pkg/llamawasm`. Asking many questions about one state needs a `llama.cpp` module with ABI 10 or later. An older module still works, and decodes each question on its own. See the [`wasm/decide`](https://github.com/hybridgroup/yzma/tree/main/examples/wasm/decide) example.

## The example

The [`decide`](https://github.com/hybridgroup/yzma/tree/main/examples/decide) example runs all of the model families from the command line.

```shell
go run ./examples/decide/ -readout gguf -model ~/models/lev-Q8_0.gguf \
    -state '{"ticket": "I was charged twice for order A-104. Please refund the duplicate."}' \
    -question "Which team should handle this?" \
    -options '{"billing": "Charges, invoices, refunds", "technical": "Bugs, outages", "other": ""}'
```

`-readout` takes `jev`, `jevk5`, `decider` or `gguf`. Leave out `-options` for a true or false question, and add `-type score` with a JSON list of levels for a score question.
