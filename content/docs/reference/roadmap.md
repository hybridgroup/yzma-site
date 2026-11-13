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

## New in yzma 1.33.0

- The mtmd audio generation helper makes speech from text. `HelperGenAudioInit`, `HelperGenAudioSetInput` and `HelperGenAudioStepGen` make the audio frames, and `HelperGenAudioGetOutput` returns PCM or WAV. `GenAudioVoiceName` and `GenAudioGetVoice` read the preset voices of a model.
- `HelperResamplerInit` and `HelperResamplerProcess` change the sample rate of a stream of audio.
- `ContextParams.MoeCacheCpuShare` sets the share of the MoE cache misses that the CPU computes. It is experimental.
- `exp/speculative` has the device NextN row functions. They keep the NextN rows on the GPU for an MTP draft context. Check `DeviceRowsAvailable` first.
- `decide.Open` loads six more decision types. They are lfm3-d1, lfm3-d1-omni, lfm2-d1-omni, nimble, granite-switch and h2o-lightning.
- The browser gets `ModelDecisionLabel`, a flag that stops a long prompt, audio input, the parts of a multimodal prompt, and embeddings in an extended batch. These need `llama.cpp` v1.0.0, which has ABI 14.
- `ContextParams.DefragThold` and `SetWarmup` are gone, because `llama.cpp` removed them. `SetEmbdStateSrc` is now `SetCtxStateSrc`.
- A library from b12347 or later needs yzma 1.33.0. A library from b12191 or later doesn't work with 1.32.0.

## New in yzma 1.32.0

- `GGMLTypeF8_E4M3` and `FtypeMostlyF8_E4M3` for models with FP8 weights.
- The NextN functions of `exp/speculative` also load on Windows.

## New in yzma 1.31.0

- The mtmd audio stream API takes realtime audio input. `AudioStreamInit`, `AudioStreamPush` and `AudioStreamStep` turn the samples into embedding rows for the decoder. It is experimental. Check `SupportAudioStream` first.
- `mtmd.HelperGetCapabilities` gives all the capabilities of a model and its projector at once.
- `VideoInitParams.NoSoundtrack` reads only the frames of a video.
- `llama.ModelDecisionLabel` reads a decision answer label from the model metadata.
- `pkg/message` reads the LFM2 tool call format.
- A library from b11960 or later needs yzma 1.31.0, because the mtmd video params changed.

## New in yzma 1.30.0

- `ContextParams.MoeCacheSize` sets the size of the device cache for the MoE experts that stay in host memory. It is the same as `--moe-cache-mib` in `llama.cpp`. It is experimental.
- `PerfContextData` has the graph reallocation counters `NReallocsSame` and `NReallocsDiff`. A library before b11567 leaves them at 0.
- The extended batch API works in the browser, apart from the embedding calls. `llamawasm.Process` runs it, so the decision heads of Clef and Decision 2.0 work in a page.

## New in yzma 1.29.0

- `llama.Version` returns the version of the loaded `llama.cpp`.
- `llama.GetCausalAttn` reports if a context uses causal attention.
- The extended batch API. `BatchExtInit`, `BatchExtAddToken`, `BatchExtAddEmbd`, `BatchExtSetPos` and the other `BatchExt` calls build a batch, and `llama.Process` runs it. `BatchExtSetPos` takes up to four positions for M-RoPE models.
- `SplitModeTensor` splits each tensor across the GPUs.

## Speculative decoding

The [`exp/speculative`](https://pkg.go.dev/github.com/hybridgroup/yzma/exp/speculative) package has the nine NextN hidden state functions that MTP speculative decoding needs. `llama.cpp` moved them into `llama.h`, but they are still experimental and can change with an update. The device row functions came later, so check `DeviceRowsAvailable` apart from `Available`.

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

The browser shim uses ABI 14. 217 functions reach WebAssembly. 209 of them are complete and 8 are partial. All of them also have a wrapper on a host. The whole extended batch API is in the browser, also the embedding calls.

The browser package takes audio input, but it doesn't make audio. It doesn't support video, LoRA adapters, saving state to a file, or quantization. It saves context state in memory. See [WebAssembly](/docs/concepts/webassembly/).

## How the bindings stay correct

`yzma-checker` compares the FFI parameter types, the return types, and the constants of yzma against the `llama.cpp` headers of the build that yzma installs. It checks 320 bindings, 191 constants, 4 callbacks, and 5 function pointer members.

The tests also run automatically when there is a new release of `llama.cpp`.
