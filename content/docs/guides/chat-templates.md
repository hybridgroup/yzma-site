---
title: "Chat templates"
linkTitle: "Chat templates"
type: "docs"
weight: 20
description: >
  How to put your messages in the shape that a model expects.
---

An instruction model expects a marker before each message. The markers say which part is the system prompt, which part the user said, and where the model must write. That shape is the chat template.

Each model family has its own template. If you send the wrong shape, the model gives a poor answer or no answer.

## The template in the model file

Most GGUF files hold their own template.

```go
tmpl := llama.ModelChatTemplate(model)
```

An empty result means the file holds no template. Then you must give one.

## Apply the template

`pkg/template` renders a Jinja template.

```go
import (
	"github.com/hybridgroup/yzma/pkg/message"
	"github.com/hybridgroup/yzma/pkg/template"
)

messages := []message.Message{
	message.Chat{Role: "system", Content: "You are a helpful robot companion."},
	message.Chat{Role: "user", Content: "Are you ready to go?"},
}

prompt, err := template.Apply(tmpl, messages, true)
```

The third argument adds the marker that starts the turn of the assistant. Set it to `true` before you generate an answer.

`llama.ChatApplyTemplate` does the same with the code in `llama.cpp`.

## Built in templates

yzma holds three templates for a model file that has none.

| Name | Use it for |
| --- | --- |
| `chatml` | Many models. This is the most common shape. |
| `gemma3` | The Gemma 3 family. |
| `qwen2.5-instruct` | The Qwen 2.5 instruct family. |

```go
tmpl, ok := template.BuiltinTemplate("chatml")
if !ok {
	// There is no template with that name.
}
```

The `chat` example and the `vlm` example take the name with the `-template` flag.

`llama.ChatBuiltinTemplates()` lists the templates that `llama.cpp` holds.

## Thinking mode

Some models, such as Qwen3, have a thinking mode. The model writes its reasoning before the answer. Set `EnableThinking` to `false` to stop that.

```go
opts := template.DefaultOptions()
opts.EnableThinking = false

prompt, err := template.ApplyWithOptions(tmpl, messages, true, opts)
```

Thinking mode is on by default. A model whose template does not use this variable ignores the setting.

## Templates with tools

A model that calls tools needs the tool definitions in the prompt.

```go
prompt, err := template.ApplyWithTools(tmpl, messages, tools, true)
```

You can also put the tools in `Options`:

```go
opts := template.DefaultOptions()
opts.Tools = tools
```

When the tools list is empty, the template takes its plain path.

See [Tool calling](/docs/guides/tool-calling/).

## Read the template of a file

The `modelinfo` example prints the metadata of a GGUF file, and the chat template is part of it.

```shell
go run ./examples/modelinfo/ -model ~/models/gemma-3-1b-it-Q4_K_M.gguf
```
