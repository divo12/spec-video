# spec-video

Portable **agent skill** that turns a written spec or ADR into a Remotion **product-walkthrough film**.

Not an architecture-diagram movie. Not a Kling/Veo explainer. The film is the Monday-morning path a real person walks: the room, the ask, the computers in order, the artifact that comes back.

Quality bar for how the skill is written: [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) — short `SKILL.md`, progressive disclosure, hard rules, pre-flight, scripts, a worked example.

## Install

The [`npx skills add`](https://github.com/vercel-labs/agent-skills) CLI scans `skills/` in this repo.

```bash
npx skills add https://github.com/divo12/spec-video
```

Single skill (install name is the `name:` field in frontmatter):

```bash
npx skills add https://github.com/divo12/spec-video --skill spec-video
```

Or copy `skills/spec-video/` into `~/.cursor/skills/spec-video` or `.cursor/skills/spec-video` in a product repo.

You can also paste `skills/spec-video/SKILL.md` into a Cursor / Claude / Codex conversation and point the agent at the references.

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
skills/spec-video/SKILL.md          # load this
skills/spec-video/storyboard.md
skills/spec-video/remotion-scaffold.md
skills/spec-video/still-qa.md
skills/spec-video/complementary-skills.md
skills/spec-video/anti-patterns.md
skills/spec-video/examples.md       # Grok Bridge worked example
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
