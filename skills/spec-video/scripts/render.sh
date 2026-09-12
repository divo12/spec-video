#!/usr/bin/env bash
# Final encode. Run from films/<slug>.
set -euo pipefail

COMP="${1:-}"
OUT="${2:-}"

if [[ -z "$COMP" || -z "$OUT" ]]; then
  echo "usage: render.sh <CompositionId> <out.mp4>" >&2
  echo "  example: render.sh GrokBridgeFilm out/grok-bridge.mp4" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"
npx remotion render "$COMP" "$OUT" --gl=angle
echo "wrote $OUT"
