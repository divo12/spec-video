#!/usr/bin/env bash
# Render PNG stills for beat QA. Run from films/<slug>.
set -euo pipefail

COMP="${1:-}"
FRAMES="${2:-}"

if [[ -z "$COMP" || -z "$FRAMES" ]]; then
  echo "usage: still.sh <CompositionId> <frame,frame,...>" >&2
  echo "  example: still.sh GrokBridgeFilm 12,160,280,430,700,1100,1450" >&2
  exit 1
fi

mkdir -p out/stills
IFS=',' read -ra LIST <<< "$FRAMES"
for f in "${LIST[@]}"; do
  f="$(echo "$f" | tr -d ' ')"
  padded="$(printf "%04d" "$f")"
  echo "still frame $f"
  npx remotion still "$COMP" "out/stills/f-${padded}.png" --frame="$f"
done

echo "wrote ${#LIST[@]} stills to out/stills/"
