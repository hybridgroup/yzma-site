# yzma-site

The website for [yzma](https://github.com/hybridgroup/yzma), at [yzma.ai](https://yzma.ai).

The site uses [Hugo](https://gohugo.io) with the [Docsy](https://www.docsy.dev) theme.

## What you need

- Hugo **extended** 0.160.1 or later. Netlify uses 0.164.0, which is the version that Docsy tests.
- Go 1.24 or later. Docsy comes in as a Hugo Module, so the build needs Go.
- Node 24 or later. npm installs Dart Sass, Bootstrap, and Font Awesome for Docsy.

## Build the site

Install the Node packages once:

```shell
npm install
```

Then start the local server:

```shell
npm run serve
```

The site is then at http://localhost:1313. Run Hugo through npm, because Hugo finds Dart Sass only in `node_modules/.bin`.

To make the files for a release:

```shell
npm run build -- --gc --minify
```

## Update Docsy

Get the new version, then update the Node packages that Docsy uses:

```shell
hugo mod get github.com/google/docsy/theme@v0.17.0
hugo mod tidy
hugo mod npm pack
npm install
```

`hugo mod npm pack` writes `packages/hugoautogen/package.json`. Commit it with `go.mod`, `go.sum`, `package.json`, and `package-lock.json`.

The result goes in the `public` directory.

## Where things are

| Path | What it holds |
| --- | --- |
| `content/` | The pages of the site. |
| `assets/scss/_variables_project.scss` | The brand colors. |
| `static/images/` | Logos and screenshots. |
| `static/favicon*`, `static/apple-touch-icon*` | The icons for the browser tab. Docsy finds them by name. |
| `hugo.toml` | The configuration of the site. |
| `netlify.toml` | The build settings for Netlify. |
| `scripts/` | The script that gets the browser demo. |

## The browser demo

The page at [yzma.ai/try/](https://yzma.ai/try/) holds a frame with the demo
from [yzma-wasm-example](https://github.com/hybridgroup/yzma-wasm-example). The
demo files are not in this repository. A build gets them from the `demo`
release of that repository:

```shell
./scripts/fetch-demo.sh
```

The files go to `static/try/app`, which git ignores. Netlify runs the script
before Hugo. Set `DEMO_URL` to take the tarball from somewhere else, such as a
local build.

```shell
DEMO_URL=~/Development/yzma-wasm-example/demo.tar.gz ./scripts/fetch-demo.sh
```

`netlify.toml` sends the COOP header and the COEP header for `/try/*`. The demo
needs them to get `SharedArrayBuffer` and the build with more than one thread.

## Write a page

Each page starts with front matter:

```yaml
---
title: "The title of the page"
linkTitle: "The short title for the menu"
type: "docs"
weight: 10
description: >
  One sentence about the page.
---
```

The `weight` sets the order in the menu. Use steps of 10, so you can put a new page between two others.

## Style

Follow [AGENTS.md](./AGENTS.md). Write the pages in simple, direct English.

## Deployment

Netlify builds the `main` branch and publishes it to yzma.ai.
