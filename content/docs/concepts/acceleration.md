---
title: "Hardware acceleration"
linkTitle: "Acceleration"
type: "docs"
weight: 30
description: >
  How yzma uses the CPU and the GPU of your machine.
---

`llama.cpp` has a backend for each kind of processor. `yzma` installs the backend that you name, and `llama.cpp` uses it.

## What each platform supports

| Operating system | CPU | GPU |
| --- | --- | --- |
| Linux | amd64, arm64 | CUDA, Vulkan, HIP, ROCm, SYCL |
| macOS | arm64 | Metal |
| Windows | amd64 | CUDA, Vulkan, HIP, SYCL, OpenCL |

A browser is also a target:

| Target | CPU | GPU |
| --- | --- | --- |
| Browser | wasm32 SIMD, one or more threads | WebGPU |

## Which backend to choose

| Backend | Use it when |
| --- | --- |
| CPU | You have no GPU, or the model is small. |
| CUDA | You have an NVIDIA GPU. This is the fastest choice on NVIDIA hardware. |
| Metal | You have a Mac with Apple silicon. No installation is necessary. |
| ROCm | You have an AMD GPU and the ROCm 7.2 drivers. |
| Vulkan | You have a GPU but no vendor driver stack. Vulkan works on many cards. |
| WebGPU | Your program runs in a browser. |

Name the backend with the `--processor` flag:

```shell
yzma install --lib /path/to/lib --processor cuda
```

`yzma` also finds CUDA and ROCm without help. `download.HasCUDA()` and `download.HasROCm()` report what the machine has.

## See what your machine has

The `systeminfo` example program lists the devices that `llama.cpp` found:

```shell
go run ./examples/systeminfo/
```

The `yzma system` command gives the same information:

```shell
yzma system
```

## Layers on the GPU

`ModelParams.NGpuLayers` sets how many layers of the model go to the GPU. Put all of the layers on the GPU when the model fits in the GPU memory. Put fewer layers there when it does not fit.

`llama.SupportsGpuOffload()` reports if the build can move layers at all.

## Mixture of Experts models

A Mixture of Experts model has weights that most tokens do not use. You can keep those weights in the CPU memory and keep the rest on the GPU. This makes a large model fit on a small GPU.

The `chat` example has two flags for this:

- `-cmoe` keeps all of the expert weights in the CPU.
- `-ncmoe N` keeps the expert weights of the first N layers in the CPU.

## Speed

yzma calls `llama.cpp` in the same process, so there is no cost for a network call and no cost to start a server.

See [Benchmarks](/docs/reference/benchmarks/) for measurements on many machines.
