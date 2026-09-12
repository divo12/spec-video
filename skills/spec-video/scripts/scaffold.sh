#!/usr/bin/env bash
# Nested Remotion project. Do not run create-video inside a git repo.
set -euo pipefail

DIR="${1:-}"
COMP="${2:-SpecFilm}"

if [[ -z "$DIR" ]]; then
  echo "usage: scaffold.sh <film-dir> [CompositionId]" >&2
  exit 1
fi

if [[ -e "$DIR/package.json" ]]; then
  echo "refusing: $DIR already has package.json" >&2
  exit 1
fi

mkdir -p "$DIR/src" "$DIR/out/stills"

SLUG="$(basename "$DIR")"
FILM_FILE="${COMP}.tsx"

cat > "$DIR/package.json" <<EOF
{
  "name": "${SLUG}-film",
  "private": true,
  "version": "0.1.0",
  "scripts": {
    "dev": "remotion studio",
    "render": "remotion render ${COMP} out/${SLUG}.mp4 --gl=angle",
    "still": "remotion still ${COMP}"
  },
  "dependencies": {
    "@remotion/cli": "^4.0.355",
    "@remotion/google-fonts": "^4.0.355",
    "react": "19.2.3",
    "react-dom": "19.2.3",
    "remotion": "^4.0.355"
  },
  "devDependencies": {
    "@types/react": "19.2.7",
    "typescript": "5.9.3"
  }
}
EOF

cat > "$DIR/tsconfig.json" <<'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ES2022",
    "jsx": "react-jsx",
    "strict": true,
    "moduleResolution": "bundler",
    "skipLibCheck": true,
    "noEmit": true
  },
  "include": ["src"]
}
EOF

cat > "$DIR/remotion.config.ts" <<'EOF'
import { Config } from "@remotion/cli/config";

Config.setVideoImageFormat("jpeg");
Config.setOverwriteOutput(true);
EOF

cat > "$DIR/src/index.ts" <<'EOF'
import { registerRoot } from "remotion";
import { RemotionRoot } from "./Root";

registerRoot(RemotionRoot);
EOF

cat > "$DIR/src/Root.tsx" <<EOF
import React from "react";
import { Composition } from "remotion";
import { DURATION, FPS, ${COMP} } from "./${COMP}";

export const RemotionRoot: React.FC = () => (
  <Composition
    id="${COMP}"
    component={${COMP}}
    durationInFrames={DURATION}
    fps={FPS}
    width={1920}
    height={1080}
  />
);
EOF

cat > "$DIR/src/${FILM_FILE}" <<EOF
import React from "react";
import { AbsoluteFill, Sequence } from "remotion";

export const FPS = 30;
export const DURATION = 54 * FPS;

export const ${COMP}: React.FC = () => {
  return (
    <AbsoluteFill style={{ background: "#2c2418" }}>
      <Sequence from={0} durationInFrames={DURATION} layout="none">
        <AbsoluteFill
          style={{
            justifyContent: "center",
            padding: 96,
            color: "#f4ead9",
            fontSize: 64,
            fontFamily: "sans-serif",
          }}
        >
          Replace this stub with the storyboard timeline.
        </AbsoluteFill>
      </Sequence>
    </AbsoluteFill>
  );
};
EOF

cat > "$DIR/src/theme.ts" <<'EOF'
import { loadFont as loadSans } from "@remotion/google-fonts/IBMPlexSans";
import { loadFont as loadSerif } from "@remotion/google-fonts/InstrumentSerif";

export const sans = loadSans("normal", {
  subsets: ["latin"],
  weights: ["400", "500", "600"],
  ignoreTooManyRequestsWarning: true,
});
export const serif = loadSerif("normal", {
  subsets: ["latin"],
  weights: ["400"],
  ignoreTooManyRequestsWarning: true,
});

export const colors = {
  paint: "#2c2418",
  window: "#f4f0e8",
  ink: "#1c1915",
  mute: "#6f675c",
  line: "#e4ddd2",
};
EOF

cat > "$DIR/src/chrome.tsx" <<'EOF'
import React from "react";
import { interpolate, useCurrentFrame } from "remotion";
import { colors, sans } from "./theme";

export const MacWindow: React.FC<{
  url: string;
  children: React.ReactNode;
  dark?: boolean;
}> = ({ url, children, dark }) => (
  <div
    style={{
      width: "100%",
      height: "100%",
      borderRadius: 18,
      overflow: "hidden",
      background: dark ? "#141312" : colors.window,
      display: "flex",
      flexDirection: "column",
      border: `1px solid ${dark ? "#2a2724" : colors.line}`,
    }}
  >
    <div
      style={{
        height: 46,
        display: "flex",
        alignItems: "center",
        padding: "0 16px",
        gap: 8,
        background: dark ? "#1a1816" : "#efeae2",
        borderBottom: `1px solid ${dark ? "#2a2724" : colors.line}`,
      }}
    >
      <span style={{ width: 10, height: 10, borderRadius: 99, background: "#e2554a" }} />
      <span style={{ width: 10, height: 10, borderRadius: 99, background: "#e6b326" }} />
      <span style={{ width: 10, height: 10, borderRadius: 99, background: "#3cba5f" }} />
      <div
        style={{
          margin: "0 auto",
          fontFamily: sans.fontFamily,
          fontSize: 13,
          color: dark ? "#9b9286" : colors.mute,
          background: dark ? "#141312" : "#fff",
          padding: "4px 48px",
          borderRadius: 8,
        }}
      >
        {url}
      </div>
    </div>
    <div style={{ flex: 1, minHeight: 0, position: "relative" }}>{children}</div>
  </div>
);

export const Caption: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const frame = useCurrentFrame();
  const o = interpolate(frame, [0, 12], [0, 1], { extrapolateRight: "clamp" });
  return (
    <div
      style={{
        position: "absolute",
        left: 48,
        bottom: 36,
        opacity: o,
        fontFamily: sans.fontFamily,
        fontSize: 22,
        color: "#f6f1e8",
        background: "rgba(20,18,14,0.72)",
        padding: "12px 18px",
        borderRadius: 12,
        maxWidth: 980,
        lineHeight: 1.35,
      }}
    >
      {children}
    </div>
  );
};
EOF

cat > "$DIR/.gitignore" <<'EOF'
node_modules/
out/stills/
.DS_Store
EOF

cat > "$DIR/README.md" <<EOF
# ${SLUG} film

Remotion walkthrough. Storyboard lives above this folder's commit message / the product spec.

\`\`\`bash
cd films/${SLUG}
npm install
npm run dev      # Remotion Studio
npm run render   # writes out/${SLUG}.mp4
\`\`\`
EOF

echo "scaffolded $DIR (composition ${COMP})"
echo "next: cd $DIR && npm install"
echo "then replace src/${FILM_FILE} with the storyboard timeline"
