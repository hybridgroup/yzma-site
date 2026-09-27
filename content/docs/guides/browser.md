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
| `yzma_wasm_webgpu` | WebGPU with f16 shaders, and JSPI. Chrome and Edge 137 or later, or Firefox 153 or later. Auto mode skips it in Firefox, which is faster on the CPU. The loader also drops this build if the self test of the GPU fails. |
| `yzma_wasm_mt` | `SharedArrayBuffer`, so a page with the COOP header and the COEP header. |
| `yzma_wasm` | Nothing. It works in every browser. |

A page can set the choice with `globalThis.yzmaMode`. The values are `auto`, which is the default, `webgpu`, and `cpu`. A page URL also accepts `?mode=cpu` or `?mode=webgpu`.

A machine with an integrated GPU and a discrete GPU gives the browser a choice. A page picks one with `globalThis.yzmaPowerPreference`, which takes `high-performance` or `low-power`. A page URL also accepts `?gpu=high-performance` or `?gpu=low-power`. With no value the browser picks. The loader tests that GPU and makes `llama.cpp` ask for the same one.

With `webgpu` the loader still falls back to the CPU when the browser cannot run that build. A slow page is better than a page that does not work.

Ask `llama.cpp` which device does the work, not the browser. A page can have WebGPU while `llama.cpp` finds no device.

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

A host such as GitHub Pages sends no headers. A page there gets them from a service worker such as `coi-serviceworker`. Such a worker must not send the download of the model through `respondWith`. Firefox stops a service worker that holds a response open for a long time, and the download then fails with `TypeError: Error in input stream`. Let the browser make the cross origin request instead, for example with `event.stopImmediatePropagation()` in a listener that runs before the worker's listener.

An isolated page can get a model from another origin only when that origin sends the CORS headers. Hugging Face sends them. A model on a host with no CORS headers must be copied to the origin of the page.

## Threads

`llama.cpp` asks for four threads unless a caller changes it. A machine with more cores then loses a lot of speed.

| Tokens a second, in Chrome | Four threads | Every thread |
| --- | --- | --- |
| SmolLM-135M Q2_K | 55.9 | 63.3 |
| Gemma 3 1B Q2_K | 8.7 | 18.5 |
| SmolVLM-256M Q8_0, the answer | 56.3 | 96.9 |

So `ContextDefaultParams` and `MtmdContextParamsDefault` send `llamawasm.Threads()`, which the JavaScript glue reads from the machine.

The threads have no effect on an image. The projector used 30.4 seconds on four threads and 33.3 seconds on sixteen. The GPU makes an image fast, not the CPU.

## Speed

