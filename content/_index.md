---
title: "yzma"
---

{{< blocks/cover title="" image_anchor="top" height="min" color="dark" >}}

<img src="/images/yzma-logo-cover.png" alt="yzma" class="img-fluid mt-0 mt-md-5" style="max-width: 720px; width: 80%;">

<p class="h3 mt-4 pb-4">Local inference for Go, with llama.cpp</p>

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

{{% blocks/lead color="secondary" %}}
yzma uses the [purego](https://github.com/ebitengine/purego) and [ffi](https://github.com/JupiterRider/ffi) packages, so CGo is not necessary. Build your programs with the normal `go build` and `go run` commands.

Ready to get started? [Click here](getting-started).
{{% /blocks/lead %}}
