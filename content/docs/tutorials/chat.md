---
title: "Chat"
linkTitle: "Chat"
type: "docs"
weight: 20
description: >
  Keep a conversation with a model.
---

The `hello` program sends one prompt. A chat program keeps the conversation, so the model remembers what came before.

## Before you start

Download a model that follows an instruction:

```shell
yzma model get -u https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-fp16.gguf
```

## Run the example

```shell
$ go run ./examples/chat/ -model ./models/qwen2.5-0.5b-instruct-fp16.gguf
Enter prompt: Are you ready to go?

Yes, I'm ready to go! What would you like to do?

Enter prompt: Let's go to the zoo


Great! Let's go to the zoo. What would you like to see?

Enter prompt: I want to feed the llama


Sure! Let's go to the zoo and feed the llama. What kind of llama are you interested in feeding?
```

[See the code](https://github.com/hybridgroup/yzma/blob/main/examples/chat/main.go).

## What is different

**The chat template.** An instruction model expects a marker before each message. `ChatApplyTemplate` adds the markers. Most GGUF files hold their own template, and `ModelChatTemplate` reads it.

```go
tmpl := llama.ModelChatTemplate(model)
prompt := llama.ChatApplyTemplate(tmpl, messages, true)
```

See [Chat templates](/docs/guides/chat-templates/).

**The context keeps the conversation.** Each new message goes on the end of the same context. The model then sees the complete history.

**The sampler is not greedy.** A chat needs some variation. The example uses a chain with a temperature sampler, a top-k sampler, a top-p sampler, and a min-p sampler.

## The flags

| Flag | Default | What it does |
| --- | --- | --- |
| `-model` | none | The model file. This flag is necessary. |
| `-lib` | `YZMA_LIB` | The directory with the `llama.cpp` libraries. |
| `-p` | none | One prompt. Omit this flag for a chat session. |
| `-sys` | none | The system prompt. |
| `-template` | none | The name of a template, when the model has none. |
| `-temp` | 0.8 | The temperature. A higher value gives more variation. |
| `-top-k` | 40 | Keeps the 40 best tokens. |
| `-top-p` | 0.9 | Keeps the tokens that make 90 percent of the probability. |
| `-min-p` | 0.1 | Removes a token that is much worse than the best one. |
| `-c` | 4096 | The size of the context in tokens. |
| `-n` | -1 | How many tokens to make. -1 means the size of the context. |
| `-b` | 2048 | The logical batch size. |
| `-ub` | 2048 | The physical batch size. |
| `-cmoe` | false | Keeps all Mixture of Experts weights in the CPU. |
| `-ncmoe` | 0 | Keeps the Mixture of Experts weights of the first N layers in the CPU. |
| `-v` | false | Shows the messages of `llama.cpp`. |

## When the context is full

A long conversation fills the context. You have three choices.

- Make the context larger with `-c`. The model has a limit that `ModelNCtxTrain` gives.
- Remove the oldest messages with `MemorySeqRm`.
- Clear the context with `MemoryClear` and start again.

## Next steps

Go to [Vision](/docs/tutorials/vision/) to ask a question about an image.
