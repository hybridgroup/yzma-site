---
title: "Manual installation"
linkTitle: "Manual"
type: "docs"
weight: 90
description: >
  How to install the llama.cpp libraries without the yzma installer.
---

You do not have to use the `yzma install` command. You can download and extract the library files yourself.

## Where to get the files

Most of the prebuilt `llama.cpp` binaries are here:

https://github.com/ggml-org/llama.cpp/releases

We build the Ubuntu arm64 CUDA and Vulkan binaries, and the WebAssembly builds. They are here:

https://github.com/hybridgroup/llama-cpp-builder/releases

## Extract the files

Extract the library files into a directory on your machine. The file extension depends on the operating system.

{{< tabpane text=true >}}
{{% tab header="Linux" %}}
The files have the `.so` extension. For example, `libllama.so` and `libmtmd.so`.

```shell
export YZMA_LIB=/path/to/lib
```
{{% /tab %}}
{{% tab header="macOS" %}}
The files have the `.dylib` extension. For example, `libllama.dylib` and `libmtmd.dylib`. You do not need the other files in the download.

```shell
export YZMA_LIB=/path/to/lib
```
{{% /tab %}}
{{% tab header="Windows" %}}
The files have the `.dll` extension. For example, `llama.dll` and `mtmd.dll`.

For CUDA on Windows, also download the `cudart` files from the same location.

```shell
set YZMA_LIB=C:\yzma\lib
```
{{% /tab %}}
{{< /tabpane >}}

You must set the `YZMA_LIB` environment variable to the directory that holds the library files. A program can also give the path to `llama.Load` instead.

## Digest checks

A manual installation has no install record, so `yzma verify` cannot check it. Use the `yzma install` command if you want the digest checks. See [Verify an installation](/docs/guides/verifying/).

## Next steps

Go to [Download models](/getting-started/download-models/).
