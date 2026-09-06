---
title: "Custom resolvers"
linkTitle: "Resolvers"
type: "docs"
weight: 70
description: >
  Install the llama.cpp libraries from your own source.
---

A `Resolver` reports the files to install for a target. `Install` downloads them in the order that the resolver gives.

Write a resolver when you need a build that the built in table does not name. For example:

- An internal mirror or an artifact server.
- A `file://` path on a machine with no network.
- Your own build of `llama.cpp`.
- A CUDA major version that is not the default.

## Write one

```go
resolver := download.ResolverFunc(func(t download.Target) ([]string, error) {
	if t.OS == download.Linux && t.Arch == download.AMD64 && t.Processor == download.CUDA {
		return []string{"https://mirror.example.com/llama/" + t.Version + "-cuda12-x64.tar.gz"}, nil
	}

	// Anything that you do not care about falls through to the built in table.
	return download.DefaultResolver.Resolve(t)
})

err := download.Install(context.Background(), target, libPath, download.ProgressTracker, resolver)
```

[See the example code](https://github.com/hybridgroup/yzma/tree/main/examples/resolver).

## Rules

**Return several URLs when a build needs more than one archive.** They install in the order that you give, so put a dependency before the libraries that need it. A CUDA runtime archive goes before the libraries.

**A resolver must not download anything itself.** Return URLs and let `Install` fetch them. Then a `.tar.gz` file and a `.zip` file unpack the same way as a built in build.

**The version is always concrete.** `Install` resolves `""` and `"latest"` to a release tag before it calls the resolver.

**A tagged release has no binaries on the `llama.cpp` release page.** For a tag such as `v0.3.0`, `Install` also sets `t.UpstreamVersion` to the nightly build tag that holds the files.

**Any URL that [go-getter](https://github.com/hashicorp/go-getter) supports works.** This includes `file://`, S3, and GCS.

## An air gapped machine

Put the archives on a disk and point the resolver at them.

```go
resolver := download.ResolverFunc(func(t download.Target) ([]string, error) {
	return []string{"file:///media/usb/llama-" + t.Version + ".tar.gz"}, nil
})
```

## Digests

A file from your own source has no entry in the manifest that `llama-cpp-builder` publishes. The default policy, `VerifyIfAvailable`, accepts a file with no digest. `VerifyRequired` refuses it.

See [Verify an installation](/docs/guides/verifying/).
