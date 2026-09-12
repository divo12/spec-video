---
name: spec-video
description: Turns a written spec, ADR, or architecture into a Remotion product-walkthrough film. Use when the user wants a video of a spec, a Remotion demo, a spec-video, a walkthrough film, or a product-path movie of a design.
---

# spec-video: Spec → Remotion Film

> A written spec is not a video. An architecture diagram is not a video.
> Film the Monday-morning path a real person walks through the product.
> Every rule below is **contextual**. Read the spec first. Pull only what fits.

---

## 0. BRIEF INFERENCE (Before any pixels)

Before scaffolding Remotion, state a one-line **Film Read**:

**"Reading this as: \<product path\> for \<audience\>, in \<N\> beats, ~\<seconds\>s, leaning toward \<UI language\>."**

Example: *"Reading this as: Monday pipeline-review path for the team that will run it, in 6 beats, ~54s, leaning toward QM light chrome vs Grok Bot dark computer."*

### 0.A Signals to read
1. **Source** — spec, ADR, design doc, PR description, or a verbal walkthrough.
2. **Audience** — the team that will run it, an investor, a new hire, a conference talk. Audience picks pacing, not your taste.
3. **Computers** — how many distinct products / machines appear. Each gets its own chrome. Never one window for two systems.
4. **Existing UI** — screenshots, Storybook, production URL, brand tokens. Match them. Do not invent a prettier fake.
5. **Footage** — is there real screen capture / camera? If yes, this skill **hands off cuts to `video-editing`**. Remotion is then overlays + UI scenes, not the whole movie.
6. **Quiet constraints** — no voiceover, no customer logos, internal-only, 16:9 vs 9:16.

### 0.B If the brief is ambiguous, ask one question
Ask exactly **one** question, and only when the film read diverges. Example: *"Should this be a Monday-morning product path, or a 90-second conference talk?"*

If you can infer, **do not ask**. Declare the film read and proceed.

### 0.C Anti-default discipline
Do not default to: boxes-and-arrows architecture animation, Inter on a dark mesh, a narrator reading the spec, three equal feature cards as "scenes", generating the whole film with Kling/Veo, or a single Mac window that stands in for every product.

---

## 1. THE THREE DIALS

Set these after the film read. Do not ask the user to edit this file.

* **`PATH_FIDELITY: 8`** — 1 = metaphor / motion graphics, 10 = pixel-matched product UI
* **`MOTION_INTENSITY: 4`** — 1 = stills with cuts, 10 = cinematic camera
* **`BEAT_DENSITY: 5`** — 1 = three long scenes, 10 = rapid cuts

**Baseline:** `8 / 4 / 5` (product walkthrough). Override from the table:

| Signal | FIDELITY | MOTION | DENSITY |
|---|---|---|---|
| Internal team / "how we use this" | 8–9 | 3–4 | 5–6 |
| Investor / launch | 6–7 | 6–7 | 4–5 |
| Conference talk | 5–6 | 6–8 | 3–4 |
| Pixel-matched demo of shipping UI | 9–10 | 2–4 | 4–5 |
| Real footage exists | 7–8 | match footage | match edit |

---

## 2. EXTRACT THE MONDAY-MORNING PATH

The spec describes a system. The film shows **one run**.

1. Name the **room** (Slack channel, QM thread, standup, inbox).
2. Name the **person who asks** and the **exact ask** in spoken language, not ticket-ese.
3. Name every **computer** the work touches, in order. "Sara runs on Divyansh's Grok Bot" is a scene. "Agent runtime" is not.
4. Name the **artifact that comes back** (watch list, PR, invoice, failing test).
5. Cut everything that does not appear in that run — extra services, retry graphs, mermaid.

If you cannot write the path as a 4–8 beat storyboard, you do not understand the spec yet. Re-read. Do not start Remotion.

Write the storyboard before code. Format and timing live in [storyboard.md](storyboard.md). A worked example is in [examples.md](examples.md).

---

## 3. TOOL ROUTING (Do not make one tool do everything)

| Job | Tool | Skill |
|---|---|---|
| Product UI that does not exist as footage | **Remotion** (this skill) | `spec-video` |
| Real screen / camera footage to cut | **FFmpeg** | `video-editing` |
| Missing still, thumbnail, music, SFX | **fal.ai / ElevenLabs** | `fal-ai-media` |
| Social cutdowns after the film exists | **FFmpeg + captions** | `video-editing`, `content-engine` |
| Final pacing / captions taste | Human in Descript or CapCut | `video-editing` layer 6 |

**Hard split:** Remotion builds UI that must be exact and repeatable. FFmpeg cuts reality. fal.ai fills a hole. Generating the whole spec as AI video is a failure of this skill.

Read [complementary-skills.md](complementary-skills.md) when footage, voice, or music enters the brief.

---

## 4. SCAFFOLD (Fragile — use the script)

**Never** run `npx create-video --yes` (or any Remotion template CLI) inside an existing git repo. It fails or nests a second repo.

Place the film at `<product-repo>/films/<slug>/`. Scaffold by hand:

