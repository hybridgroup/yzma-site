---
title: "Multimodal input"
linkTitle: "Multimodal"
type: "docs"
weight: 40
description: >
  Send images, audio, and video to a model.
---

`pkg/mtmd` sends more than text to a model. It handles images, audio, and video.

## Load the projector

A multimodal model needs a projector file. The projector turns the image, the sound, or the video into tokens.

```go
mtmd.Load(libPath)

mctxParams := mtmd.ContextParamsDefault()
mtmdCtx, err := mtmd.InitFromFile(projFile, model, mctxParams)
defer mtmd.Free(mtmdCtx)
```

## Check what the model accepts

```go
mtmd.SupportVision(mtmdCtx)
mtmd.SupportAudio(mtmdCtx)
mtmd.SupportVideo(mtmdCtx)
```

Each one gives a boolean. Check before you send the input.

## Images

Read an image from a file:

```go
bitmap := mtmd.BitmapInitFromFile(mtmdCtx, imageFile, false, mtmd.InitOptDefault())
defer mtmd.BitmapFree(bitmap.Bitmap)
```

Read an image from memory:

```go
bitmap := mtmd.BitmapInitFromBuf(mtmdCtx, &data[0], uint64(len(data)), false, mtmd.InitOptDefault())
```

See [Vision](/docs/tutorials/vision/) for the complete program.

## Audio

`BitmapInitFromAudio` takes the samples as `float32` values.

```go
bitmap := mtmd.BitmapInitFromAudio(uint64(len(samples)), &samples[0])
defer mtmd.BitmapFree(bitmap)
```

The model expects one sample rate. `GetAudioSampleRate` gives it:

```go
rate := mtmd.GetAudioSampleRate(mtmdCtx)
```

Resample your audio to that rate before you send it.

## Video

Video needs `ffmpeg` and `ffprobe` on the PATH. mtmd calls them to read the frames.

```go
params := mtmd.VideoInitParamsDefault()
params.FPSTarget = 1.0
params.TimestampIntervalMs = 10000

video := mtmd.VideoInit(mtmdCtx, videoFile, params)
```

| Field | What it does |
| --- | --- |
| `FPSTarget` | How many frames to take each second. A value of 0 or less takes the native rate of the video. |
| `FFmpegBinDir` | The directory that holds `ffmpeg` and `ffprobe`. A nil value searches the PATH. Use `utils.BytePtrFromString` to make the value. |
| `TimestampIntervalMs` | How often to put a time marker in the tokens, such as `[10m50.5s]`. A value of 0 or less adds no markers. |

A lower `FPSTarget` gives fewer frames. Fewer frames need less time and less memory. Start with 1.0.

`VideoInitFromBuf` reads a video from memory.

## Send the input to the model

The steps are the same for every kind of input.

```go
output := mtmd.InputChunksInit()
defer mtmd.InputChunksFree(output)

input := mtmd.NewInputText(prompt, true, true)
mtmd.Tokenize(mtmdCtx, output, input, []mtmd.Bitmap{bitmap})

var n llama.Pos
mtmd.HelperEvalChunks(mtmdCtx, lctx, output, 0, 0, nBatch, true, &n)
```

The prompt must hold the marker that says where the input goes. `mtmd.DefaultMarker()` gives it.

## More than one image

Put more bitmaps in the slice, and put one marker in the text for each one.

```go
mtmd.Tokenize(mtmdCtx, output, input, []mtmd.Bitmap{first, second})
```

## Parts

`TokenizeFromParts` builds the input from a list of parts. Use it when you need text, then an image, then more text.

```go
parts := []*mtmd.InputPart{
	mtmd.NewInputTextPart(mtmd.NewInputText("Look at this:", true, true)),
	mtmd.NewInputBitmapPart(bitmap),
}

mtmd.TokenizeFromParts(mtmdCtx, output, parts, true)
```

## Speed

The projector runs one time for each image. This is the slow part. On a CPU it takes half a minute or more. On a GPU it takes a second or two.

Use a GPU for a program that reads images. See [Hardware acceleration](/docs/concepts/acceleration/).

## In a browser

The browser package reads images. It has no audio and no video. See [WebAssembly](/docs/concepts/webassembly/).
