---
title: "Build for a browser"
linkTitle: "Browser"
type: "docs"
weight: 90
description: >
  Threads, headers, WebGPU, and the limits of a page.
---

This page holds the details for a program that runs in a browser. See [the tutorial](/docs/tutorials/browser/) to build and run one, and [WebAssembly](/docs/concepts/webassembly/) for how the parts fit together.

## Select the build

`yzma-loader.js` selects the best build that the browser can run.

| Build | What the browser must have |
| --- | --- |
| `yzma_wasm_webgpu` | WebGPU with f16 shaders, and JSPI. Chrome and Edge 137 or later. The loader also drops this build if the self test of the GPU fails. |
| `yzma_wasm_mt` | `SharedArrayBuffer`, so a page with the COOP header and the COEP header. |
| `yzma_wasm` | Nothing. It works in every browser. |

A page can set the choice with `globalThis.yzmaMode`. The values are `auto`, which is the default, `webgpu`, and `cpu`. A page URL also accepts `?mode=cpu` or `?mode=webgpu`.

With `webgpu` the loader still falls back to the CPU when the browser cannot run that build. A slow page is better than a page that does not work.

Ask `llama.cpp` which part computes, not the browser. A page can have WebGpu while `llama.cpp` finds no device.

```go
backend := llamawasm.Backend()
device := llamawasm.GPUDevice()
```

## Headers for more than one thread

The faster CPU build needs `SharedArrayBuffer`. A browser gives that only to a page with these headers.

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

`wasm/serve/main.go` sends them. When a host sends no headers, the loader takes the build with one thread. `llamawasm.Threaded()` reports the selection.

A host such as GitHub Pages sends no headers. A page there gets them from a service worker such as `coi-serviceworker`. Such a worker must not send the download of the model through `respondWith`. Firefox stops a service worker that holds a response open for a long time, and the download then fails with `TypeError: Error in input stream`. Let the browser make the cross origin request instead, for example with `event.stopImmediatePropagation()` in a listener before the one of the worker.

An isolated page can get a model from another origin only when that origin sends the CORS headers. Hugging Face sends them. A model on a host with no CORS headers needs a copy on the origin of the page.

## Threads

`llama.cpp` asks for four threads unless a caller changes it. A machine with more cores then loses much speed.

| Tokens a second, in Chrome | Four threads | Every thread |
| --- | --- | --- |
| SmolLM-135M Q2_K | 55.9 | 63.3 |
| Gemma 3 1B Q2_K | 8.7 | 18.5 |
| SmolVLM-256M Q8_0, the answer | 56.3 | 96.9 |

Thus `ContextDefaultParams` and `MtmdContextParamsDefault` send `llamawasm.Threads()`, which the JavaScript glue reads from the machine.

The threads have no effect on an image. The projector used 30.4 seconds on four threads and 33.3 seconds on sixteen. The GPU makes an image fast, not the CPU.

## Speed

