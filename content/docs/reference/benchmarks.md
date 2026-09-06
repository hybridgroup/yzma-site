---
title: "Benchmarks"
linkTitle: "Benchmarks"
type: "docs"
weight: 70
description: >
  How fast yzma is on many machines.
---

yzma is fast because it calls `llama.cpp` in the same process. There is no external server.

The complete measurements change with each release, so they stay in the repository:

**[BENCHMARKS.md](https://github.com/hybridgroup/yzma/blob/main/BENCHMARKS.md)**

That page has results for Linux with a CPU on amd64 and arm64, Linux with CUDA, ROCm, and Vulkan, macOS with Metal, and Windows with a CPU, CUDA, and Vulkan. Each group has text model results and multimodal model results.

## An example

The `Qwen3-VL-2B-Instruct` Vision Language Model doing inference on an image and a text prompt, on an Apple M4 Max with 128 GB of RAM:

```shell
$ go test -run none -benchtime=10s -count=5 -bench BenchmarkMultimodalInference
goos: darwin
goarch: arm64
pkg: github.com/hybridgroup/yzma/pkg/mtmd
cpu: Apple M4 Max
BenchmarkMultimodalInference-16		10		1577948683 ns/op	788.9 tokens/s
BenchmarkMultimodalInference-16		12		1243692014 ns/op	910.8 tokens/s
BenchmarkMultimodalInference-16		 7		1654741804 ns/op	737.2 tokens/s
BenchmarkMultimodalInference-16		 7		1568106947 ns/op	771.9 tokens/s
BenchmarkMultimodalInference-16		10		1704669371 ns/op	706.1 tokens/s
PASS
ok  	github.com/hybridgroup/yzma/pkg/mtmd	76.644s
```

## Run the benchmarks yourself

Download the model and set the variable:

```shell
yzma model get -u https://huggingface.co/QuantFactory/SmolLM-135M-GGUF/resolve/main/SmolLM-135M.Q2_K.gguf
export YZMA_BENCHMARK_MODEL=~/models/SmolLM-135M.Q2_K.gguf
export YZMA_LIB=/path/to/lib
```

Then run the text benchmarks:

```shell
go test -run none -bench . ./pkg/llama/
```

For the multimodal benchmarks, set `YZMA_BENCHMARK_MMMODEL` and `YZMA_BENCHMARK_MMPROJ`, then:

```shell
go test -run none -bench . ./pkg/mtmd/
```

See [Environment variables](/docs/reference/environment/).

## In a browser

The browser measurements are on the [Build for a browser](/docs/guides/browser/) page.

## Measure your own program

```go
llama.PerfContextPrint(ctx)
llama.PerfSamplerPrint(sampler)
```

These print how much time each part used.
