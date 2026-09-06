---
title: "macOS"
linkTitle: "macOS"
type: "docs"
weight: 20
description: >
  How to install the llama.cpp libraries on macOS.
---

![Apple logo](/images/apple-logo.png)

macOS on Apple silicon uses the Metal GPU. You do not need to install a driver.

Decide where you want to put the library files, then run this command:

```shell
yzma install --lib /path/to/lib
```

The `yzma install` command prints instructions for your system when it finishes. Follow them to complete the installation.

Then set the `YZMA_LIB` environment variable:

```shell
export YZMA_LIB=/path/to/lib
```

## Next steps

Go to [Download models](/getting-started/download-models/).
