---
title: "Raspberry Pi"
linkTitle: "Raspberry Pi"
type: "docs"
weight: 50
description: >
  How to install the llama.cpp libraries on a Raspberry Pi.
---

<img src="/images/raspberry-pi-os-logo.png" alt="Raspberry Pi logo" class="platform-logo">

yzma runs on a Raspberry Pi 4 and on a Raspberry Pi 5. You need the 64 bit version of the Raspberry Pi OS.

The Raspberry Pi OS uses its own library versions, so you must name the operating system with the `--os` flag.

{{< tabpane text=true >}}
{{% tab header="Raspberry Pi OS (64-bit)" %}}
Use this command for the latest version of the Raspberry Pi OS:

```shell
yzma install --lib /path/to/lib --processor cpu --os trixie
```
{{% /tab %}}
{{% tab header="Raspberry Pi OS Legacy (64-bit)" %}}
Use this command for an older version of the Raspberry Pi OS:

```shell
yzma install --lib /path/to/lib --processor cpu --os bookworm
```
{{% /tab %}}
{{< /tabpane >}}

The `yzma install` command prints instructions for your system when it finishes. Follow them to complete the installation.

Then set the `YZMA_LIB` environment variable:

```shell
export YZMA_LIB=/path/to/lib
```

A Raspberry Pi has a small amount of memory. Use a small model, such as `SmolLM2-135M` or `gemma-3-1b-it`. See [Models](/docs/guides/models/).

## Next steps

Go to [Download models](/getting-started/download-models/).
