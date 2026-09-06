---
title: "Packages"
linkTitle: "Packages"
type: "docs"
weight: 50
description: >
  The Go packages and where to read their API.
---

The complete API is on [pkg.go.dev](https://pkg.go.dev/github.com/hybridgroup/yzma).

| Package | Import path | What it does |
| --- | --- | --- |
| llama | [`pkg/llama`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llama) | The main bindings for `llama.cpp`. |
| mtmd | [`pkg/mtmd`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/mtmd) | Images, audio, and video. |
| download | [`pkg/download`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/download) | Installs the libraries and the models. |
| message | [`pkg/message`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/message) | Chat messages and tool calls. |
| template | [`pkg/template`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/template) | Jinja chat templates. |
| llamawasm | [`pkg/llamawasm`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llamawasm) | The browser version. Build tag `js && wasm`. |
| vlm | [`pkg/vlm`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/vlm) | An experimental high level type for Vision Language Models. |
| loader | [`pkg/loader`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/loader) | Opens a shared library and prepares a call. |
| utils | [`pkg/utils`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/utils) | Converts a Go string to a C string and back. |

See [Packages](/docs/concepts/packages/) for what each one is for.

## The most common calls

### Start

| Call | What it does |
| --- | --- |
| `llama.Load(path)` | Opens the shared libraries. |
| `llama.Init()` | Starts the backend. |
| `llama.LogSet(llama.LogSilent())` | Stops the messages of `llama.cpp`. |
| `llama.Close()` | Closes the libraries. |

### Model and context

| Call | What it does |
| --- | --- |
| `llama.ModelDefaultParams()` | The default model parameters. |
| `llama.ModelLoadFromFile(path, params)` | Reads a GGUF file. |
| `llama.ModelGetVocab(model)` | Gives the vocabulary. |
| `llama.ContextDefaultParams()` | The default context parameters. |
| `llama.InitFromModel(model, params)` | Makes a context. |
| `llama.ModelFree(model)` | Frees the model. |

### Tokens

| Call | What it does |
| --- | --- |
| `llama.Tokenize(vocab, text, addBOS, parseSpecial)` | Text to tokens. |
| `llama.TokenToPiece(vocab, token, buf, lstrip, special)` | One token to text. |
| `llama.Detokenize(...)` | Tokens to text. |
| `llama.VocabIsEOG(vocab, token)` | Reports the end of generation token. |

### Generation

| Call | What it does |
| --- | --- |
| `llama.BatchGetOne(tokens)` | Makes a batch from tokens. |
| `llama.Decode(ctx, batch)` | Runs the model. |
| `llama.SamplerSample(sampler, ctx, idx)` | Takes the next token. |
| `llama.GetEmbeddingsSeq(ctx, seq, n)` | Gives an embedding vector. |

### Memory

| Call | What it does |
| --- | --- |
| `llama.GetMemory(ctx)` | Gives the memory of the context. |
| `llama.MemoryClear(mem, data)` | Clears it. |
| `llama.MemorySeqRm(mem, seq, p0, p1)` | Removes part of a sequence. |

## Version

```go
import "github.com/hybridgroup/yzma"
```

The root package holds the package documentation. The `yzma version` command prints the version of the tool.
