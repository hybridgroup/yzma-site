---
title: "yzma"
description: >
  yzma lets you write Go applications that use llama.cpp for local inference with full hardware acceleration.
---

{{< blocks/cover title="" image_anchor="top" height="min" color="dark" >}}

<img src="/images/yzma-logo-cover.png" alt="yzma" class="img-fluid mt-0 mt-md-5" style="max-width: 720px; width: 80%;">

<p class="h3 mt-4 pb-4">Local inference in Go using llama.cpp with full hardware acceleration</p>

<div class="mx-auto">
	<a class="btn btn-lg btn-primary mr-3 mb-4" href="{{< relref "/getting-started" >}}">
		Get Started <i class="fas fa-arrow-alt-circle-right ml-2"></i>
	</a>
	<a class="btn btn-lg btn-secondary mr-3 mb-4" href="https://github.com/hybridgroup/yzma">
		See the code <i class="fab fa-github ml-2 "></i>
	</a>
</div>

{{< /blocks/cover >}}

{{% blocks/lead color="secondary" %}}

yzma lets you write Go applications that use [llama.cpp](https://github.com/ggml-org/llama.cpp) for local inference.

Your models run in the same process as your program. No model server is necessary. No C compiler is necessary. Use the hardware acceleration that your machine has.

{{% /blocks/lead %}}

{{< blocks/section color="light" type="row">}}
{{% blocks/feature icon="fa fa-microchip" title="Accelerate" url="docs/concepts/acceleration" %}}
Use CUDA, Metal, Vulkan, ROCm, or WebGPU for maximum performance.
{{% /blocks/feature %}}

{{% blocks/feature icon="fa fa-image" title="See" url="docs/tutorials/vision" %}}
Run Vision Language Models on images, audio, and video.
{{% /blocks/feature %}}

{{% blocks/feature icon="fa fa-globe" title="Run anywhere" url="docs/concepts/webassembly" %}}
Run on Linux, macOS, Windows, or in a browser with WebAssembly.
{{% /blocks/feature %}}
{{< /blocks/section >}}

<div><a id="powered-by" class="td-offset-anchor"></a></div>

{{< blocks/section color="primary" >}}
<div class="text-center">
<h2 class="mb-2">Powered by yzma</h2>
<p class="lead">These projects build on yzma.</p>
</div>

<div class="row text-center mt-4">
	<div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
		<p class="project-logo"><img src="/images/projects/kronk-logo.png" alt="Kronk logo"></p>
		<h3 class="h4"><a href="https://github.com/ardanlabs/kronk">Kronk</a></h3>
		<p class="mb-0">High-performance OpenAI compatible API with SDK and model server.</p>
	</div>
	<div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
		<p class="project-logo"><img src="/images/projects/nornicdb-logo.svg" alt="NornicDB logo"></p>
		<h3 class="h4"><a href="https://github.com/orneryd/NornicDB">NornicDB</a></h3>
		<p class="mb-0">Graph database for AI agents and knowledge systems.</p>
	</div>
	<div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
		<p class="project-logo"><img src="/images/projects/openocta-logo.png" alt="OpenOcta logo"></p>
		<h3 class="h4"><a href="https://github.com/openocta/openocta">OpenOcta</a></h3>
		<p class="mb-0">Desktop IT operations agent for Windows and macOS.</p>
	</div>
	<div class="col-lg-3 col-md-6 mb-4 mb-lg-0">
		<p class="project-logo"><img src="/images/projects/th2053-logo.png" alt="Talking Heads From The Year 2053 logo"></p>
		<h3 class="h4"><a href="https://talkingheads2053.com/">Talking Heads From The Year 2053</a></h3>
		<p class="mb-0">First show whose actors use Physical AI running locally on Arduino UNO Q.</p>
	</div>
</div>

<div class="text-center mt-5">
<p class="mb-0"><a href="/projects/">See more projects that use yzma</a></p>
</div>
{{< /blocks/section >}}

{{% blocks/lead color="secondary" %}}
yzma uses the [purego](https://github.com/ebitengine/purego) and [ffi](https://github.com/JupiterRider/ffi) packages, so CGo is not necessary. Build your programs with the normal `go build` and `go run` commands.

Ready to get started? [Click here](getting-started).
{{% /blocks/lead %}}
