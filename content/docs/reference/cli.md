---
title: "Command line"
linkTitle: "Command line"
type: "docs"
weight: 10
description: >
  Every yzma command and its flags.
---

## Install the command

```shell
go install github.com/hybridgroup/yzma@latest
```

## The commands

```
NAME:
   yzma - YZMA command line tool

USAGE:
   yzma [global options] command [command options]

COMMANDS:
   install  Install llama.cpp libraries used by yzma
   verify   Check the installed llama.cpp libraries against their published digests
   system   Show llama.cpp system information
   llama    Show most recent llama.cpp version
   model    Manage models
   version  Show yzma version
   info     Show yzma version
   help, h  Shows a list of commands or help for one command
```

## yzma install

Downloads the prebuilt `llama.cpp` libraries for this machine.

| Flag | Default | What it does |
| --- | --- | --- |
| `--version`, `-v` | The version that this yzma release uses | The `llama.cpp` version to install. Accepts `VERSION@sha256:DIGEST` to pin the digests. |
| `--lib`, `-l` | `$YZMA_LIB` | The directory for the library files. |
| `--processor`, `-p` | `cpu` | The processor to use. The values are `cpu`, `cuda`, `metal`, and `vulkan`. |
| `--os` | This machine | The target operating system. Use it for `trixie`, `bookworm`, and `wasm`. |
| `--upgrade`, `-u` | false | Replaces an installation that is already there. |
| `--quiet`, `-q` | false | Prints nothing. |
| `--verify` | `available` | How to check each download. The values are `available`, `require`, and `off`. Also reads `$YZMA_VERIFY`. |

Examples:

```shell
# Install with the default settings. This uses the YZMA_LIB variable.
yzma install

# Install to a path that you name
yzma install --lib /path/to/lib

# Install a version with CUDA
yzma install --lib /path/to/lib --version b1234 --processor cuda

# Replace an installation
yzma install --lib /path/to/lib --upgrade

# The same with the short flags
yzma install -l /path/to/lib -v b1234 -p cuda -u

# Install a version and pin the digests that it must have
yzma install --lib /path/to/lib --version b1234@sha256:<digest>
```

A version with no digest works the same as before. `--version b1234` and a bare `yzma install` need nothing new.

### Where a pin comes from

The digest to pin is the SHA-256 of the digest manifest of the release. `llama-cpp-builder` publishes it with the release. The version file carries the complete pin for the newest build:

```console
$ curl -s https://hybridgroup.github.io/llama-cpp-builder/version.json
{"tag_name":"b10816","manifest_sha256":"<digest>","pin":"b10816@sha256:<digest>"}

$ yzma install --lib /path/to/lib --version b10816@sha256:<digest>
```

The digest of a platform archive is not this value. Those digests are in the manifest, one for each asset.

## yzma verify

Checks the files that are in place against the digests that the publisher recorded.

| Flag | Default | What it does |
| --- | --- | --- |
| `--lib`, `-l` | `$YZMA_LIB` | The directory with the library files. |
| `--version`, `-v` | The installed one | The `llama.cpp` version that must be there. Accepts `VERSION@sha256:DIGEST`. |
| `--strict` | false | Also fails when the directory holds a file that this install did not put there. |
| `--json` | false | Writes the report as JSON. |

A good result:

```console
$ yzma verify --lib /path/to/lib
llama.cpp b10783 in /path/to/lib
68 verified, 0 changed, 0 missing, 0 not part of this install
ok.
```

A file that changed or that is not there makes the command exit with status 1:

```console
$ yzma verify --lib /path/to/lib
llama.cpp b10783 in /path/to/lib
  changed    libllama.so.0.3.0
  missing    libggml-base.so.0.22.0
66 verified, 1 changed, 1 missing, 0 not part of this install
```

Notes.

- `yzma install` writes `yzma-install.json` beside the libraries. `yzma verify` needs it, so you must install again when an older yzma made the installation.
- `yzma install` also writes `yzma-manifest.json`, which holds the digests. Thus `yzma verify` needs no network. An installation with no manifest makes the command fetch one and keep it, so only the first check needs a network.
- The record sits beside the libraries, so anything that can change the libraries can change the record. Give `--version` to name the release that must be there.
- One directory can hold more than one install, so a file that is not part of this one is reported but does not fail the check. Add `--strict` to fail on those.
- Only the assets that `llama-cpp-builder` builds carry file digests. An install from the `llama.cpp` release page has an archive digest but no file digests, and `yzma verify` says so.
- A pin makes the check mandatory, so it does not go with `--verify off`.

## yzma model

Manages models.

### yzma model get

Downloads a model from a URL.

| Flag | What it does |
| --- | --- |
| `--url`, `-u` | The URL of the model. This flag is necessary. |
| `--output`, `-o` | Where to put the file. The default is the models directory. |
| `--yes`, `-y` | Answers yes to every question. |
| `--show-progress` | Shows the progress of the download. |

```shell
yzma model get -u https://huggingface.co/ggml-org/gemma-3-1b-it-GGUF/resolve/main/gemma-3-1b-it-Q4_K_M.gguf
```

### yzma model info

Shows the information in a model file.

| Flag | What it does |
| --- | --- |
| `--model`, `-m` | The path to the model file. This flag is necessary. |
| `--lib`, `-l` | The directory with the `llama.cpp` libraries. |

## yzma system

Shows the system information of `llama.cpp`. It lists the devices that `llama.cpp` found.

```shell
yzma system
```

## yzma llama

Shows the most recent `llama.cpp` version.

```shell
yzma llama
```

## yzma version

Shows the yzma version. `yzma info` gives the same result.

```shell
yzma version
```

## yzma-checker

`yzma-checker` is a separate tool for the people who build yzma. It is not a subcommand. It compares the FFI parameter types, the return types, and the constants of yzma against the `llama.cpp` headers.

It is a nested Go module, so `go build ./...` and `go test ./...` at the root of the repository do not include it.

```shell
make check-ffi
```
