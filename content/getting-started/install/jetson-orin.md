---
title: "NVIDIA Jetson Orin"
linkTitle: "Jetson Orin"
type: "docs"
weight: 60
description: >
  How to install the llama.cpp libraries on an NVIDIA Jetson Orin.
---

<img src="/images/NVIDIA-logo.png" alt="NVIDIA logo" class="platform-logo">

yzma runs on the [NVIDIA Jetson Orin](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/nano-super-developer-kit/). Install the latest version of the Jetpack software for your device before you start. Jetpack gives you the GPU drivers.

{{< tabpane text=true >}}
{{% tab header="CUDA" %}}
Decide where you want to put the library files, then run this command:

```shell
yzma install --lib /path/to/lib --processor cuda
```

The command reads the CUDA version of the Jetpack and takes the CUDA 12 build or the CUDA 13 build. If it cannot read the version, it takes CUDA 12. To name one, use `--processor cuda-12` or `--processor cuda-13`.
{{% /tab %}}
{{% tab header="Vulkan" %}}
Decide where you want to put the library files, then run this command:

```shell
yzma install --lib /path/to/lib --processor vulkan
```

Jetpack 7 has the correct GLIBC for Vulkan. If you use Jetpack 6 or earlier, upgrade the shared libraries before you install:

```shell
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install --only-upgrade libstdc++6
```
{{% /tab %}}
{{< /tabpane >}}

The `yzma install` command prints instructions for your system when it finishes. Follow them to complete the installation.

Then set the `YZMA_LIB` environment variable:

```shell
export YZMA_LIB=/path/to/lib
```

## Next steps

Go to [Download models](/getting-started/download-models/).
