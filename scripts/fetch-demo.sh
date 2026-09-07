#!/bin/sh
# Get the browser demo from the "demo" release of yzma-wasm-example.
# Set DEMO_URL to take the tarball from another place.
set -eu

URL="${DEMO_URL:-https://github.com/hybridgroup/yzma-wasm-example/releases/download/demo/demo.tar.gz}"
DIR="static/try/app"

rm -rf "$DIR"
mkdir -p "$DIR"

case "$URL" in
	http://* | https://*)
		TARBALL="$(mktemp)"
		trap 'rm -f "$TARBALL"' EXIT
		if ! curl -fsSL "$URL" -o "$TARBALL"; then
			echo "fetch-demo: the download failed: $URL" >&2
			echo "fetch-demo: the assets workflow of yzma-wasm-example makes this file." >&2
			exit 1
		fi
		;;
	file://*)
		TARBALL="${URL#file://}"
		;;
	*)
		TARBALL="$URL"
		;;
esac

tar -xzf "$TARBALL" -C "$DIR"

echo "demo: $URL"
ls "$DIR"
