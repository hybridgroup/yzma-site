#!/bin/sh
# Get the browser demo from the "demo" release of yzma-wasm-example.
# Set DEMO_URL to take the tarball from another place.
set -eu

URL="${DEMO_URL:-https://github.com/hybridgroup/yzma-wasm-example/releases/download/demo/demo.tar.gz}"
DIR="static/try/app"

rm -rf "$DIR"
mkdir -p "$DIR"

case "$URL" in
	file://*) tar -xzf "${URL#file://}" -C "$DIR" ;;
	/*) tar -xzf "$URL" -C "$DIR" ;;
	*) curl -fsSL "$URL" | tar -xz -C "$DIR" ;;
esac

echo "demo: $URL"
ls "$DIR"