The numbers are on the [Benchmarks](/docs/reference/benchmarks/#in-a-browser) page. With `SmolLM-135M.Q2_K` on an Intel Core i9-13900HX, the build with more threads gives 91.8 tokens a second in Chrome. That is 7.7 times the build with one thread.

To measure a build, run `./benchmarks/run.sh --backend wasm` in the yzma repository for Node. For a browser, which WebGPU needs, paste `benchmarks/browser-bench.js` in the console of the page.

The GPU is faster on a larger model. On a small model the CPU and the GPU agree, because each operation is too small to justify the transfer to the GPU. Test both with `?mode=cpu` and `?mode=webgpu`.

An image gives a different result. A photo of 960 by 720 through the projector of SmolVLM-256M Q8_0 takes 42.7 seconds on the CPU with more threads and 1.6 seconds with WebGPU.

A projector computes many numbers at the same time, which is the function of a GPU. Thus the GPU is 25 times faster. A page with images needs WebGPU more than a page with text only.

The CPU builds give the same text each time. The GPU gives the same text for the first tokens and then different text, because the shaders do the calculations in a different order.

## Images

The page decodes the image, not `llama.cpp`. It draws the file on a canvas and sends the pixels to the program.

```js
const bitmap = await createImageBitmap(file);
context.drawImage(bitmap, 0, 0, width, height);
const { data } = context.getImageData(0, 0, width, height); // RGBA
worker.postMessage({ kind: "describe", prompt, width, height, rgba: data.buffer }, [data.buffer]);
```

Thus every format that the browser reads is usable, and the WebAssembly build needs no image library. The Go side removes the alpha byte and sends the RGB to mtmd.

The multimodal calls have an `Mtmd` prefix, because one package holds the llama calls as well.

```go
mctx, err := llamawasm.MtmdInitFromFile("/models/mmproj.gguf", model, 0, onGPU)
bitmap, err := llamawasm.MtmdBitmapInit(width, height, rgb)
chunks, err := llamawasm.MtmdInputChunksInit()
llamawasm.MtmdTokenize(mctx, chunks, prompt, true, true, []llamawasm.MtmdBitmap{bitmap})
nPast, err := llamawasm.MtmdHelperEvalChunks(mctx, ctx, chunks, 0, 0, nBatch, true)
```

Then the usual loop of `SamplerSample` and `Decode` follows, the same as for text.

The prompt must hold one marker for each image. `MtmdMarker` gives the marker of the model.

Two files come down for this, the model and its projector.

## Tool calling

`pkg/template` and `pkg/message` are pure Go, so they build for WebAssembly. The browser gets the same tool calling as a host.

```go
tmpl := llamawasm.ModelChatTemplate(model, "")
prompt, err := template.ApplyWithTools(tmpl, messages, tools, true)
```

`message.ParseToolCalls` reads the calls out of the answer. The program runs them, appends a `message.Tool` and a `message.ToolResponse`, and renders again for the final answer.

A model must be trained for tool calls to make one. Qwen2.5-0.5B-Instruct is about the smallest that works.

`llamawasm.ChatApplyTemplate` takes one message only. Use `pkg/template` for a conversation with turns.

The shim gives no end of turn token, so the WebAssembly build takes the text of the end of sequence token and tries a short list of the usual markers. A host build reads the token itself.

## WebGPU settings

### f16 shaders and NVIDIA

The backend of `llama.cpp` needs `shader-f16` and reports no device without it. In a browser the backend uses the adapter of the browser and sets no options.

- An Intel integrated GPU gives f16 and the WebGPU build works.
- A discrete NVIDIA card does not give f16 in a browser. Dawn has the `vulkan_enable_f16_on_nvidia` option, and `llama.cpp` sets it outside a browser but not in one. A page cannot set it, because it is a flag of the browser. Start Chrome with this command:

```shell
google-chrome --enable-dawn-features=vulkan_enable_f16_on_nvidia
```

### The self test of the GPU

A GPU that `llama.cpp` accepts can still compute wrong values. The answer of the model is then random tokens, and nothing in the text shows that the fault is the GPU and not a weak model. So the loader measures the device.

Before it gives the module to the page, `yzma-loader.js` runs one small matrix multiply on the GPU and the same one on the CPU. It compares the two results with the normalized mean squared error. A good device gives about 3e-8 and noise gives about 1. The limit is 1e-2. The test needs no model and takes a few milliseconds.

When the test fails, the loader drops the GPU build and takes a CPU build. `globalThis.yzmaGPUReject` holds the reason. A Go program gets the same answer from `llamawasm.BackendOK()`.

```go
if !llamawasm.BackendOK() {
	// The GPU computed wrong values, so the page runs on the CPU.
}
```

`BackendOK` is true for a build with only the CPU, and for a module older than ABI 8, which has no test.

### Vulkan in Chrome on Linux

Chrome on Linux keeps Vulkan off. WebGPU then uses the OpenGL ES backend of ANGLE, in the compatibility mode of Dawn. `chrome://gpu` shows `Vulkan: Disabled`, and the first adapter of Dawn Info is an `OpenGLES backend` line with `(Compatibility Mode)` at the end.

This path gives one of two results, and neither is good.

- On many cards the adapter has no `shader-f16`. `llama.cpp` then finds no device and the loader takes the CPU. The page is slow but correct.
- On an Intel Xe with Mesa the adapter has `shader-f16`, `llama.cpp` takes it, and it computes wrong values. The [self test](#the-self-test-of-the-gpu) catches this case and takes the CPU. See [issue #341](https://github.com/hybridgroup/yzma/issues/341).

These switches ask Chrome for the Vulkan backend. Close every window of Chrome first.

```shell
google-chrome --enable-features=Vulkan \
  --enable-dawn-features=vulkan_enable_f16_on_nvidia
```

`chrome://gpu` must then say `Vulkan: Enabled`, and the first adapter of Dawn Info must be a `Vulkan backend` line with the name of the card.

The switches are worth a test, but they are not a repair. On Ubuntu 22.04 with Mesa 23.2.1, Chrome says `Vulkan: Enabled` and Dawn still gives the OpenGL ES adapter, so the GPU still computes wrong values. Such a machine has no GPU path that works, and the self test takes the CPU.

### Firefox

Firefox runs the WebGPU build, but WebGPU is not on by default. Set both of these in `about:config` and restart the browser.

| Switch | Why |
| --- | --- |
| `dom.webgpu.enabled` | WebGPU on Linux is still behind this switch. |
| `dom.webgpu.workers.enabled` | `llama.cpp` loads in the worker, so WebGPU in a page is not sufficient. |

JSPI came in Firefox 153, so 153 or later needs no more switches.

The WebGPU of Firefox gives wrong values to `llama.cpp`, so auto mode takes the CPU there. Mode `webgpu` still selects the GPU, which makes a test of a repair easy.

## Limits

- WebGPU needs an adapter with f16 shaders, and Chrome or Edge 137 or later. Every other browser uses the CPU with SIMD.
- A browser does not give the matrix instructions of a subgroup, which `llama.cpp` uses only outside a browser. Thus the GPU is slower in a page than the same backend on a desktop.
- Some drivers give an adapter that `llama.cpp` accepts and that computes wrong values. The loader then takes a CPU build.
- An operation larger than `maxStorageBufferBindingSize` goes back to the CPU.
- One JavaScript ArrayBuffer holds a maximum of 2 GB, so a larger model must come in splits.
- `pkg/llamawasm` has text generation, embeddings, and images. It has no audio, no video, no LoRA adapters, no saved state, and no quantization.
- The shim gives no grammar sampler, so a tool call cannot be forced by a grammar as it can on a host.
