---
title: "Packages"
linkTitle: "Packages"
type: "docs"
weight: 40
description: >
  What each Go package in yzma does.
---

yzma is a set of Go packages. Most programs use two or three of them.

| Package | What it does |
| --- | --- |
| [`pkg/llama`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llama) | The main bindings. Models, contexts, tokens, batches, samplers, and the memory of a conversation. |
| [`pkg/mtmd`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/mtmd) | Multimodal input. Images, audio, and video. |
| [`pkg/download`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/download) | Downloads the `llama.cpp` libraries and the models. Checks the digests. |
| [`pkg/message`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/message) | Chat messages and tool calls. Reads the tool call format of each model family. |
| [`pkg/template`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/template) | Jinja chat templates. |
| [`pkg/llamawasm`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llamawasm) | The browser version of `pkg/llama`. Build tag `js && wasm`. |
| [`pkg/vlm`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/vlm) | An experimental high level type for Vision Language Models. |
| [`pkg/loader`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/loader) | Opens a shared library and prepares a function call. |
| [`pkg/utils`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/utils) | Converts a Go string to a C string and back. |

## pkg/llama

This is the package that most programs import. It gives about 250 functions, in these groups.

- **Load.** `Load`, `Init`, `Close`, `PrintSystemInfo`.
- **Model.** `ModelLoadFromFile`, `ModelDefaultParams`, `ModelGetVocab`, `ModelChatTemplate`, `ModelMeta*`.
- **Context.** `InitFromModel`, `ContextDefaultParams`, `NCtx`, `SetNThreads`.
- **Tokens.** `Tokenize`, `Detokenize`, `TokenToPiece`, `VocabIsEOG`.
- **Inference.** `Decode`, `Encode`, `BatchGetOne`, `GetLogits`, `GetEmbeddings`.
- **Sampling.** `SamplerChainInit`, `SamplerChainAdd`, `SamplerSample`, and a function for each sampler.
- **Memory.** `GetMemory`, `MemoryClear`, `MemorySeqRm`, and the other sequence operations.
- **State.** `StateSaveFile`, `StateLoadFile`.
- **LoRA.** `AdapterLoraInit`, `SetAdaptersLora`.
- **Backends.** `GGMLBackendLoadAll`, `GGMLBackendDeviceCount`, `GGMLBackendDeviceName`.

## pkg/mtmd

`mtmd` is the multimodal library of `llama.cpp`. Use it to send an image, a sound, or a video with the text.

- `InitFromFile` loads the projector file.
- `BitmapInitFromFile` reads an image.
- `BitmapInitFromAudio` reads a sound.
- `VideoInit` reads a video. This needs `ffmpeg` and `ffprobe` on the PATH.
- `SupportVision`, `SupportAudio`, and `SupportVideo` report what the model accepts.

## pkg/download

Use this package to install the libraries from inside your own program, and to download a model.

- `Install` downloads and extracts the libraries for a `Target`.
- `Resolver` names the files to install. Write one to use your own mirror.
- `VerifyInstall` checks the files against the digests of the release.
- `GetModel` downloads a model file.
- `DefaultModelsDir` gives the default directory for models.

## Which package for a browser

A browser program imports `pkg/llamawasm` instead of `pkg/llama` and `pkg/mtmd`. The names and the order of the calls are the same, so a program moves from one to the other with a change of the import.

The browser package is smaller. It has text generation, embeddings, and images. It has no audio, no video, no LoRA adapters, no saved state, and no quantization.
