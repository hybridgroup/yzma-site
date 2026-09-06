---
title: "Browser"
linkTitle: "Browser"
type: "docs"
weight: 60
description: >
  Run yzma in a web page.
---

yzma runs in a browser. The model stays on the machine of the reader, and no server does the work.

## Before you start

You need [TinyGo](https://tinygo.org) 0.41.1 or later, and a clone of the yzma repository.

```shell
git clone https://github.com/hybridgroup/yzma.git
cd yzma
```

## Get the WebAssembly build

```shell
make download-llama.cpp-wasm
```

This is the same as:

```shell
yzma install --lib ./build/wasm --os wasm
```

It downloads all three builds. There is a build for WebGPU, a build with more than one thread, and a build with one thread.

## Build the programs

```shell
make wasm-example
make wasm-vlm-example
make wasm-tools-example
```

`make wasm-example-go` builds the same program with the standard Go toolchain. The binary is larger. Use it if TinyGo cannot build a dependency.

## Serve the pages

```shell
make serve-wasm
```

Then open these pages.

- http://localhost:8080 is the chat page.
- http://localhost:8080/vlm.html asks a question about an image.
- http://localhost:8080/tools.html lets the model call tools.

Each page says which build it got:

```
backend: webgpu (WebGPU)
```

Add `?mode=cpu` or `?mode=webgpu` to the URL to select the backend yourself.

## The Go code

A browser program imports `pkg/llamawasm` in place of `pkg/llama` and `pkg/mtmd`. The names and the order of the calls are the same.

```go
//go:build js && wasm

package main

import "github.com/hybridgroup/yzma/pkg/llamawasm"

func main() {
	llamawasm.Load()
	llamawasm.Init()

	model, _ := llamawasm.ModelLoadFromFile(path, llamawasm.ModelDefaultParams())
	ctx, _ := llamawasm.InitFromModel(model, llamawasm.ContextDefaultParams())

	// The rest is the same as a native program.
}
```

[See the code](https://github.com/hybridgroup/yzma/blob/main/examples/wasm/chat/main.go), or [the one that takes an image](https://github.com/hybridgroup/yzma/blob/main/examples/wasm/vlm/main.go).

## Extra calls for a browser

| Function | What it gives |
| --- | --- |
| `Backend()` | The name of the build that the page got. |
| `GPUDevice()` | The name of the GPU, when there is one. |
| `Threaded()` | Reports if the build uses more than one thread. |
| `Threads()` | How many threads the machine has. |
| `FetchModelFile` | Downloads a model into the browser. |
| `WriteModelFile` | Writes a model that the reader selected. |
| `RemoveModelFile` | Removes a model from the browser. |

## Test without a browser

```shell
make wasm-example
make test-wasm
```

`node/run.js` loads a small model, makes tokens with the greedy sampler, and prints them. The greedy sampler always takes the most probable token, so the output does not change and a test can compare it.

`make test-wasm-mt` does the same with the build that uses more than one thread. `make test-wasm-webgpu` tests the fallback from WebGPU.

## Next steps

- [Build for a browser](/docs/guides/browser/) shows the headers, the threads, and the WebGPU settings.
- [WebAssembly](/docs/concepts/webassembly/) shows how the two modules work together.
