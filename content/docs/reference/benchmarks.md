---
title: "Benchmarks"
linkTitle: "Benchmarks"
type: "docs"
weight: 70
description: >
  How fast yzma is on many machines.
---

yzma is fast because it calls `llama.cpp` in the same process. There is no external server.

These are the results for yzma 1.28.0 with `llama.cpp` v0.5.0, which is build b11146. Read them with three conditions in mind.

- Each number is the median of five runs.
- The text tables and the multimodal tables use different models and different prompts. A number of one table does not compare with a number of the other.
- The WebAssembly numbers come from the generation loop of the browser example, not from the Go benchmark. They do not compare with the native tables.

The numbers change with each `llama.cpp` release. The [detail files](#the-detail-files) in the repository are always the newest ones. All the measurements here are from 2026-09-24.

## Text generation

The model is `SmolLM-135M.Q2_K`. The benchmark uses 4 threads on each machine.

| Platform | Backend | Machine | Device | Tokens a second |
| --- | --- | --- | --- | --- |
| Linux amd64 | CUDA | Intel Core i9-13900HX | CUDA0 | 853.4 |
| Linux amd64 | Vulkan | AMD EPYC 7443P | Vulkan0 | 806.5 |
| Linux amd64 | Vulkan | Intel Core i9-13900HX | Vulkan1 | 744.2 |
| Linux amd64 | CPU | AMD EPYC 7443P | - | 358.9 |
| Linux amd64 | CPU | Intel Core i9-13900HX | - | 265.1 |
| Linux arm64 | CUDA | Jetson Orin Nano Super | CUDA0 | 190.0 |
| Linux arm64 | Vulkan | Jetson Orin Nano Super | Vulkan0 | 171.6 |
| Linux arm64 | CPU | Jetson Orin Nano Super | - | 84.1 |
| Linux arm64 | CPU | Raspberry Pi 4 Model B | - | 35.4 |
| Linux arm64 | CPU | Arduino UNO Q | - | 32.2 |
| macOS arm64 | CPU | Apple M4 Pro | - | 903.5 |
| macOS arm64 | Metal | Apple M4 Pro | MTL0 | 511.5 |
| macOS arm64 | BLAS | Apple M4 Pro | BLAS | 503.2 |
| Windows amd64 | Vulkan | AMD Ryzen 9 7950X | Vulkan1 | 802.3 |
| Windows amd64 | CUDA | AMD Ryzen 9 7950X | CUDA0 | 700.5 |
| Windows amd64 | CPU | AMD Ryzen 9 7950X | - | 112.9 |

This model is small, so a CPU can be faster than a GPU. The M4 Pro is the example, where the CPU is 1.8 times faster than Metal. A larger model changes the order.

The GPUs are an RTX 4070 Laptop in the Intel Core i9-13900HX, a Radeon RX 7900 XTX in the AMD EPYC 7443P, and an RTX 3070 in the AMD Ryzen 9 7950X. The i9-13900HX and the Ryzen 9 7950X also have an integrated GPU, which is slower. The tables show the fastest device only.

The details are in [linux.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/linux.md), [macos.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/macos.md), and [windows.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/windows.md).

## Multimodal

The model is `SmolVLM-256M-Instruct-Q8_0` with its projector. The benchmark uses one thread for each performance core, thus the CPU rows show the size of the processor.

| Platform | Backend | Machine | Device | Tokens a second |
| --- | --- | --- | --- | --- |
| Linux amd64 | CUDA | Intel Core i9-13900HX | CUDA0 | 2277.0 |
| Linux amd64 | Vulkan | Intel Core i9-13900HX | Vulkan1 | 2133.0 |
| Linux amd64 | Vulkan | AMD EPYC 7443P | Vulkan0 | 1350.0 |
| Linux amd64 | CPU | Intel Core i9-13900HX | - | 878.7 |
| Linux amd64 | CPU | AMD EPYC 7443P | - | 314.5 |
| Windows amd64 | Vulkan | AMD Ryzen 9 7950X | Vulkan1 | 2011.0 |
| Windows amd64 | CUDA | AMD Ryzen 9 7950X | CUDA0 | 1782.0 |
| Windows amd64 | CPU | AMD Ryzen 9 7950X | - | 291.9 |
| macOS arm64 | Metal | Apple M4 Pro | MTL0 | 1091.0 |
| macOS arm64 | CPU | Apple M4 Pro | - | 904.3 |
| macOS arm64 | BLAS | Apple M4 Pro | BLAS | 571.0 |
| Linux arm64 | CUDA | Jetson Orin Nano Super | CUDA0 | 427.3 |
| Linux arm64 | Vulkan | Jetson Orin Nano Super | Vulkan0 | 421.6 |
| Linux arm64 | CPU | Jetson Orin Nano Super | - | 208.3 |
| Linux arm64 | CPU | Raspberry Pi 4 Model B | - | 5.6 |
| Linux arm64 | CPU | Arduino UNO Q | - | 4.1 |

A projector computes many numbers at the same time, which is the function of a GPU. Thus a GPU helps a multimodal model more than a text model.

The details are in the same three files.

## In a browser

The model is `SmolLM-135M.Q2_K`.

| Where | Build | Machine | Tokens a second |
| --- | --- | --- | --- |
| Node | CPU, more threads | Intel Core i9-13900HX | 105.7 |
| Chrome | CPU, more threads | Intel Core i9-13900HX | 91.8 |
| Node | CPU, one thread | Intel Core i9-13900HX | 13.8 |

The build with more threads is 7.7 times faster than the build with one thread. A page gets more than one thread only with the COOP and COEP headers. The [Build for a browser](/docs/guides/browser/) page has them. There is no WebGPU result yet.

The details are in [webassembly.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/webassembly.md).

## Against other engines

yzma calls `llama.cpp` in the same process. ollama and Docker Model Runner answer over an OpenAI compatible REST interface, so each request pays for a round trip.

The machine is an Intel Core i9-13900HX with an RTX 4070. Each suite is five runs.

Embeddings, with `bge-small-en-v1.5-q8_0`, 29 prompt tokens, and a vector of 384.

| Engine | Tokens a second | First token ms |
| --- | --- | --- |
| yzma, in process | 20954.0 | 1.4 |
| ollama, REST | 6968.0 | 4.2 |
| Docker Model Runner, REST | 6366.0 | 4.6 |

yzma is 3.0 to 3.3 times faster here, at 1.4 ms against 4.2 ms and 4.6 ms. The five runs do not overlap.

Text, with 16 tokens, greedy sampling, and one request at a time.

| Engine | gemma4-e2b | qwen3-vl-2b | First token ms, gemma4-e2b |
| --- | --- | --- | --- |
| yzma, in process | 119.0 | 168.7 | 12.2 |
| Docker Model Runner, REST | 107.4 | 160.1 | 25.6 |
| ollama, REST | 106.4 | 153.5 | 23.5 |

yzma is 5.4 to 11.8 percent faster here, and it takes about half the time to the first token.

Images have no numbers yet, because each engine preprocesses an image in a different way.

Each engine brings its own `llama.cpp` build. These numbers are from 2026-09-24, with yzma 1.28.0, ollama 0.34.4, and Docker Model Runner v1.2.8.

The details are in [comparison.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/comparison.md).

## The detail files

Each file has the output of every run and the information of each device.

| File | What is in it |
| --- | --- |
| [linux.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/linux.md) | Linux, amd64 and arm64, CPU, CUDA, and Vulkan |
| [macos.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/macos.md) | macOS, CPU, BLAS, and Metal |
| [windows.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/windows.md) | Windows, CPU, CUDA, and Vulkan |
| [webassembly.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/webassembly.md) | WebAssembly in Node and in a browser |
| [comparison.md](https://github.com/hybridgroup/yzma/blob/main/benchmarks/comparison.md) | yzma against ollama and Docker Model Runner |

## Run the benchmarks yourself

Get the library and the models, then run the script.

```shell
make download-llama.cpp
make download-benchmark-models
./benchmarks/run.sh
```

On Windows, use a PowerShell prompt at the root of the repository. A Command Prompt opens the file in an editor and does not run it.

```powershell
powershell -ExecutionPolicy Bypass -File .\benchmarks\run.ps1
```

The script asks `llama.cpp` which devices the machine has. It runs the text suite and the multimodal suite for each one, and it writes each result to the file of the platform. It takes the `llama.cpp` tag from `yzma-install.json` of the library directory.

| Flag | What it does |
| --- | --- |
| `--backend` | One backend only, as `vulkan`. |
| `--suite` | One suite only, as `text`. |
| `--machine` | The key of the section. The default is the host name. |
| `--label` | The name of the machine in the table. |
| `--llamacpp` | The build tag, when the library came from elsewhere. |
| `--threads` | The count of CPU threads for both suites. `0` gives one for each performance core. |
| `--threadpool` | Holds each CPU thread to a CPU of its own. |
| `--dry-run` | Prints the result and changes no file. |

Without `--threadpool`, the system moves the threads during the work. A short run then gives a low number, and each run gives a different number. The flag works only on Linux. On macOS and Windows the benchmark stops with an error, because these systems do not say which CPUs are performance CPUs.

The text suite uses 4 threads on each machine, because more threads make this small model slower. The threads wait for each other after each operation. The multimodal suite uses one thread for each performance core, as a yzma program does.

The PowerShell script takes the same names with one dash and a capital, as `-Backend` and `-DryRun`. The flags go after the name of the file.

The machine name is part of the key of a section. Give the same name each time, or the file gets two sections for one machine.

## Compare yzma with other engines yourself

This suite needs the servers to run, and each one needs the model.

```shell
make download-compare-models
docker model pull hf.co/qwen/qwen3-vl-4b-instruct-gguf:q4_k_m
./benchmarks/compare.sh
```

Every engine must read the same GGUF file. Thus the commands take the file of Hugging Face and not `gemma4:e4b` or `ai/gemma3`, which are the conversions of a vendor. The script says which command gets a model that is absent.

See [Environment variables](/docs/reference/environment/) for the variables that the benchmarks read.

## Measure your own program

```go
llama.PerfContextPrint(ctx)
llama.PerfSamplerPrint(sampler)
```

These print how much time each part used.
