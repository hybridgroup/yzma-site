---
title: "Examples"
linkTitle: "Examples"
type: "docs"
weight: 40
description: >
  The example programs in the yzma repository.
---

The [examples directory](https://github.com/hybridgroup/yzma/tree/main/examples) holds these programs. Each one has its own README.

## Native

| Example | What it shows |
| --- | --- |
| [`hello`](https://github.com/hybridgroup/yzma/tree/main/examples/hello) | The smallest program. Loads a model and prints an answer. |
| [`chat`](https://github.com/hybridgroup/yzma/tree/main/examples/chat) | An interactive chat that keeps the conversation. |
| [`vlm`](https://github.com/hybridgroup/yzma/tree/main/examples/vlm) | Sends an image and a prompt to a Vision Language Model. |
| [`describe`](https://github.com/hybridgroup/yzma/tree/main/examples/describe) | Describes an image from a URL or a local file. Installs as a command. |
| [`embeddings`](https://github.com/hybridgroup/yzma/tree/main/examples/embeddings) | Turns text into a vector. |
| [`tooluse`](https://github.com/hybridgroup/yzma/tree/main/examples/tooluse) | One round of tool calling. |
| [`multitool`](https://github.com/hybridgroup/yzma/tree/main/examples/multitool) | Tool calling in a loop, for a problem with steps. |
| [`modelinfo`](https://github.com/hybridgroup/yzma/tree/main/examples/modelinfo) | Prints the description, the size, and the metadata of a model. |
| [`systeminfo`](https://github.com/hybridgroup/yzma/tree/main/examples/systeminfo) | Lists the devices that `llama.cpp` found. |
| [`installer`](https://github.com/hybridgroup/yzma/tree/main/examples/installer) | Installs the `llama.cpp` libraries from Go code. |
| [`resolver`](https://github.com/hybridgroup/yzma/tree/main/examples/resolver) | Installs from your own mirror with a custom resolver. |

## Browser

| Example | What it shows |
| --- | --- |
| [`wasm/chat`](https://github.com/hybridgroup/yzma/tree/main/examples/wasm/chat) | A chat page. |
| [`wasm/vlm`](https://github.com/hybridgroup/yzma/tree/main/examples/wasm/vlm) | A page that asks a question about an image. |
| [`wasm/tools`](https://github.com/hybridgroup/yzma/tree/main/examples/wasm/tools) | A page where the model calls tools. |

## Run one

Clone the repository, set `YZMA_LIB`, and download a model.

```shell
git clone https://github.com/hybridgroup/yzma.git
cd yzma
export YZMA_LIB=/path/to/lib
yzma model get -u https://huggingface.co/QuantFactory/SmolLM2-135M-GGUF/resolve/main/SmolLM2-135M.Q4_K_M.gguf
go run ./examples/hello/
```

`make download-models` downloads every model that the tests use.

## Common flags

Most examples take these flags.

| Flag | What it does |
| --- | --- |
| `-model` | The model file. |
| `-mmproj` | The projector file, for a multimodal model. |
| `-lib` | The directory with the libraries. The default is `$YZMA_LIB`. |
| `-p` | The prompt. |
| `-sys` | The system prompt. |
| `-template` | The name of a template, when the model file holds none. |
| `-image` | The image file. |
| `-temp` | The temperature. |
| `-c` | The size of the context. |
| `-n` | How many tokens to make. |
| `-v` | Shows the messages of `llama.cpp`. |

## Related pages

The [Tutorials](/docs/tutorials/) build on these examples step by step.
