---
title: "Environment variables"
linkTitle: "Environment"
type: "docs"
weight: 20
description: >
  The variables that yzma reads.
---

## For your programs

### YZMA_LIB

The directory that holds the `llama.cpp` shared library files. This is the only variable that a normal program needs.

{{< tabpane text=true >}}
{{% tab header="Linux and macOS" %}}
```shell
export YZMA_LIB=/path/to/lib
```
{{% /tab %}}
{{% tab header="Windows" %}}
```shell
set YZMA_LIB=C:\yzma\lib
```
{{% /tab %}}
{{< /tabpane >}}

The `yzma install` command and the `yzma verify` command also read it, so the `--lib` flag is not necessary when it is set.

A program does not have to use this variable. `llama.Load` takes any path:

```go
llama.Load("/opt/myapp/lib")
```

### YZMA_VERIFY

How to check the digest of each download.

| Value | What it does |
| --- | --- |
| `available` | Checks a digest when there is one. This is the default. |
| `require` | Fails when an asset has no digest. |
| `off` | Does no check. |

```shell
export YZMA_VERIFY=require
```

See [Verify an installation](/docs/guides/verifying/).

## For the tests of yzma

These variables name the model files that the test suite uses. `make test` sets them.

| Variable | What it names |
| --- | --- |
| `YZMA_TEST_MODEL` | A text model. |
| `YZMA_TEST_MMMODEL` | A multimodal model. |
| `YZMA_TEST_MMPROJ` | The projector of that multimodal model. |
| `YZMA_TEST_QUANTIZE_MODEL` | A model for the quantization tests. |
| `YZMA_TEST_ENCODER_MODEL` | A model that has an encoder. |
| `YZMA_TEST_LORA_MODEL` | A model for the LoRA tests. |
| `YZMA_TEST_LORA_ADAPTER` | A LoRA adapter file. |
| `YZMA_TEST_SPLIT_MODELS` | A model that comes in splits. |
| `YZMA_TEST_VIDEO` | A video file for the mtmd video tests. |
| `YZMA_TEST_LLAMA_TAG` | The `llama.cpp` release tag to test against. |

## For the benchmarks

| Variable | What it names |
| --- | --- |
| `YZMA_BENCHMARK_MODEL` | The text model for the benchmarks. |
| `YZMA_BENCHMARK_MMMODEL` | The multimodal model for the benchmarks. |
| `YZMA_BENCHMARK_MMPROJ` | The projector of that model. |

```shell
yzma model get -u https://huggingface.co/QuantFactory/SmolLM-135M-GGUF/resolve/main/SmolLM-135M.Q2_K.gguf
export YZMA_BENCHMARK_MODEL=~/models/SmolLM-135M.Q2_K.gguf
```

## For the Makefile

| Variable | Default | What it does |
| --- | --- | --- |
| `YZMA_LIB` | `./lib` | Where the Makefile puts the libraries. |
| `MODELS_DIR` | `$HOME/models` | Where the Makefile puts the models. |
| `WASM_DIR` | `build/wasm` | Where the WebAssembly build goes. |
