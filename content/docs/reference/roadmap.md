---
title: "Roadmap"
linkTitle: "Roadmap"
type: "docs"
weight: 60
description: >
  How much of llama.cpp yzma covers.
---

yzma covers more than 96 percent of the `llama.cpp` functionality.

The complete list changes with each release, so it stays in the repository:

**[ROADMAP.md](https://github.com/hybridgroup/yzma/blob/main/ROADMAP.md)**

That page gives a table for each area. Each row names a `llama.cpp` function and gives two columns. One column is the state of the wrapper in yzma. The other column is the state of the same function in a browser.

## The areas

Backend, Model, Vocab, Context, Backend Sampling, Memory, Batch, Sampling, Logging, Performance, Chat, State, LoRA, and mtmd.

## What has no wrapper

These `llama.cpp` functions have no wrapper yet.

- `llama_model_init_from_user`
- `llama_model_load_from_file_ptr`
- `llama_opt_epoch`
- `llama_opt_init`
- `llama_opt_param_filter_all`
- `llama_sampler_init`

These mtmd functions have no wrapper yet.

- `mtmd_bitmap_init_lazy`
- `mtmd_get_cap_from_file`
- `mtmd_helper_video_read_next`
- `mtmd_image_tokens_get_decoder_pos`

## WebAssembly

The browser shim uses ABI 6. 107 functions reach WebAssembly. 100 of them are complete and 7 are partial. All of them are among the 253 that have a wrapper on a host.

The browser package has no audio, no video, no LoRA adapters, no saved state, and no quantization. See [WebAssembly](/docs/concepts/webassembly/).

## How the bindings stay correct

`yzma-checker` compares the FFI parameter types, the return types, and the constants of yzma against the `llama.cpp` headers of the build that yzma installs. It checks 265 bindings, 170 constants, 4 callbacks, and 5 function pointer members.

The tests also run automatically when there is a new release of `llama.cpp`.
