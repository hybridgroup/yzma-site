---
title: "Quick install guide"
linkTitle: "Quick install"
type: "docs"
weight: 10
description: >
  How to install yzma on your machine.
---

The installation has two steps.

1. Install the `yzma` command line tool.
2. Use the `yzma` command to install the `llama.cpp` libraries for your platform.

## Install the yzma command

You need [Go](https://go.dev/dl/) 1.26 or later. You do not need a C compiler.

```shell
go install github.com/hybridgroup/yzma@latest
```

Check that the command works:

```shell
yzma version
```

## Install the llama.cpp libraries

The `yzma` command downloads the prebuilt `llama.cpp` libraries for your machine. Follow the page for your platform.

- [macOS](/getting-started/install/macos/)
- [Linux](/getting-started/install/linux/)
- [Windows](/getting-started/install/windows/)
- [Raspberry Pi](/getting-started/install/raspberry-pi/)
- [NVIDIA Jetson Orin](/getting-started/install/jetson-orin/)
- [Arduino UNO Q](/getting-started/install/arduino-uno-q/)
- [Browser](/getting-started/install/browser/)
- [Manual installation](/getting-started/install/manual/)

## Set the YZMA_LIB variable

`yzma` must know where the libraries are. Set the `YZMA_LIB` environment variable to that directory.

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

Add this line to your shell profile to keep the setting.

## Next steps

Download a model, then run your first program. See [Download models](/getting-started/download-models/).