The numbers are on the [Benchmarks](/docs/reference/benchmarks/#in-a-browser) page. With `SmolLM-135M.Q2_K` on an Intel Core i9-13900HX in Chrome, the build with more threads gives 92.8 tokens a second. WebGPU gives 69.8 on an RTX 4070 and 19.9 on the Intel graphics of the same machine.

To measure a build, run `./benchmarks/run.sh --backend wasm` in the yzma repository for Node. For a browser, which WebGPU needs, paste `benchmarks/browser-bench.js` in the console of the page. Set `gpu` in the script to pick the GPU.

On a small model the CPU with more threads is faster than the GPU, because each operation is too small to be worth the transfer to the GPU. The GPU does better on a larger model. Test both with `?mode=cpu` and `?mode=webgpu`.

An image gives a different result. A photo of 960 by 720 through the projector of SmolVLM-256M Q8_0 takes 42.7 seconds on the CPU with more threads and 1.6 seconds with WebGPU.

A projector does many calculations at the same time, which is what a GPU is built for. That makes the GPU 25 times faster. A page with images needs WebGPU more than a page with text only.

The CPU builds give the same text each time. The GPU gives the same text for the first tokens and then different text, because the shaders do the calculations in a different order.

## Images

The page decodes the image, not `llama.cpp`. It draws the file on a canvas and sends the pixels to the program.

```js
const bitmap = await createImageBitmap(file);
context.drawImage(bitmap, 0, 0, width, height);
const { data } = context.getImageData(0, 0, width, height); // RGBA
worker.postMessage({ kind: "describe", prompt, width, height, rgba: data.buffer }, [data.buffer]);
```

So every format that the browser can read works, and the WebAssembly build needs no image library. The Go side removes the alpha byte and sends the RGB to mtmd.

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

This downloads two files, the model and its projector.

## Tool calling

`pkg/template` and `pkg/message` are pure Go, so they build for WebAssembly. The browser gets the same tool calling as a host.

```go
tmpl := llamawasm.ModelChatTemplate(model, "")
prompt, err := template.ApplyWithTools(tmpl, messages, tools, true)
```

`message.ParseToolCalls` reads the calls out of the answer. The program runs them, appends a `message.Tool` and a `message.ToolResponse`, and renders again for the final answer.

A model must be trained for tool calls to make one. Qwen2.5-0.5B-Instruct is about the smallest that works.

`llamawasm.ChatApplyTemplate` takes one message only. Use `pkg/template` for a conversation with turns.

The shim has no end of turn token, so the WebAssembly build uses the text of the end of sequence token and tries a short list of the usual markers. A host build reads the token itself.

## WebGPU settings

### f16 shaders and NVIDIA

The backend of `llama.cpp` needs `shader-f16` and reports no device without it. In a browser the backend uses the browser's adapter and sets no options.

- An Intel integrated GPU gives f16 and the WebGPU build works.
- A discrete NVIDIA card does not give f16 in a browser. Dawn has the `vulkan_enable_f16_on_nvidia` option, and `llama.cpp` sets it outside a browser but not in one. A page cannot set it, because it is a flag of the browser. Start Chrome with this command:

```shell
google-chrome --enable-dawn-features=vulkan_enable_f16_on_nvidia
```

On Linux this switch alone is not enough. See [Vulkan in Chrome on Linux](#vulkan-in-chrome-on-linux).

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

Chrome on Linux keeps Vulkan off. WebGPU then uses the OpenGL ES backend of ANGLE, in Dawn's compatibility mode. `chrome://gpu` shows `Vulkan: Disabled`, and the first adapter of Dawn Info is an `OpenGLES backend` line with `(Compatibility Mode)` at the end.

This path gives one of two results, and neither is good.

- On many cards the adapter has no `shader-f16`. `llama.cpp` then finds no device and the loader takes the CPU. The page is slow but correct.
- On an Intel Xe with Mesa the adapter has `shader-f16`, `llama.cpp` takes it, and it computes wrong values. The [self test](#the-self-test-of-the-gpu) catches this case and takes the CPU. See [issue #341](https://github.com/hybridgroup/yzma/issues/341).

These three switches give Chrome the Vulkan backend. Close all Chrome windows first, and make sure no Chrome process keeps running in the background.

```shell
google-chrome --enable-unsafe-webgpu --enable-features=Vulkan \
  --enable-dawn-features=vulkan_enable_f16_on_nvidia
```

| Switch | Why |
| --- | --- |
| `--enable-unsafe-webgpu` | Turns off Dawn's list of blocked adapters. Without it Chrome hides the Vulkan adapters and gives only the OpenGL ES adapter. |
| `--enable-features=Vulkan` | Turns on Vulkan in Chrome's GPU process. |
| `--enable-dawn-features=vulkan_enable_f16_on_nvidia` | Gives `shader-f16` on an NVIDIA card. |

All three are needed. `--use-angle=vulkan` is not. If a switch seems to do nothing, check the command line in `chrome://version`.

On Chrome 154 with Ubuntu 24.04, an Intel Raptor Lake, and an RTX 4070, the three switches give a Vulkan adapter for each GPU, both with `shader-f16`. This check in the console of any page lists them.

```js
for (const p of ["low-power", "high-performance"]) {
  const a = await navigator.gpu.requestAdapter({ powerPreference: p });
  console.log(p, a && a.info.vendor, a && a.info.architecture,
    a && a.features.has("shader-f16"));
}
```

A good result names a GPU on each line, not `swiftshader`, and ends with `true`.

Issue #341 was tested with only the last two switches. On Ubuntu 22.04 with Mesa 23.2.1, Dawn then still gave the OpenGL ES adapter. Such a machine can try all three. Without them the self test takes the CPU.

### Firefox

Firefox runs the WebGPU build, but WebGPU is not on by default. Set both of these in `about:config` and restart the browser.

| Switch | Why |
| --- | --- |
| `dom.webgpu.enabled` | WebGPU on Linux is still behind this switch. |
| `dom.webgpu.workers.enabled` | `llama.cpp` loads in the worker, so WebGPU in a page is not enough. |

JSPI arrived in Firefox 153, so 153 or later needs no other switches.

Firefox 154 gave `llama.cpp` wrong values. Firefox 156 gives the right text, but very slowly.

| Firefox 156 | Tokens a second |
| --- | --- |
| WebGPU, Intel graphics | 0.66 |
| WebGPU, RTX 4070 | 0.71 |
| CPU, more threads | 123 |

The RTX 4070 is no faster than the Intel graphics, so the time goes to Firefox and not to the GPU. Auto mode takes the CPU in Firefox. Mode `webgpu` still selects the GPU, which makes it easy to test a new Firefox.

## Limits

- WebGPU needs an adapter with f16 shaders, and Chrome or Edge 137 or later. Firefox 153 or later can run it, but the loader takes the CPU there because it is faster. Every other browser uses the CPU with SIMD.
- A browser does not give the matrix instructions of a subgroup, which `llama.cpp` uses only outside a browser. So the GPU is slower in a page than the same backend on a desktop.
- Some drivers give an adapter that `llama.cpp` accepts and that computes wrong values. The loader then takes a CPU build.
- An operation larger than `maxStorageBufferBindingSize` goes back to the CPU.
- One JavaScript ArrayBuffer holds a maximum of 2 GB, so a larger model must come in splits.
- `pkg/llamawasm` has text generation, embeddings, and images. It doesn't support audio, video, LoRA adapters, saving state to a file, or quantization. It saves context state in memory.
- The shim gives no grammar sampler, so a tool call cannot be forced by a grammar as it can on a host.
