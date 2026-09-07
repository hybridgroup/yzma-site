---
title: "Browser"
linkTitle: "Browser"
type: "docs"
weight: 80
description: >
  How to install the WebAssembly build of llama.cpp for a browser.
---

yzma runs in a browser with the WebAssembly build of `llama.cpp`.

```shell
yzma install --lib /path/to/web --os wasm
```

This command downloads all three builds. There is a build for WebGPU, a build with more than one thread, and a build with one thread. The JavaScript glue selects the best build that the page can run.

| Build | What the browser must have |
| --- | --- |
| WebGPU | WebGPU with f16 shaders, and JSPI. Chrome or Edge 137 and later, or Firefox 153 and later with two settings in `about:config`. |
| More threads | `SharedArrayBuffer`, so the page must send the COOP header and the COEP header. |
| One thread | Nothing. It works in every browser. |

A browser with no WebGPU still works. It runs on the CPU.

Every build holds the multimodal library, so a model with a projector works for images.

A browser program uses the smaller API of the [`pkg/llamawasm`](https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llamawasm) package. The names and the order of the calls are the same as in `pkg/llama`, so a program moves from one to the other with a change of the import.

You also need [TinyGo](https://tinygo.org) 0.41.1 or later to build the program.

## Next steps

[Try it in your browser](/try/) runs such a page now, with no install. See [Run yzma in a browser](/docs/tutorials/browser/) for a complete lesson, and [WebAssembly](/docs/concepts/webassembly/) for how it works.
