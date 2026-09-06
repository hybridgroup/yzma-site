---
title: "Verify an installation"
linkTitle: "Verifying"
type: "docs"
weight: 80
description: >
  Check that the llama.cpp libraries are the files that the release published.
---

`yzma install` downloads shared libraries and your program then runs them. Thus yzma checks each file.

See [Verification](/docs/concepts/verification/) for how the checks work. This page shows the commands and the Go code.

## Check an installation

```shell
yzma verify --lib /path/to/lib
```

| Flag | What it does |
| --- | --- |
| `--lib`, `-l` | The directory with the libraries. Also reads `YZMA_LIB`. |
| `--version`, `-v` | The `llama.cpp` version that must be there. |
| `--strict` | Also fails when the directory holds a file that this install did not put there. |
| `--json` | Writes the report as JSON. |

The check reads the manifest that the install kept, so it needs no network.

## Set the policy at install time

```shell
yzma install --lib /path/to/lib --verify require
```

| Value | What it does |
| --- | --- |
| `available` | Checks a digest when there is one. Accepts an asset with none. This is the default. |
| `require` | Fails when an asset has no digest. |
| `off` | Does no check. |

The `YZMA_VERIFY` environment variable sets the same thing.

Use `require` in a build that must be repeatable. The builds from `llama-cpp-builder` have digests. The `llama.cpp` release page publishes none, so an install from there gives `ErrNoFileDigests`.

## Pin the digest

Put the digest of the manifest after the version:

```shell
yzma install --lib /path/to/lib --version b10783@sha256:abc123...
```

This gives you a value from outside the release host to check the manifest against. Use it when you must know that the files never change.

Nothing in a pinned setup makes an unpinned version stop working. Thus an application can install a `llama.cpp` release that is newer than the one this yzma release pins.

## Check from Go code

```go
report, err := download.VerifyInstall(context.Background(), libPath, "")
if err != nil {
	return err
}

if !report.OK() {
	return fmt.Errorf("%d changed, %d missing", report.Changed, report.Missing)
}
```

An empty tag takes the release from the record. Give a tag to name the release that must be there. The record sits beside the libraries, so anything that can change the libraries can change the record. A tag makes the check resolve the assets of that release itself.

## Set the policy from Go code

```go
err := download.Install(ctx, target, libPath, download.ProgressTracker, nil,
	download.WithVerify(download.VerifyRequired))
```

`ParseVerifyPolicy` turns a string such as `"require"` into a policy.

## What the report says

| State | What it means |
| --- | --- |
| `FileOK` | The file matches the digest. |
| `FileChanged` | The file is there but the digest does not match. |
| `FileMissing` | The file is not there. |
| `FileUnexpected` | The directory holds a file that no asset of this install holds. |

`FileUnexpected` does not make `OK` false, because one directory can hold more than one install. Use `--strict` to make it fail. The record and the manifest belong to the install, so neither is counted.

## An older installation

An installation that an earlier release of yzma made has no manifest. The first check then fetches one and keeps it. That first check needs a network. No check after that does.

## Check the bindings

`yzma-checker` is a separate tool. It compares the FFI types and the constants in yzma against the `llama.cpp` headers for the build that yzma installs. It checks 265 bindings, 170 constants, 4 callbacks, and 5 function pointer members.

```shell
make check-ffi
```

This is a tool for the people who build yzma. It is not part of a normal installation.
