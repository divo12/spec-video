# Examples

## Grok Bridge (canonical)

**Source spec:** a written architecture for team control of a personal Grok Bot through a QM room.

**Wrong film:** boxes — QM HTTP → job envelope → Grok Bot runtime → CRM → callback. Motion graphics of arrows.

**Right film:** Monday, 9:12am, `#pipeline-review`. Maya types an ask to Sara. Sara runs on Divyansh's Grok Bot, where the CRM is already signed in. A watch list posts back into the room. Divyansh is on a customer call.

### Film Read

*Reading this as: Monday pipeline-review path for the team that will run it, in 6 beats, ~54s, leaning toward QM light chrome vs Grok Bot dark computer.*

### Dials

`PATH_FIDELITY: 9` · `MOTION_INTENSITY: 3` · `BEAT_DENSITY: 5`

### Beats

| Beat | Frames | What |
|------|--------|------|
| Title | 0–90 | "Monday, 9:12am" serif; subline `#pipeline-review · Maya asks Sara.` |
| Ask | 78–378 | QM Mac window, light chrome. Maya's sentence types into the composer, then sends as a bubble. |
| Dispatch | 360–540 | Split: QM stays; dark Grok Bot window opens. Caption: 200 only means the run started. |
| Work | 520–940 | Full-bleed Grok desk. Steps: job envelope → CRM signed-in → skip active sequences → research → watch list. |
| Result | 920–1340 | Back in QM. Sara bubble with a 5-row table. Kite Harbor marked Skip. |
| End | 1320–1620 | One sentence: work ran on the computer that already had the CRM. |

### Production notes that generalized

- Nested at `films/grok-bridge/` inside the product repo. Hand scaffold. Parent `npm install` had to be killed so the film install could finish.
- Fonts: IBM Plex Sans + Instrument Serif, latin + explicit weights, or the render crawled.
- Still-check beats before `npx remotion render GrokBridgeFilm out/grok-bridge.mp4 --gl=angle`.
- Copy (`MAYA`, `ACCOUNTS`) lives in `theme.ts`, not inline in JSX.
- Two palettes in one theme file: `colors.window` vs `colors.grokBg`. `MacWindow dark` for the bot.

### What we refused

- A sequence diagram of the job envelope.
- Voiceover.
- Generating "AI agent talking to CRM" b-roll.

Use this shape for any spec: **room → ask → computers in order → artifact back.** Replace names. Do not replace the shape with architecture.
