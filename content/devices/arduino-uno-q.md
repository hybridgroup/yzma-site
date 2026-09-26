---
title: "Arduino UNO Q"
linkTitle: "Arduino UNO Q"
type: "docs"
weight: 10
description: >
  Run models on the Arduino UNO Q.
---

<img src="/images/arduino-logo.png" alt="Arduino logo" class="platform-logo">

The Arduino UNO Q is a unique board with two functions. It has both a Qualcomm QRB2210 arm64 processor running a full Debian based Linux, as well as a STM32U585 microcontroller.

yzma runs on the Linux side of the board and uses the CPU for inference. With a small text model, the board can process about 32 tokens a second.

<figure class="device-photo">
<img src="/images/devices/arduino-uno-q.webp" alt="Arduino UNO Q board">
<figcaption>Image by <a href="https://github.com/arduino/docs-content">Arduino</a>, <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0</a></figcaption>
</figure>

## Links

- [Arduino UNO Q website](https://docs.arduino.cc/hardware/uno-q/)
- [Getting started on the Arduino UNO Q](/getting-started/install/arduino-uno-q/)
- [Text generation benchmarks](/docs/reference/benchmarks/#text-generation)
- [Multimodal benchmarks](/docs/reference/benchmarks/#multimodal)
