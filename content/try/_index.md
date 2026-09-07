---
title: "Try yzma in your browser"
linkTitle: "Try it"
description: >
  A model that runs in your browser. No install, no signup, no server.
menu:
  main:
    weight: 6
---

{{< blocks/section color="white" type="container" >}}

<h1 class="mb-3">Try yzma in your browser</h1>

<p class="lead">The model runs on your machine, in your browser. No install, no signup, and no server.</p>

<p>Push <strong>Load</strong> to start. The smallest model in the list is 220 MB, so the first download takes a moment, and then the browser keeps it for the next time. The line at the top right names the backend.</p>

<iframe class="yzma-demo" src="/try/app/" title="yzma chat demo"></iframe>

<p class="mt-4">The demo is a Go program that <a href="https://tinygo.org">TinyGo</a> compiles to WebAssembly. It uses the <a href="https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llamawasm"><code>pkg/llamawasm</code></a> package, which has the same calls as the package for a host.</p>

<ul>
	<li><a href="https://github.com/hybridgroup/yzma-wasm-example">The code of the demo</a></li>
	<li><a href="/docs/concepts/webassembly/">WebAssembly</a> shows how the parts fit together.</li>
	<li><a href="/docs/tutorials/browser/">Run yzma in a browser</a> builds such a page yourself.</li>
</ul>

{{< /blocks/section >}}
