---
title: "Arduino UNO Q"
linkTitle: "Arduino UNO Q"
type: "docs"
weight: 70
description: >
  How to install the llama.cpp libraries on an Arduino UNO Q.
---

<img src="/images/arduino-logo.png" alt="Arduino logo" class="platform-logo">

yzma runs on the [Arduino UNO Q board](https://docs.arduino.cc/hardware/uno-q/). The board runs a Debian based Linux, so the installation uses the `trixie` operating system name.

```shell
yzma install --lib /path/to/lib --processor cpu --os trixie
```

Then set the `YZMA_LIB` environment variable:

```shell
export YZMA_LIB=/path/to/lib
```

The board has a small amount of memory. Use a small model. See [Models](/docs/guides/models/).

## Next steps

Go to [Download models](/getting-started/download-models/).
