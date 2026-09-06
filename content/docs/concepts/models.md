---
title: "Models"
linkTitle: "Models"
type: "docs"
weight: 20
description: >
  What a GGUF model is and what the parts of one are.
---

## GGUF

yzma uses models in the GGUF format. This is the format that `llama.cpp` reads. A GGUF file holds the weights of the model and the metadata about it, such as the name, the size of the context, and the chat template.

There are more than 201,000 GGUF models on Hugging Face:

https://huggingface.co/models?library=gguf&sort=trending

Read the metadata of a file with the `modelinfo` example program.

## Quantization

The name of a model file usually ends with a quantization code, such as `Q4_K_M` or `Q8_0` or `fp16`.

Quantization makes the numbers in the model smaller. A smaller number needs less memory and less time, but it also loses accuracy.

| Code | Bits for each weight | Notes |
| --- | --- | --- |
| `fp16` | 16 | Full quality. Large. |
| `Q8_0` | 8 | Very close to full quality. |
| `Q4_K_M` | 4 | A good balance. The most common choice. |
| `Q2_K` | 2 | Small and fast. Quality drops. |

Start with `Q4_K_M`. Move up if the answers are poor. Move down if the machine has little memory.

## Kinds of model

**Large, Small, and Tiny Language Models** read text and write text. A model with `instruct` or `it` in the name follows an instruction. A model without it only continues the text.

**Vision Language Models (VLM)** read an image and text together. A VLM needs two files. There is the model file, and there is the projector file. The name of a projector file starts with `mmproj`. The projector turns the image into tokens that the model reads.

**Vision Language Action Models (VLA)** read an image and give a position back, such as a bounding box in JSON.

**Embedding models** turn text into a vector of numbers. Use them for search and for comparison.

## Context size

The context is the memory of the model for one conversation. It holds the prompt and the answer. `ContextParams.NCtx` sets the size in tokens.

A larger context holds more text, but it uses more memory. The model also has a limit that it was trained with. `ModelNCtxTrain` gives that limit.

## Chat templates

An instruction model expects the text in a specific shape, with a marker before the message of the user and before the message of the assistant. That shape is the chat template.

Most GGUF files hold their own template. `ModelChatTemplate` reads it, and `ChatApplyTemplate` uses it. See [Chat templates](/docs/guides/chat-templates/).

## Where to put models

The `yzma model get` command puts a model in the default models directory. `download.DefaultModelsDir()` gives that path to a Go program.

See [Models](/docs/guides/models/) for a list of models with the command for each one.
