# Remotion scaffold

Hand-rolled nested project. Do **not** run `npx create-video` inside a git checkout.

## Layout

```
films/<slug>/
  package.json
  tsconfig.json
  remotion.config.ts
  src/index.ts
  src/Root.tsx
  src/<Film>.tsx
  src/theme.ts
  src/chrome.tsx
  src/<SurfaceA>.tsx
  src/<SurfaceB>.tsx   # only if a second computer exists
  README.md
  out/                 # gitignored except you may keep the final mp4 if the product repo wants it
```

## package.json

```json
{
  "name": "<slug>-film",
  "private": true,
  "version": "0.1.0",
  "scripts": {
    "dev": "remotion studio",
    "render": "remotion render <CompositionId> out/<slug>.mp4 --gl=angle",
    "still": "remotion still <CompositionId>"
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
```

Pin Remotion packages to the **same** version. Mixed `@remotion/cli` vs `remotion` versions fail in confusing ways.

## remotion.config.ts

```ts
import { Config } from "@remotion/cli/config";

Config.setVideoImageFormat("jpeg");
Config.setOverwriteOutput(true);
```

## src/index.ts

```ts
import { registerRoot } from "remotion";
import { RemotionRoot } from "./Root";

registerRoot(RemotionRoot);
```

## src/Root.tsx

```tsx
import React from "react";
import { Composition } from "remotion";
import { DURATION, FPS, Film } from "./Film";

export const RemotionRoot: React.FC = () => (
  <Composition
    id="Film"
    component={Film}
    durationInFrames={DURATION}
    fps={FPS}
    width={1920}
    height={1080}
  />
);
```

Rename `Film` / id to the composition id passed to the scaffold script.

## tsconfig.json

```json
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
```

## Fonts — required options

```ts
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
```

Unconstrained `loadFont()` downloads every weight and stalls. Two families max. Serif for the title card only.

Match product type if screenshots show it. Otherwise IBM Plex Sans + Instrument Serif is the spec-video default (readable at 1080p, not Inter).

## Chrome

One `MacWindow` with traffic lights + URL bar. `dark?: boolean` for the second computer. Do not skin both products with the same beige window.

`Caption` is a bottom-left pill, max ~980px, one sentence, fades 12 frames. Never cover the primary CTA or the typed ask.

Product surfaces (`QmRoom`, `GrokDesk`, …) are **not** generic cards. Recreate the sidebar, composer, and message bubbles from screenshots. If you do not have screenshots, open the app or say so — do not invent Linear-clone chrome and call it the product.

## Install traps

1. `cd films/<slug> && npm install` — never from the monorepo root in the same moment.
2. If a parent install is running, kill it. Competing installs leave a half tree and Remotion cannot resolve `react`.
3. First `remotion still` / `render` downloads Chrome Headless Shell. Needs network. On macOS sandbox, re-run with full permissions.
4. `--gl=angle` on Darwin. If render hangs on frame 0, you forgot it.

## .gitignore for the film dir

```
node_modules/
out/stills/
.DS_Store
```

Keep `out/<slug>.mp4` if the product repo wants the artifact in git; otherwise ignore `out/` entirely and attach the mp4 to the PR.

Use `scripts/scaffold.sh` to write the stubs. Then replace `Film.tsx` with the real timeline.
