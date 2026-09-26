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

<p>Click <strong>Load</strong> to start. The smallest model in the list is 220 MB, so the first download takes a moment, and then the browser keeps it for the next time. The line at the top right shows the backend.</p>

<iframe class="yzma-demo" src="/try/app/?embed=1" title="yzma chat demo"></iframe>

<script>
// The frame is as tall as its content, so the page scrolls and the
// frame does not. The demo is on this origin, so the page can measure it.
(function () {
	var frame = document.querySelector(".yzma-demo");
	if (!frame || !window.ResizeObserver) return;

	var watcher = null;
	var last = 0;

	function fit() {
		var doc = frame.contentDocument;
		if (!doc || !doc.body) return;
		// scrollHeight is never less than the frame, so measure the box.
		var height = Math.ceil(doc.documentElement.getBoundingClientRect().height);
		if (!height || height === last) return;
		last = height;
		// The border is part of the frame height, so add it.
		frame.style.height = (height + frame.offsetHeight - frame.clientHeight) + "px";
	}

	frame.addEventListener("load", function () {
		var doc = frame.contentDocument;
		if (!doc) return;
		if (watcher) watcher.disconnect();
		last = 0;
		watcher = new ResizeObserver(fit);
		watcher.observe(doc.documentElement);
		watcher.observe(doc.body);
		fit();
	});
})();
</script>

<p class="mt-4">The demo is a Go program that <a href="https://tinygo.org">TinyGo</a> compiles to WebAssembly. It uses the <a href="https://pkg.go.dev/github.com/hybridgroup/yzma/pkg/llamawasm"><code>pkg/llamawasm</code></a> package, which has the same calls as the native package.</p>

<ul>
	<li><a href="https://github.com/hybridgroup/yzma-wasm-example">The demo code</a></li>
	<li><a href="/docs/concepts/webassembly/">WebAssembly</a> shows how the parts fit together.</li>
	<li><a href="/docs/tutorials/browser/">Run yzma in a browser</a> shows how to build a page like this yourself.</li>
</ul>

{{< /blocks/section >}}
