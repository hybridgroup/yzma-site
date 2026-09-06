---
title: "Download models"
linkTitle: "Download models"
type: "docs"
weight: 20
description: >
  How to get a model on your machine.
---

yzma uses models in the GGUF format that `llama.cpp` supports. There are more than 201,000 GGUF models on Hugging Face:

https://huggingface.co/models?library=gguf&sort=trending

## Use the yzma command

The `yzma` command downloads a model for you:

```shell
yzma model get -u https://huggingface.co/QuantFactory/SmolLM2-135M-GGUF/resolve/main/SmolLM2-135M.Q4_K_M.gguf
```

The command puts the file in the default models directory. A Go program finds that directory with `download.DefaultModelsDir()`.

## Choose a model

A larger model gives better answers, but it needs more memory and more time. Start with a small model.

| Model | Size | What it does |
| --- | --- | --- |
| `SmolLM2-135M` | Very small | Text. Good for a first test. |
| `qwen2.5-0.5b-instruct` | Small | Chat. |
| `gemma-3-1b-it` | Small | Chat. |
| `Qwen3-VL-2B-Instruct` | Medium | Images and text. |

See [Models](/docs/guides/models/) for the complete list with the command for each one.

## Projector files

A Vision Language Model needs two files. There is the model file, and there is the projector file. The projector file turns an image into tokens that the model reads. The name of a projector file starts with `mmproj`.

Download both files:

```shell
yzma model get -u https://huggingface.co/ggml-org/Qwen2.5-VL-3B-Instruct-GGUF/resolve/main/Qwen2.5-VL-3B-Instruct-Q8_0.gguf
yzma model get -u https://huggingface.co/ggml-org/Qwen2.5-VL-3B-Instruct-GGUF/resolve/main/mmproj-Qwen2.5-VL-3B-Instruct-Q8_0.gguf
```

## Next steps

Now write your first program. Go to [Your first program](/getting-started/first-program/).
