---
title: "Cross compiling"
linkTitle: "Cross compiling"
type: "docs"
weight: 100
description: >
  Build for another operating system or another processor.
---

yzma uses no CGo, so cross compilation is the normal Go workflow. Set `GOOS` and `GOARCH`, and build.

```shell
GOOS=linux GOARCH=arm64 go build -o myapp-arm64 .
```

You need no C compiler and no cross toolchain.

## Why this works

A CGo program must compile C code for the target, so it needs a cross toolchain for each target. yzma calls `llama.cpp` through purego and libffi. Nothing about `llama.cpp` is part of your binary, so the Go compiler alone is sufficient.

See [Architecture](/docs/concepts/architecture/).

## The libraries are still per platform

Your Go binary is not enough. The machine that runs it also needs the `llama.cpp` shared libraries for its own platform.

You have two choices.

**Let the application install them.** The program calls `download.Install` the first time it runs. See [Install from your program](/docs/guides/programmatic-install/).

**Ship them with the application.** Put the library files beside the binary and give the path to `llama.Load`.

```go
exe, err := os.Executable()
if err != nil {
	return err
}

llama.Load(filepath.Join(filepath.Dir(exe), "lib"))
```

Download the libraries for each target at build time:

```shell
yzma install --lib ./dist/linux-arm64/lib --os linux
yzma install --lib ./dist/darwin-arm64/lib --os darwin --processor metal
yzma install --lib ./dist/windows-amd64/lib --os windows
```

## The targets

| GOOS | GOARCH | Notes |
| --- | --- | --- |
| `linux` | `amd64` | CPU, CUDA, Vulkan, HIP, ROCm, SYCL. |
| `linux` | `arm64` | CPU, CUDA, Vulkan. Also the Raspberry Pi and the Jetson Orin. |
| `darwin` | `arm64` | Metal. |
| `windows` | `amd64` | CPU, CUDA, Vulkan, HIP, SYCL, OpenCL. |
| `js` | `wasm` | The browser. Use TinyGo. |

## Raspberry Pi and Arduino UNO Q

These boards run a Debian based Linux on arm64. The Go build is the normal arm64 build. The libraries need the `--os` flag, because these systems use their own library versions.

```shell
GOOS=linux GOARCH=arm64 go build -o myapp .
yzma install --lib ./lib --processor cpu --os trixie
```

Use `--os bookworm` for an older Raspberry Pi OS.

## A browser

A browser build uses TinyGo:

```shell
tinygo build -target wasm -o app.wasm ./examples/wasm/chat
```

The standard Go toolchain also works. The binary is larger.

```shell
GOOS=js GOARCH=wasm go build -o app.wasm ./examples/wasm/chat
```

See [Build for a browser](/docs/guides/browser/).

## Test on the target

A cross compiled binary builds, but that does not prove that it runs. The `llama.cpp` libraries and the drivers on the target machine decide that. Run `yzma system` on the target to see the devices that `llama.cpp` found.
