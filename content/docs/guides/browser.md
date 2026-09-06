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
| `yzma_wasm_webgpu` | WebGPU with f16 shaders, and JSPI. Chrome and Edge 137 or later. |
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

Measured in Chrome on one machine, an RTX 4070 with an Intel integrated GPU, with the greedy sampler.

| Model | Backend | Tokens a second |
| --- | --- | --- |
| SmolLM-135M Q2_K | one thread | 10.8 |
| SmolLM-135M Q2_K | more threads | 63.3 |
| SmolLM-135M Q2_K | WebGPU | 63.3 |
| Gemma 3 1B Q2_K | more threads | 18.5 |
| Gemma 3 1B Q2_K | WebGPU | 38.7 |

The GPU is faster on the larger model. On the smaller model the two results agree, because each operation is too small to justify the transfer to the GPU.

An image gives a different result. This is the same photo of 960 by 720 through the projector of SmolVLM-256M Q8_0, and then 32 tokens of answer.

| Backend | Time for the image | Tokens a second |
| --- | --- | --- |
| more threads, in Chrome | 42.7 s | 96.9 |
| WebGPU, in Chrome | 1.6 s | 64.4 |
| one thread, in Node | 80 s | 17.4 |

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

### Vulkan in Chrome on Linux

Chrome on Linux keeps Vulkan off. WebGPU then uses the OpenGL ES backend of ANGLE, which has no `shader-f16` on any card. Start Chrome with both switches, and close every window of Chrome first.

```shell
google-chrome --enable-features=Vulkan \
  --enable-dawn-features=vulkan_enable_f16_on_nvidia
```

`chrome://gpu` then says `Vulkan: Enabled`.

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
- An operation larger than `maxStorageBufferBindingSize` goes back to the CPU.
- One JavaScript ArrayBuffer holds a maximum of 2 GB, so a larger model must come in splits.
- `pkg/llamawasm` has text generation, embeddings, and images. It has no audio, no video, no LoRA adapters, no saved state, and no quantization.
- The shim gives no grammar sampler, so a tool call cannot be forced by a grammar as it can on a host.
