---
title: "Platforms"
linkTitle: "Platforms"
type: "docs"
weight: 30
description: >
  What yzma runs on.
---

## Operating systems and processors

| Operating system | CPU | GPU |
| --- | --- | --- |
| Linux | amd64, arm64 | CUDA, Vulkan, HIP, ROCm, SYCL |
| macOS | arm64 | Metal |
| Windows | amd64 | CUDA, Vulkan, HIP, SYCL, OpenCL |

A browser is also a target:

| Target | CPU | GPU |
| --- | --- | --- |
| Browser | wasm32 SIMD, one or more threads | WebGPU |

In a browser the API is the smaller one of `pkg/llamawasm`. It has no audio, no video, no LoRA adapters, no saved state, and no quantization.

## Boards

| Board | Notes |
| --- | --- |
| Raspberry Pi 4 and 5 | The 64 bit Raspberry Pi OS. Install with `--os trixie` or `--os bookworm`. |
| NVIDIA Jetson Orin | Install Jetpack first. CUDA or Vulkan. |
| Arduino UNO Q | Install with `--os trixie`. |

## Go version

yzma needs Go 1.26 or later.

A browser build needs TinyGo 0.41.1 or later. TinyGo 0.41.1 works with Go 1.26 and not with Go 1.27.

## Required versions of llama.cpp

Sometimes a change in `llama.cpp` breaks yzma. These are the known compatible versions for the tagged releases.

| llama.cpp | yzma |
| --- | --- |
| v0.3.0 | v1.25.0 |
| v0.4.0 | v1.26.0 to v1.26.1 |

A tagged release of yzma installs its own `llama.cpp` release by default. Thus `yzma install` with no `--version` flag gets the version in this table. Use `-version latest` to get the most recent nightly build. A build from the `main` branch always uses the most recent nightly build.

These are some of the known compatible versions for the nightly builds.

| llama.cpp | yzma |
| --- | --- |
| up to b8864 | v1.12.0 |
| b8865 to b9179 | v1.13.0 |
| b9180 to b9459 | v1.14.1 |
| b9460 to b9540 | v1.15.0 |
| b9541 to b9548 | v1.16.0 |
| b9549 to b9561 | v1.16.1 |
| b9562 to b9611 | v1.17.0 |
| b9616 to b9749 | v1.17.1 |
| b9650 to b9978 | v1.18.0 |
| b9979 to b10103 | v1.19.0 |
| b10105 to b10211 | v1.20.0 to v1.21.0 |
| b10212 to b10257 | v1.22.0 |
| b10273 to b10544 | v1.23.0 |
| b10545 to b10779 | v1.24.0 to v1.25.0 |
| b10780 and later | v1.26.0 and later |

The tests of yzma run automatically when there is a new release of `llama.cpp`. This keeps yzma up to date with the newest code and models.

For the current list, see [the README](https://github.com/hybridgroup/yzma#required-versions-of-llamacpp).

## Where the libraries come from

Most of the prebuilt binaries come from the `llama.cpp` releases:

https://github.com/ggml-org/llama.cpp/releases

The Hybrid Group builds the Ubuntu arm64 CUDA and Vulkan binaries, and the WebAssembly builds:

https://github.com/hybridgroup/llama-cpp-builder/releases

## Extra software

| What | When you need it |
| --- | --- |
| CUDA drivers | A GPU with CUDA. |
| ROCm 7.2 | An AMD GPU with ROCm. |
| Vulkan drivers | Vulkan on Linux. The LunarG SDK on Windows. |
| `ffmpeg` and `ffprobe` | Video input with mtmd. |
| TinyGo | A browser build. |
