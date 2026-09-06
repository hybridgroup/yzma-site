---
title: "llama.cpp versions"
linkTitle: "llama.cpp versions"
type: "docs"
weight: 80
description: >
  Which llama.cpp version goes with which yzma version.
---

Sometimes a change in `llama.cpp` breaks yzma. This page gives the known compatible versions.

For the current list, see [the README](https://github.com/hybridgroup/yzma#required-versions-of-llamacpp).

## Tagged releases

| llama.cpp | yzma |
| --- | --- |
| v0.3.0 | v1.25.0 |
| v0.4.0 | v1.26.0 to v1.26.1 |

A tagged release of yzma installs its own `llama.cpp` release by default. Thus `yzma install` with no `--version` flag gets the version in this table.

Use `-version latest` to get the most recent nightly build instead. A build from the `main` branch always uses the most recent nightly build.

## Nightly builds

| llama.cpp | yzma |
| --- | --- |
| up to b8864 | v1.12.0 |
| b8865 to b9179 | v1.13.0 |
| b9180 to b9459 | v1.14.1 |
| b9460 to b9540 | v1.15.0 |
| b9541 to b9548 | v1.16.0 |
| b9549 to b9561 | v1.16.1 |
| b9562 to b9611 | v1.17.0 |
| b9616 to b9749 | v1.17.1 |
| b9650 to b9978 | v1.18.0 |
| b9979 to b10103 | v1.19.0 |
| b10105 to b10211 | v1.20.0 to v1.21.0 |
| b10212 to b10257 | v1.22.0 |
| b10273 to b10544 | v1.23.0 |
| b10545 to b10779 | v1.24.0 to v1.25.0 |
| b10780 and later | v1.26.0 and later |

## How yzma stays up to date

The tests of yzma run automatically when there is a new release of `llama.cpp`. This finds a breaking change quickly.

`yzma-checker` also compares the FFI types and the constants of yzma against the headers of that release. See [Roadmap](/docs/reference/roadmap/).

## Find the current version

The most recent `llama.cpp` version:

```shell
yzma llama
```

The version that an installation holds:

```shell
yzma verify --lib /path/to/lib
```

The version file that the builder publishes:

```shell
curl -s https://hybridgroup.github.io/llama-cpp-builder/version.json
```

## Update the libraries

`llama.cpp` changes often. You can update the libraries without a new build of your Go program, while `llama.cpp` makes no breaking change.

```shell
yzma install --lib /path/to/lib --upgrade
```

Check the table above first. If your yzma version is not in the row for that build, update yzma as well.
