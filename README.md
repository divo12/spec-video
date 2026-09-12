# spec-video

Turn a written spec or ADR into a Remotion **product-walkthrough film**.

A spec describes a system. Viewers remember a **run**. This skill makes coding agents film the Monday-morning path a real person walks — the room, the ask, the computers in order, the artifact that comes back — instead of animating boxes and arrows or generating a Kling/Veo explainer.

The skill is authored once under [`skills/spec-video/`](skills/spec-video/SKILL.md). Native plugin manifests wrap that same tree for Claude Code, Cursor, Codex, Gemini CLI, GitHub Copilot, and the [Agent Plugins](https://agent-plugins.org) standard. How the skill is written follows the [taste-skill](https://github.com/Leonxlnx/taste-skill) bar: short `SKILL.md`, progressive disclosure, hard rules, a pre-flight check, scripts, a worked example.

| | |
| --- | --- |
| Skill name | `spec-video` |
| Default output | `films/<slug>/out/<slug>.mp4` · 1920×1080 · 30fps · 45–75s |
| License | [MIT](LICENSE) |
| Repo | https://github.com/divo12/spec-video |

**Contents**

1. [What this is](#what-this-is)
2. [What this is not](#what-this-is-not)
3. [Quick start](#quick-start)
4. [Install](#install)
5. [How the agent should work](#how-the-agent-should-work)
6. [Film Read and dials](#film-read-and-dials)
7. [The Monday-morning path](#the-monday-morning-path)
8. [Storyboard](#storyboard)
9. [Scaffold, stills, render](#scaffold-stills-render)
10. [Scripts](#scripts)
11. [Production traps](#production-traps)
12. [Complementary skills](#complementary-skills)
13. [Worked examples](#worked-examples)
14. [Repo layout](#repo-layout)
15. [Skill files (progressive disclosure)](#skill-files-progressive-disclosure)
16. [Pre-flight](#pre-flight)
17. [FAQ](#faq)
18. [License](#license)

---

## What this is

`spec-video` is an **agent skill**: a `SKILL.md` plus references and scripts that an agent loads when you ask for a video of a spec.

The contract:

1. Read the spec.
2. State a one-line **Film Read** before any pixels.
3. Extract **one run** (not the architecture).
4. Write a 4–8 beat storyboard with frame ranges.
5. Scaffold a **nested** Remotion project inside the product repo at `films/<slug>/` — by hand, never `npx create-video` inside an existing git checkout.
6. Build UI that matches the product (screenshots if they exist). Two products, two chromes.
7. Still-check every beat.
8. Render `1920×1080` with `--gl=angle` on macOS.
9. Hand back the **mp4 path**, duration, and `npm run dev` / `npm run render`. A transcript of the spec is not a film.

Defaults: silent + burned-in captions. Voiceover only if the brief is a talk track.

## What this is not

- An architecture-diagram movie (C4, mermaid, Motion Canvas boxes).
- A replacement for the `video-editing` skill when you have four hours of Screen Studio.
- A wrapper around Kling / Veo / Sora. fal.ai fills a **hole** (thumbnail, whoosh), it does not generate the film.
- A Remotion tutorial. Remotion is the renderer; the skill is the cut.

Why the default is a path, not a diagram: [research/monday-morning-path.md](research/monday-morning-path.md).

---

## Quick start

After install, point an agent at a spec:

```text
Make a spec-video of docs/specs/<name>.md.
Load the spec-video skill. Film the Monday-morning path, not the architecture.
```

Or invoke the slash command where the plugin is enabled: `/spec-video`.

The agent should reply with a **Film Read** first, then a storyboard, then a nested Remotion project, then stills, then an mp4.

Manual scaffold if you are driving it yourself:

```bash
git clone https://github.com/divo12/spec-video.git
bash spec-video/skills/spec-video/scripts/scaffold.sh /path/to/product/films/my-film MyFilm
cd /path/to/product/films/my-film
npm install
npm run dev      # Remotion Studio
# still-check, then:
npm run render   # out/my-film.mp4
```

---

## Install

One skill tree. Pick the installer that matches the agent.

### Skills CLI (any agent)

The [`npx skills add`](https://github.com/vercel-labs/skills) CLI scans `skills/` and can install into Claude Code, Cursor, Codex, Copilot, Gemini, OpenCode, Cline, Windsurf, Amp, and others.

```bash
npx skills add divo12/spec-video
```

Pin the skill and the agents:

```bash
npx skills add divo12/spec-video --skill spec-video \
  -a claude-code -a cursor -a codex -a github-copilot -a gemini-cli
```

Every detected agent, no prompts:

```bash
npx skills add divo12/spec-video --all
```

Global (user-level) install:

```bash
npx skills add divo12/spec-video -g
```

Copy instead of symlink if the host cannot follow links:

```bash
npx skills add divo12/spec-video --copy
```

### Claude Code (plugin)

```bash
claude plugin marketplace add divo12/spec-video
claude plugin install spec-video@spec-video
```

In a session: `/plugin marketplace add divo12/spec-video`, then enable **spec-video**. Slash command: `/spec-video`.

Manifests: [`.claude-plugin/plugin.json`](.claude-plugin/plugin.json), [`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json).

### Cursor (plugin)

This repo is both a **Cursor plugin** (`.cursor-plugin/plugin.json`) and an **Agent Plugin** (`plugin.json` at the repo root, [Agent Plugins 1.0](https://agent-plugins.org)).

- Add `https://github.com/divo12/spec-video` as a plugin / marketplace source in Cursor, or
- Copy the repo into a team marketplace, or
- Use the Skills CLI: `npx skills add divo12/spec-video -a cursor`

Cursor also loads project skills from `.cursor/skills/` and `.agents/skills/`. The Skills CLI writes there.

### Codex / ChatGPT (plugin)

```bash
codex plugin marketplace add divo12/spec-video
```

Then `/plugins` and enable **spec-video**. Catalog: [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json). Manifest: [`.codex-plugin/plugin.json`](.codex-plugin/plugin.json).

### Gemini CLI (extension)

```bash
gemini extensions install https://github.com/divo12/spec-video
```

Context file: [`GEMINI.md`](GEMINI.md). Skills are auto-discovered from `skills/`.

### GitHub Copilot

This repo ships [`.github/copilot-instructions.md`](.github/copilot-instructions.md) so Copilot in a clone of *this* repo knows to load the skill. For Copilot in a **product** repo:

```bash
npx skills add divo12/spec-video -a github-copilot -g
```

### OpenCode, Cline, Windsurf, Amp, others

Use the Skills CLI with `-a <agent>` or `--all`. Those hosts consume `skills/<name>/SKILL.md`; they do not need a second plugin manifest.

### Manual copy

```bash
cp -R skills/spec-video ~/.cursor/skills/spec-video
cp -R skills/spec-video ~/.claude/skills/spec-video
cp -R skills/spec-video ~/.codex/skills/spec-video
```

Or paste [`skills/spec-video/SKILL.md`](skills/spec-video/SKILL.md) into a conversation and tell the agent to follow the linked references.

---

## How the agent should work

The full procedure is [`skills/spec-video/SKILL.md`](skills/spec-video/SKILL.md). Humans can treat this section as the same pipeline.

```
spec / ADR
  → Film Read (one line)
  → Monday-morning path (room, ask, computers, artifact)
  → 4–8 beat storyboard with frames
  → scaffold.sh  (nested Remotion, not create-video)
  → npm install inside films/<slug> only
  → build sequences + product chrome
  → still.sh every beat
  → render.sh  (--gl=angle on macOS)
  → mp4 + npm run dev
```

**Routing.** Remotion is for UI that must be exact and repeatable. If real footage exists, cut it with FFmpeg (`video-editing`) and overlay in Remotion. If a thumbnail or SFX is missing, generate **that hole** with `fal-ai-media`. Do not generate the whole spec as AI video.

---

## Film Read and dials

Before scaffolding, the agent states:

> Reading this as: \<product path\> for \<audience\>, in \<N\> beats, ~\<seconds\>s, leaning toward \<UI language\>.

Example: *"Reading this as: Monday pipeline-review path for the team that will run it, in 6 beats, ~54s, leaning toward QM light chrome vs Grok Bot dark computer."*

If the brief is ambiguous, ask **one** question. If it is not, do not ask.

Then set three dials (do not make the user edit `SKILL.md`):

| Dial | 1 | 10 | Baseline |
| --- | --- | --- | --- |
| `PATH_FIDELITY` | metaphor / motion graphics | pixel-matched product UI | **8** |
| `MOTION_INTENSITY` | stills with cuts | cinematic camera | **4** |
| `BEAT_DENSITY` | three long scenes | rapid cuts | **5** |

| Signal | FIDELITY | MOTION | DENSITY |
| --- | --- | --- | --- |
| Internal team / "how we use this" | 8–9 | 3–4 | 5–6 |
| Investor / launch | 6–7 | 6–7 | 4–5 |
| Conference talk | 5–6 | 6–8 | 3–4 |
| Pixel-matched shipping UI | 9–10 | 2–4 | 4–5 |
| Real footage exists | 7–8 | match footage | match edit |

---

## The Monday-morning path

The spec describes a system. The film shows **one run**.

1. Name the **room** (Slack channel, QM thread, standup, inbox).
2. Name the **person who asks** and the **exact ask** in spoken language, not ticket-ese.
3. Name every **computer** the work touches, in order. "Sara runs on Divyansh's Grok Bot" is a scene. "Agent runtime" is not.
4. Name the **artifact that comes back** (watch list, PR, invoice, failing test).
5. Cut everything that does not appear in that run — extra services, retry graphs, mermaid, future work.

If you cannot write that as a 4–8 beat storyboard, you do not understand the spec yet. Re-read. Do not start Remotion.

---

## Storyboard

Write this **before** Remotion. Paste it into `films/<slug>/README.md` so a human can re-cut later. Full rules: [`skills/spec-video/storyboard.md`](skills/spec-video/storyboard.md).

```markdown
# <Film title>

Source: <path to spec / ADR>
Audience: <who watches>
Duration: <seconds>s @ 30fps (<frames> frames)
Computers: <product A> · <product B>

## Film Read
Reading this as: ...

## Beats

| Beat | Frames | Clock | What we see | Caption (≤ 14 words) |
|------|--------|-------|-------------|----------------------|
| Title | 0–90 | 0:00 | Time, room, who asks | (none) |
| Ask | 78–378 | 0:02 | Person types the ask in the real UI | … |
| Dispatch | 360–540 | 0:12 | Split: room stays, other computer opens | … |
| Work | 520–940 | 0:17 | Other computer does the job | … |
| Result | 920–1340 | 0:30 | Artifact returns to the room | … |
| End | 1320–1620 | 0:44 | One sentence of what changed | (on the card) |
```

Overlap beats by 8–16 frames. Hard cuts feel like a slide deck.

**Timing.** Title 2–3s (place and time, not the system name). Ask long enough to *type* the real sentence. Work: one visual step per 2–2.5s. Result must be readable on a 1080p still. Total 45–75s for an internal spec; 90s only for a talk.

**Copy.** Dialogue is what someone would type. Captions explain the cut the viewer cannot infer ("QM POSTs a job envelope"). They do not repeat the bubble. One caption per beat. No caption on the title card.

`DURATION = seconds * 30`. Export `FPS` and `DURATION` from the film file; `Root.tsx` imports them. Do not hardcode `1620` in two places.

---

## Scaffold, stills, render

### Nested project

**Never** run `npx create-video --yes` (or any Remotion template CLI) inside an existing git repo. It fails or nests a second repo.

Place the film at `<product-repo>/films/<slug>/`:

```bash
bash /path/to/spec-video/skills/spec-video/scripts/scaffold.sh \
  /absolute/path/to/films/<slug> <CompositionId>
cd /absolute/path/to/films/<slug>
npm install
```

Install **only** in the film directory. A parent `npm install` racing the film install corrupts `node_modules`. First Remotion still/render downloads Chrome Headless Shell — allow network.

Layout the scaffold writes, plus font and chrome rules: [`skills/spec-video/remotion-scaffold.md`](skills/spec-video/remotion-scaffold.md).

```
films/<slug>/
  package.json          scripts: dev, render, still
  tsconfig.json
  remotion.config.ts
  src/index.ts          registerRoot
  src/Root.tsx          Composition id, fps, size, duration
  src/<Film>.tsx        Sequence timeline only
  src/theme.ts          fonts, colors, copy constants
  src/chrome.tsx        MacWindow, Caption
  src/<ProductA>.tsx    one computer
  src/<ProductB>.tsx    the other computer, if any
  README.md             storyboard
  out/                  mp4 + stills
```

`<Film>.tsx` is **only** `Sequence` blocks. Each beat is a named component. `layout="none"` on stacked sequences.

**UI.** Sample real screenshots. Copy spacing, sidebar, bubble color, type size. Do not "clean up" the product into a shadcn dashboard. Two products → two palettes and two window chromes (light QM vs dark Grok Bot is the canonical split). Type the ask with a caret. Do not fade in a paragraph.

**Fonts.** Load Google Fonts with explicit `weights`, `subsets: ["latin"]`, and `ignoreTooManyRequestsWarning: true`. Unconstrained `loadFont()` stalls the render. Two families max. Default: IBM Plex Sans + Instrument Serif (title card). Match product type if screenshots show it.

**Motion** when `PATH_FIDELITY > 7`: typing, list rows appearing, a split opening, a spring on the title. No Ken Burns on screenshots. No orbiting 3D nodes.

### Still-check

Do not `remotion render` until stills of every beat look right. Which frames and fail conditions: [`skills/spec-video/still-qa.md`](skills/spec-video/still-qa.md).

```bash
cd films/<slug>
bash /path/to/spec-video/skills/spec-video/scripts/still.sh \
  <CompositionId> 12,160,280,430,700,1100,1450
```

Inspect `out/stills/`. Fail if text is clipped, two products share chrome, the window is empty, the caption covers the ask, fonts fell back to Times/Arial, or the URL bar says `localhost`.

Grab the first **readable** frame of each beat (not frame 0 of a spring), plus one mid-beat if the beat types or lists.

### Render

```bash
cd films/<slug>
npx remotion render <CompositionId> out/<slug>.mp4 --gl=angle
# or
npm run render
```

`--gl=angle` is the macOS default that actually finishes. Without it, some machines hang on frame 0.

Studio: `npm run dev`. Deliver the **mp4 path**, duration, resolution, and those two commands.

Keep `out/<slug>.mp4` in git only if the product repo wants the artifact in the PR. Still PNGs stay gitignored (`out/stills/`).

---

## Scripts

Run these from this repo (or copy them). Do not rewrite them in the product repo unless the path layout differs.

| Script | Job |
| --- | --- |
| [`skills/spec-video/scripts/scaffold.sh`](skills/spec-video/scripts/scaffold.sh) `<dir> [CompositionId]` | Nested Remotion project: `package.json`, tsconfig, stubs, constrained fonts, `MacWindow` |
| [`skills/spec-video/scripts/still.sh`](skills/spec-video/scripts/still.sh) `<CompositionId> <frame,frame,…>` | PNG stills into `out/stills/` (run from the film dir) |
| [`skills/spec-video/scripts/render.sh`](skills/spec-video/scripts/render.sh) `<CompositionId> <out.mp4>` | Final encode with `--gl=angle` (run from the film dir) |

`scaffold.sh` refuses to overwrite an existing `package.json`.

---

## Production traps

Hard failures. Full list: [`skills/spec-video/anti-patterns.md`](skills/spec-video/anti-patterns.md).

**Story**

- Boxes and arrows as the movie.
- Voiceover that reads the spec while nodes pulse.
- Every service in the ADR gets a scene.
- "The agent" with no name, no computer, no room.

**Production**

- `npx create-video --yes` inside an existing git repo.
- `npm install` from the monorepo root while the film is installing.
- Unconstrained Google Fonts.
- Full render before stills.
- Missing `--gl=angle` on macOS.

**Picture**

- One chrome for two products.
- Invented pretty UI captioned as the product.
- Inter / system-ui / AI-purple mesh as the default look.
- Caption that repeats the bubble.
- A 12-column table that is unreadable at 1080p.

**Generation**

- Kling / Veo / Sora of the whole spec.
- Stock "team smiling at laptop".
- AI voice reading the README.

**Process**

- Skipping the Film Read.
- Delivering a description of the video instead of the mp4.
- Placeholder comments in compositions (`{/* rest of scenes */}`).

---

## Complementary skills

`spec-video` owns **spec → Remotion product path**. It does not vendor the rest of the stack. Load the other skill when that layer is actually in the brief. Details: [`skills/spec-video/complementary-skills.md`](skills/spec-video/complementary-skills.md).

| Job | Tool | Skill |
| --- | --- | --- |
| Product UI that does not exist as footage | Remotion | `spec-video` |
| Real screen / camera footage to cut | FFmpeg | `video-editing` |
| Missing still, thumbnail, music, SFX | fal.ai / ElevenLabs | `fal-ai-media` |
| Social cutdowns after the mp4 exists | FFmpeg + captions | `video-editing`, `content-engine` |
| Final pacing / mix for YouTube | Descript or CapCut | human (video-editing layer 6) |

| User says | Load |
| --- | --- |
| "Make a video of this spec" | `spec-video` only |
| "Cut the Screen Studio recording and overlay the architecture" | `video-editing`, then Remotion overlays |
| "Add a thumbnail and a tick SFX" | `fal-ai-media` after render |
| "Also tweet it" | `content-engine` after the mp4 |

If fal.ai MCP is not configured, skip generation and ship silent Remotion. Say which holes remain.

---

## Worked examples

### Grok Bridge (canonical)

**Source.** Architecture for team control of a personal Grok Bot through a QM room.

**Wrong film.** Boxes: QM HTTP → job envelope → Grok Bot runtime → CRM → callback.

**Right film.** Monday, 9:12am, `#pipeline-review`. Maya types an ask to Sara. Sara runs on Divyansh's Grok Bot, where the CRM is already signed in. A watch list posts back into the room. Divyansh is on a customer call.

Film Read: *Monday pipeline-review path for the team that will run it, in 6 beats, ~54s, leaning toward QM light chrome vs Grok Bot dark computer.*

Dials: `PATH_FIDELITY: 9` · `MOTION_INTENSITY: 3` · `BEAT_DENSITY: 5`

| Beat | Frames | What |
| --- | --- | --- |
| Title | 0–90 | "Monday, 9:12am"; `#pipeline-review · Maya asks Sara.` |
| Ask | 78–378 | QM light chrome. Maya's sentence types, then sends. |
| Dispatch | 360–540 | Split: QM stays; dark Grok Bot opens. 200 only means the run started. |
| Work | 520–940 | Grok desk: envelope → CRM signed-in → skip sequences → watch list. |
| Result | 920–1340 | Back in QM. Five-row table. Kite Harbor marked Skip. |
| End | 1320–1620 | Work ran on the computer that already had the CRM. |

What generalized: nested `films/grok-bridge/`; kill parent `npm install`; constrain fonts; copy in `theme.ts`; two palettes; stills before render.

Beat sheet and production notes: [`skills/spec-video/examples.md`](skills/spec-video/examples.md).

Shape to reuse: **room → ask → computers in order → artifact back.** Replace names. Do not replace the shape with architecture.

### Horizon M8 (second run)

Same skill, different repo. Spec: management / hierarchy / delegation across Horizon (strategy) and Chorus (org). Film Read: Monday portfolio path, Horizon light desk vs Chorus dark org desk, ~54s. Moe seeds a goal without naming people; Chorus picks Priya (still an engineer); Jules blocks; Priya `submit_task`s a fix; Horizon re-ranks the portfolio. The film lives next to the spec as `films/m8-delegation/` in the product repo, not in this skill repo.

---

## Repo layout

```
spec-video/
  plugin.json                         Agent Plugins 1.0 (portable skills + MCP floor)
  .claude-plugin/                     Claude Code marketplace + plugin
  .cursor-plugin/                     Cursor marketplace + plugin
  .codex-plugin/                      Codex / ChatGPT plugin
  .agents/plugins/marketplace.json    Codex marketplace catalog
  gemini-extension.json               Gemini CLI extension
  GEMINI.md
  commands/spec-video.md              /spec-video slash command (Claude, Cursor)
  AGENTS.md                           hosts that read a root instruction file
  .github/copilot-instructions.md
  skills/
    llms.txt
    spec-video/
      SKILL.md                        load this
      storyboard.md
      remotion-scaffold.md
      still-qa.md
      complementary-skills.md
      anti-patterns.md
      examples.md
      scripts/                        scaffold.sh, still.sh, render.sh
  research/monday-morning-path.md
  CHANGELOG.md
  LICENSE
```

There is **one** copy of the skill. Plugin manifests point at `skills/`. Do not fork `SKILL.md` per agent.

---

## Skill files (progressive disclosure)

`SKILL.md` stays under 500 lines. The agent reads the others when that step is in play. Links from `SKILL.md` are one level deep.

| File | When to open it |
| --- | --- |
| [`SKILL.md`](skills/spec-video/SKILL.md) | Always, when this skill is on |
| [`storyboard.md`](skills/spec-video/storyboard.md) | Writing beats, timing, captions |
| [`remotion-scaffold.md`](skills/spec-video/remotion-scaffold.md) | Files, fonts, chrome, install traps |
| [`still-qa.md`](skills/spec-video/still-qa.md) | Which frames to grab, fail the still |
| [`complementary-skills.md`](skills/spec-video/complementary-skills.md) | Footage, voice, music, social |
| [`anti-patterns.md`](skills/spec-video/anti-patterns.md) | You are about to ship slop |
| [`examples.md`](skills/spec-video/examples.md) | Need the Grok Bridge shape |

---

## Pre-flight

Before calling the film done (hard fail — from `SKILL.md` §9):

- [ ] Film Read was stated before code
- [ ] Storyboard exists as 4–8 beats with frame ranges
- [ ] Path is a person in a room, not a mermaid graph
- [ ] Nested Remotion project was scaffolded by hand (no `create-video` in a git repo)
- [ ] `npm install` ran inside `films/<slug>` only
- [ ] Fonts loaded with weights + latin subset + `ignoreTooManyRequestsWarning`
- [ ] Each distinct product has its own chrome / palette
- [ ] Stills of every beat inspected; no clipped type
- [ ] Rendered mp4 is 1920×1080 (or the brief's ratio) and plays
- [ ] Complementary tools used only for their job
- [ ] User can run `npm run dev` and `npm run render` without extra lore

If any box is unchecked, the output is not a spec-video.

---

## FAQ

**Do I need this repo in every product checkout?**  
No. Install the skill globally (`npx skills add divo12/spec-video -g`) or as a plugin. The **film** still lands in the product repo at `films/<slug>/`.

**Why not `create-video`?**  
Inside an existing git repo the Remotion template CLI fails or creates a nested repo. `scaffold.sh` writes the files this workflow actually uses.

**Why `--gl=angle`?**  
On Darwin, Remotion's default GL path can hang on frame 0. Angle is the encode that finishes.

**Can I commit the mp4?**  
Yes if the product PR wants reviewers to watch without rendering. Still PNGs stay out of git.

**Can I make it 9:16?**  
Change the composition size after the 16:9 film exists, or crop with FFmpeg (`video-editing`). Do not storyboard vertical as the first film unless the brief is Reels-only.

**Where does voiceover live?**  
Optional. Default is silent + captions. If the brief is a talk track, generate narration with ElevenLabs / fal.ai **after** stills pass, then mux. Do not narrate the architecture doc.

**How is this different from taste-skill?**  
taste-skill upgrades frontend UI. spec-video turns a **spec** into a **film**. Same authoring style (dials, anti-defaults, pre-flight, disclosed refs). Different job.

**How do I add another skill to this marketplace?**  
Add `skills/<name>/SKILL.md`, then point the Claude / Cursor / Codex marketplace plugin entries at that folder (or keep auto-discovery on `./skills`). Do not duplicate files per agent.

---

## License

[MIT](LICENSE) · Copyright (c) 2026 divo12
