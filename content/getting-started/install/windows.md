---
title: "Windows"
linkTitle: "Windows"
type: "docs"
weight: 40
description: >
  How to install the llama.cpp libraries on Windows.
---

<img src="/images/windows-10-logo.png" alt="Windows logo" class="platform-logo">

Choose the tab for the processor that you want to use.

{{< tabpane text=true >}}
{{% tab header="CPU" %}}
Decide where you want to put the library files, then run this command:

```shell
yzma install --lib C:\path\to\lib
```
{{% /tab %}}
{{% tab header="CUDA" %}}
To use an NVIDIA GPU, first install the CUDA drivers. See the [CUDA installation guide](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/).

Then run this command:

```shell
yzma install --lib C:\path\to\lib --processor cuda
```

The installer also downloads the `cudart` files that CUDA on Windows needs.
{{% /tab %}}
{{% tab header="ROCm" %}}
To use an AMD GPU, run this command:

```shell
yzma install --lib C:\path\to\lib --processor rocm
```
{{% /tab %}}
{{% tab header="Vulkan" %}}
To use Vulkan, first install the [Vulkan SDK](https://vulkan.lunarg.com/doc/sdk/latest/windows/getting_started.html).

Then run this command:

```shell
yzma install --lib C:\path\to\lib --processor vulkan
```
{{% /tab %}}
{{< /tabpane >}}

The `yzma install` command prints instructions for your system when it finishes. Follow them to complete the installation.

Then set the `YZMA_LIB` environment variable:

```shell
set YZMA_LIB=C:\path\to\lib
```

## Next steps

Go to [Download models](/getting-started/download-models/).
