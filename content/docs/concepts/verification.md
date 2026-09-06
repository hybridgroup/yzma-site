---
title: "Verification"
linkTitle: "Verification"
type: "docs"
weight: 60
description: >
  How yzma checks the files that it downloads.
---

`yzma install` downloads shared libraries and then runs them in your process. Thus yzma checks each file before it writes anything.

## Digests

`Install` reads the SHA-256 of each asset and compares it with the expected value. The expected values come from the manifest that `llama-cpp-builder` publishes for each release tag.

The manifest is an asset of the release, and there is a copy beside the version files:

```
https://github.com/hybridgroup/llama-cpp-builder/releases/download/b10783/b10783.json
https://hybridgroup.github.io/llama-cpp-builder/digests/b10783.json
```

Both hold the same bytes. yzma reads the release asset first. It falls back to the copy.

## Policies

A policy says what to do with an asset that has no digest.

| Policy | What it does |
| --- | --- |
| `VerifyIfAvailable` | Checks a digest when there is one. Accepts an asset with none. This is the default. |
| `VerifyRequired` | Fails when an asset has no digest. |
| `VerifyOff` | Does no check. |

Set the policy with the `--verify` flag or with the `YZMA_VERIFY` environment variable. The values are `available`, `require`, and `off`.

```shell
yzma install --lib /path/to/lib --verify require
```

The `llama.cpp` release page publishes no digests, so an install from there gives `ErrNoFileDigests`. The builds from `llama-cpp-builder` have them.

## Pinning

A version accepts a digest after it:

```
VERSION@sha256:DIGEST
```

The digest is the digest of the manifest of that release. It gives you a value from outside the release host to check the manifest against.

```shell
yzma install --lib /path/to/lib --version b10783@sha256:abc123...
```

Nothing in a pinned setup makes an unpinned version stop working.

## The install record

`Install` writes two files beside the libraries.

- `yzma-install.json` says what the install put there.
- `yzma-manifest.json` keeps the digests of the release.

`VerifyInstall` reads these two files, so a later check needs no network.

## Check an installation later

```shell
yzma verify --lib /path/to/lib
```

The check reads the files that are in place and compares them with the record.

A file that no asset of this install holds is reported as `FileUnexpected`. It does not make the check fail, because one directory can hold more than one install. Add the `--strict` flag to make it fail.

An installation that an earlier release of yzma made has no manifest. The first check then fetches one and keeps it. No check after that needs a network.

## Next steps

See [Verify an installation](/docs/guides/verifying/) for the complete steps and the Go code.