```bash
# from this skill directory, or copy the script into the product repo
bash scripts/scaffold.sh /absolute/path/to/films/<slug> <CompositionId>
cd /absolute/path/to/films/<slug>
npm install
```

Install **only** in the film directory. A parent `npm install` racing the film install corrupts `node_modules`. First Remotion render downloads a Chrome headless shell — allow network + full disk.

Exact files, `package.json`, font loading, and chrome patterns: [remotion-scaffold.md](remotion-scaffold.md).

Defaults: **1920×1080**, **30 fps**, **45–75 seconds**. Change duration in the composition, not by stretching a 10s loop.

---

## 5. BUILD THE FILM

### 5.A File split (do not dump a 800-line composition)
```
src/index.ts          registerRoot
src/Root.tsx          Composition id, fps, size, duration
src/<Film>.tsx        Sequence timeline only
src/theme.ts          fonts, colors, copy constants
src/chrome.tsx        MacWindow, Caption — shared
src/<ProductA>.tsx    one computer / one product
src/<ProductB>.tsx    the other computer, if any
```

### 5.B Timeline
`<Film>.tsx` is **only** `Sequence` blocks. Each beat is a named component. Overlap 8–16 frames for crossfades. `layout="none"` on sequences that stack.

### 5.C UI fidelity
- Sample real screenshots. Copy spacing, sidebar, bubble color, type size. Do not "clean up" the product.
- Two products → two palettes and two window chromes (light QM vs dark Grok Bot is the canonical split).
- Type the ask. Do not fade in a paragraph. A caret is cheaper than a voiceover and more honest.
- Captions are one sentence of *what just happened*, not a restatement of the spec.

### 5.D Fonts (render-time landmine)
Load Google Fonts with **explicit `weights`, `subsets: ["latin"]`, and `ignoreTooManyRequestsWarning: true`**. Unconstrained `loadFont()` stalls the render. Details in [remotion-scaffold.md](remotion-scaffold.md).

### 5.E Motion
`PATH_FIDELITY > 7`: motion is typing, list rows appearing, a split opening, a spring on the title. No Ken Burns on screenshots. No orbiting 3D nodes.

---

## 6. STILL-CHECK BEFORE RENDER

Do **not** `remotion render` until stills of every beat look right.

```bash
bash scripts/still.sh <CompositionId> 0,90,400,600,1000,1400
```

Inspect `out/stills/`. Fail the still if: text clipped, two products sharing chrome, empty window, caption covering the ask, layout jump vs the previous beat. Fix, still again. Process in [still-qa.md](still-qa.md).

---

## 7. RENDER

```bash
cd films/<slug>
npx remotion render <CompositionId> out/<slug>.mp4 --gl=angle
```

`--gl=angle` is the macOS default that actually finishes. Without it, some machines hang on first frame. Write a `package.json` script `render` so humans can re-run.

Studio: `npm run dev`. Deliver **the mp4 path**, duration, resolution, and the Studio command. Do not paste a transcript of the spec as a substitute for the file.

---

## 8. OUT OF SCOPE

- Architecture-diagram movies (boxes, arrows, sequence charts as the hero).
- Replacing `video-editing` for a four-hour screen recording.
- Generating the entire film with a video model.
- Voiceover that reads the spec aloud (unless the brief asks for a talk track).
- Shipping without stills.

Banned patterns: [anti-patterns.md](anti-patterns.md).

---

## 9. PRE-FLIGHT CHECK (hard fail)

Before calling the film done:

- [ ] Film Read was stated before code
- [ ] Storyboard exists as 4–8 beats with frame ranges
- [ ] Path is a person in a room, not a mermaid graph
- [ ] Nested Remotion project was scaffolded by hand (no `create-video` in a git repo)
- [ ] `npm install` ran inside `films/<slug>` only
- [ ] Fonts loaded with weights + latin subset + `ignoreTooManyRequestsWarning`
- [ ] Each distinct product has its own chrome / palette
- [ ] Stills of every beat inspected; no clipped type
- [ ] Rendered mp4 is 1920×1080 (or the brief's ratio) and plays
- [ ] Complementary tools used only for their job (FFmpeg for footage, fal.ai for holes)
- [ ] User can run `npm run dev` and `npm run render` without extra lore

If any box is unchecked, the output is not a spec-video. Fix it.

---

## Utility scripts

Run these; do not rewrite them in the product repo unless the path layout differs.

| Script | Job |
|---|---|
| `scripts/scaffold.sh <dir> <CompositionId>` | Nested Remotion project (package.json, tsconfig, stubs) |
| `scripts/still.sh <CompositionId> <frames>` | PNG stills for QA |
| `scripts/render.sh <CompositionId> <out.mp4>` | Final encode with `--gl=angle` |

## Additional resources

- [storyboard.md](storyboard.md) — beat sheet, timing, copy rules
- [remotion-scaffold.md](remotion-scaffold.md) — files, fonts, chrome, install traps
- [still-qa.md](still-qa.md) — which frames to grab, fail conditions
- [complementary-skills.md](complementary-skills.md) — `video-editing`, fal.ai, FFmpeg
- [anti-patterns.md](anti-patterns.md) — slop this skill exists to prevent
- [examples.md](examples.md) — Grok Bridge film as the worked example
