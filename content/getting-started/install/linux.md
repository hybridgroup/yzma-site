---
title: "Linux"
linkTitle: "Linux"
type: "docs"
weight: 30
description: >
  How to install the llama.cpp libraries on Linux.
---

![Linux logo](/images/linux-logo.webp)

Linux runs on amd64 and on arm64. Choose the tab for the processor that you want to use.

{{< tabpane text=true >}}
{{% tab header="CPU" %}}
Decide where you want to put the library files, then run this command:

```shell
yzma install --lib /path/to/lib
```
{{% /tab %}}
{{% tab header="CUDA" %}}
To use an NVIDIA GPU, first install the CUDA drivers. See the [CUDA installation guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/).

Then run this command:

```shell
yzma install --lib /path/to/lib --processor cuda
```
{{% /tab %}}
{{% tab header="ROCm" %}}
To use an AMD GPU, first install the ROCm 7.2 drivers. See [Install ROCm](#install-rocm) below.

Then run this command:

```shell
yzma install --lib /path/to/lib --processor rocm
```

`yzma` also finds ROCm without help. If ROCm is already installed, this command is sufficient:

```shell
yzma install --lib /path/to/lib
```
{{% /tab %}}
{{% tab header="Vulkan" %}}
To use Vulkan, first install the Vulkan drivers. For example:

```shell
sudo apt install -y mesa-vulkan-drivers vulkan-tools
```

Then run this command:

```shell
yzma install --lib /path/to/lib --processor vulkan
```
{{% /tab %}}
{{< /tabpane >}}

The `yzma install` command prints instructions for your system when it finishes. Follow them to complete the installation.

Then set the `YZMA_LIB` environment variable:

```shell
export YZMA_LIB=/path/to/lib
```

## Install ROCm

You need these things before you start.

- An AMD GPU in the AMD [supported GPU table](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html), such as an AMD Instinct or a supported Radeon GPU.
- A Linux distribution that ROCm 7.2 supports. Ubuntu 24.04 and Ubuntu 22.04 are the most common.
- A compatible AMDGPU kernel driver. See the AMD [driver installation instructions](https://instinct.docs.amd.com/projects/amdgpu-docs/en/latest/install/detailed-install/package-manager/package-manager-ubuntu.html).

{{< tabpane text=true >}}
{{% tab header="Ubuntu 24.04" %}}
```shell
wget https://repo.radeon.com/amdgpu-install/7.2/ubuntu/noble/amdgpu-install_7.2.70200-1_all.deb
sudo apt install ./amdgpu-install_7.2.70200-1_all.deb
sudo apt update
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME
sudo apt install rocm
```
{{% /tab %}}
{{% tab header="Ubuntu 22.04" %}}
```shell
wget https://repo.radeon.com/amdgpu-install/7.2/ubuntu/jammy/amdgpu-install_7.2.70200-1_all.deb
sudo apt install ./amdgpu-install_7.2.70200-1_all.deb
sudo apt update
sudo apt install python3-setuptools python3-wheel
sudo usermod -a -G render,video $LOGNAME
sudo apt install rocm
```
{{% /tab %}}
{{< /tabpane >}}

Reboot the machine after you install ROCm. The `render` group and the `video` group need at least a new login.

Check the installation:

```shell
rocminfo
```

For other Linux distributions, see the [ROCm installation guide](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/).

## Next steps

Go to [Download models](/getting-started/download-models/).
