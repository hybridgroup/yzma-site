---
title: "Roadmap"
linkTitle: "Roadmap"
type: "docs"
weight: 60
description: >
  How much of llama.cpp yzma covers.
---

yzma covers more than 96 percent of `llama.cpp` functionality.

The complete list changes with each release, so it stays in the repository:

**[ROADMAP.md](https://github.com/hybridgroup/yzma/blob/main/ROADMAP.md)**

That page gives a table for each area. Each row names a `llama.cpp` function and has two columns, one for the yzma wrapper status and one for the same function's status in a browser.

## The areas

Backend, Model, Vocab, Context, Backend Sampling, Speculative Decoding, Memory, Batch, Sampling, Logging, Performance, Chat, State, LoRA, and mtmd.

## New in yzma 1.29.0

- `llama.Version` returns the version of the loaded `llama.cpp`.
- `llama.GetCausalAttn` reports if a context uses causal attention.
- The extended batch API. `BatchExtInit`, `BatchExtAddToken`, `BatchExtAddEmbd`, `BatchExtSetPos` and the other `BatchExt` calls build a batch, and `llama.Process` runs it. `BatchExtSetPos` takes up to four positions for M-RoPE models.
- `SplitModeTensor` splits each tensor across the GPUs.

## Speculative decoding

The [`exp/speculative`](https://pkg.go.dev/github.com/hybridgroup/yzma/exp/speculative) package has the four NextN hidden state functions that MTP speculative decoding needs. They come from `src/llama-ext.h`, a staging header of `llama.cpp`, so they can change or go away with an update. On Windows, `speculative.Available` can report false, because the header gives C++ names only.

## What has no wrapper

These `llama.cpp` functions have no wrapper yet.

- `llama_adapter_lora_init_from_file_ptr`
- `llama_model_init_from_user`
- `llama_model_load_from_file_ptr`
- `llama_opt_epoch`
- `llama_opt_init`
- `llama_opt_param_filter_all`
- `llama_sampler_copy`
- `llama_sampler_init`

These mtmd functions have no wrapper yet.

- `mtmd_bitmap_init_lazy`
- `mtmd_get_cap_from_file`
- `mtmd_helper_video_read_next`

## WebAssembly

The browser shim uses ABI 10. 170 functions reach WebAssembly. 163 of them are complete and 7 are partial. All of them are among the 272 that have a wrapper on a host. The extended batch API is not in the browser yet.

The browser package doesn't support audio, video, LoRA adapters, saving state to a file, or quantization. It saves context state in memory. See [WebAssembly](/docs/concepts/webassembly/).

## How the bindings stay correct

`yzma-checker` compares the FFI parameter types, the return types, and the constants of yzma against the `llama.cpp` headers of the build that yzma installs. It checks 296 bindings, 181 constants, 4 callbacks, and 5 function pointer members.

The tests also run automatically when there is a new release of `llama.cpp`.
