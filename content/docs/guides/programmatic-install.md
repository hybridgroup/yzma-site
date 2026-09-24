---
title: "Install from your program"
linkTitle: "Programmatic install"
type: "docs"
weight: 60
description: >
  Download the llama.cpp libraries with Go code.
---

Your application can install the `llama.cpp` libraries itself. Then the person who uses it does not have to run the `yzma` command.

`pkg/download` does this work.

## Install

```go
import (
	"context"
	"runtime"

	"github.com/hybridgroup/yzma/pkg/download"
)

target := download.Target{
	Arch:      download.MustParseArch(runtime.GOARCH),
	OS:        download.MustParseOS(runtime.GOOS),
	Processor: download.CUDA,
	Version:   "latest",
}

err := download.Install(context.Background(), target, libPath, download.ProgressTracker, nil)
```

The last argument is the resolver. A nil value uses the built in table. See [Custom resolvers](/docs/guides/resolvers/).

[See the example code](https://github.com/hybridgroup/yzma/tree/main/examples/installer).

## The target

| Field | What it holds |
| --- | --- |
| `Arch` | `download.AMD64` or `download.ARM64`. |
| `OS` | `download.Linux`, `download.Darwin`, `download.Windows`, `download.Bookworm`, `download.Trixie`, or `download.Wasm`. |
| `Processor` | `download.CPU`, `download.CUDA`, `download.CUDA12`, `download.CUDA13`, `download.Metal`, `download.OpenVINO`, `download.ROCm`, `download.Vulkan`, or `download.WebGPU`. |
| `Version` | The release tag of `llama.cpp`, or `"latest"`, or an empty string. |
| `CUDAVersion` | The CUDA version of the machine, such as `"13.0"`. It selects the Linux build for `download.CUDA`. Empty takes CUDA 12 on arm64 and CUDA 13 on amd64. |

## Find the processor

`yzma` can find CUDA and ROCm on the machine.

```go
if ok, version := download.HasCUDA(); ok {
	target.Processor = download.CUDA
	target.CUDAVersion = version
} else if ok, _ := download.HasROCm(); ok {
	target.Processor = download.ROCm
} else {
	target.Processor = download.CPU
}
```

Give the CUDA version to the target, because on Linux it selects the CUDA 12 build or the CUDA 13 build. `download.CUDA12` and `download.CUDA13` name a build and ignore the version. The functions that take strings, such as `download.Get`, take the version with `download.WithCUDAVersion`.

## The version

- An empty string takes `download.DefaultVersion`. That is the `llama.cpp` release that this yzma release was tested with. A development build of yzma leaves that empty, so an empty string then gets the most recent nightly build.
- `"latest"` always gets the most recent nightly build.
- A tag such as `b10783` gets that release.

`Install` resolves the version to a release tag before it calls the resolver, so the resolver always sees a concrete version.

`LlamaLatestVersion` and `LlamaNightlyTag` read the current tags.

## Do not install twice

```go
if download.AlreadyInstalled(libPath, target) {
	return nil
}
```

## Show the progress

`download.ProgressTracker` prints the progress to the terminal. `DefaultProgressTracker` makes a new one. Pass nil for no output. Write your own tracker to show the progress in your own user interface.

## Download a model

```go
err := download.GetModel(modelURL, download.DefaultModelsDir())
```

`GetModelWithProgress` and `GetModelWithContext` give you a tracker and a context.

## Check the files

`Install` checks the SHA-256 of each asset before it writes anything. See [Verify an installation](/docs/guides/verifying/).

## Ship the libraries with your application

You do not have to download at all. Put the library files beside your program and give the path to `llama.Load`:

```go
llama.Load(filepath.Join(exeDir, "lib"))
```

This gives you a program that works with no network. The cost is a larger download for the application, and you must build one package for each platform.
