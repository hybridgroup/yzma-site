# yzma-site

The website for [yzma](https://github.com/hybridgroup/yzma), at [yzma.ai](https://yzma.ai).

The site uses [Hugo](https://gohugo.io) with the [Docsy](https://www.docsy.dev) theme.

## What you need

- Hugo **extended** 0.135.0 or later. The extended build is necessary, because Docsy uses SCSS.
- Go 1.24 or later. Docsy comes in as a Hugo Module, so the build needs Go.
- Node 20 or later, for the PostCSS step.

## Build the site

Install the Node packages one time:

```shell
npm install
```

Then start the local server:

```shell
hugo server
```

The site is then at http://localhost:1313.

To make the files for a release:

```shell
hugo --gc --minify
```

The result goes in the `public` directory.

## Where things are

| Path | What it holds |
| --- | --- |
| `content/` | The pages of the site. |
| `assets/scss/_variables_project.scss` | The brand colors. |
| `static/images/` | Logos and screenshots. |
| `static/favicons/` | The icons for the browser tab. |
| `hugo.toml` | The configuration of the site. |
| `netlify.toml` | The build settings for Netlify. |

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

Follow [AGENTS.md](./AGENTS.md). Write the pages in ASD-STE100 Simplified Technical English.

## Deployment

Netlify builds the `main` branch and publishes it to yzma.ai.
