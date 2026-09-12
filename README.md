# spec-video

Portable **agent skill** that turns a written spec or ADR into a Remotion **product-walkthrough film**.

Not an architecture-diagram movie. Not a Kling/Veo explainer. The film is the Monday-morning path a real person walks: the room, the ask, the computers in order, the artifact that comes back.

Quality bar for how the skill is written: [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) — short `SKILL.md`, progressive disclosure, hard rules, pre-flight, scripts, a worked example.

The skill is authored once under `skills/spec-video/`. Native **plugin** manifests wrap that same tree for Claude Code, Cursor, Codex, Gemini CLI, GitHub Copilot, and the [Agent Plugins](https://agent-plugins.org) standard.

## Install

### Any agent (Skills CLI)

The [`npx skills add`](https://github.com/vercel-labs/skills) CLI scans `skills/` and can target Claude Code, Cursor, Codex, Copilot, Gemini, OpenCode, Cline, Windsurf, and dozens more.

```bash
npx skills add divo12/spec-video
```

One skill, specific agents:

```bash
npx skills add divo12/spec-video --skill spec-video -a claude-code -a cursor -a codex -a github-copilot -a gemini-cli
```

All detected agents, no prompts:

```bash
npx skills add divo12/spec-video --all
```

### Claude Code (plugin marketplace)

```bash
claude plugin marketplace add divo12/spec-video
claude plugin install spec-video@spec-video
```

Or in a session: `/plugin marketplace add divo12/spec-video` then enable **spec-video**. Slash command: `/spec-video`.

### Cursor (plugin)

This repo is a Cursor plugin (`.cursor-plugin/plugin.json`) and an [Agent Plugin](https://agent-plugins.org) (`plugin.json` at the root). Add the GitHub repo as a plugin source, or copy `.cursor-plugin/` + `skills/` + `commands/` into a team marketplace.

### Codex / ChatGPT (plugin marketplace)

```bash
codex plugin marketplace add divo12/spec-video
```

Then `/plugins` and enable **spec-video**. Manifest: `.codex-plugin/plugin.json`. Catalog: `.agents/plugins/marketplace.json`.

### Gemini CLI (extension)

```bash
gemini extensions install https://github.com/divo12/spec-video
```

Context file is `GEMINI.md`. Skills are auto-discovered from `skills/`.

### GitHub Copilot

Copilot reads `.github/copilot-instructions.md` in this repo. For a durable skill install:

```bash
npx skills add divo12/spec-video -a github-copilot -g
```

### OpenCode, Cline, Windsurf, Amp, …

Use the Skills CLI with `--agent` (or `--all`). Those hosts consume `skills/<name>/SKILL.md` rather than a separate plugin manifest.

## When to use it

- "Make a video of this spec"
- "Remotion walkthrough of the architecture"
- "Demo film of how someone actually uses this"
- "spec-video of the ADR"

The agent should load this skill, state a **Film Read**, write a 4–8 beat storyboard, scaffold `films/<slug>/` **by hand**, still-check key frames, then render 1920×1080.

## What the skill enforces

1. **Path, not diagram.** Name the room, the person who asks, every computer the work touches, the artifact that returns. Cut mermaid.
2. **Nested Remotion, no template CLI.** `npx create-video --yes` inside an existing git repo fails. Use `skills/spec-video/scripts/scaffold.sh`.
3. **Stills before render.** `scripts/still.sh` then `scripts/render.sh` (`--gl=angle` on macOS).
4. **Fonts constrained.** Google Fonts with explicit `weights`, `subsets: ["latin"]`, `ignoreTooManyRequestsWarning`.
5. **One chrome per product.** Two computers → two palettes.
6. **Complementary tools stay in their lane.** Real footage → `video-editing` / FFmpeg. Missing thumbnail or SFX → `fal-ai-media`. Do not generate the whole spec as AI video.

## Repo layout

```
plugin.json                         # Agent Plugins 1.0 (Cursor + other clients)
.claude-plugin/                     # Claude Code marketplace + plugin
.cursor-plugin/                     # Cursor marketplace + plugin
.codex-plugin/                      # Codex / ChatGPT plugin
.agents/plugins/marketplace.json    # Codex marketplace catalog
gemini-extension.json               # Gemini CLI extension
GEMINI.md
commands/spec-video.md              # /spec-video slash command
AGENTS.md                           # agents that read a root instruction file
.github/copilot-instructions.md
skills/spec-video/SKILL.md          # the skill (one copy)
skills/spec-video/scripts/          # scaffold, still, render
research/monday-morning-path.md
```

`SKILL.md` stays short. The agent reads the other files when that step is in play.

## Complementary skills (not vendored here)

These already exist on the machine; this skill **routes** to them instead of copying them:

| Skill | Job |
| --- | --- |
| `video-editing` | Cut real footage (FFmpeg, EDL, overlays, 9:16) |
| `fal-ai-media` | Image / music / SFX for holes only |
| `content-engine` | Social posts after the mp4 exists |

## Worked example

The Grok Bridge film (QM room → personal Grok Bot → watch list back in the room) is the canonical run. See [skills/spec-video/examples.md](skills/spec-video/examples.md). Shape: **room → ask → computers in order → artifact back.** Replace names; do not replace the shape.

## License

[MIT](LICENSE)
