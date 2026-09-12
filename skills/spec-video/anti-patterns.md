# Anti-patterns

Hard failures. If you catch yourself doing these, stop and re-read `SKILL.md` §0–2.

## Story

- **Boxes and arrows as the movie.** Sequence diagrams, C4, mermaid rendered as Motion Canvas. That is a slide. The film is a person in a room.
- **Narrating the spec.** Voiceover: "First the orchestrator receives a job envelope…" while generic nodes pulse. Cut it. Show the ask being typed.
- **Every service gets a scene.** If it is not in this Monday-morning run, it is not in the film.
- **Abstract agents.** "The agent" with no name, no computer, no room. Name Maya, name Sara, name whose laptop.

## Production

- **`npx create-video --yes` inside an existing git repo.** Scaffold by hand (`scripts/scaffold.sh`).
- **`npm install` from the monorepo root** while the film is installing. Film directory only.
- **Unconstrained Google Fonts.** Always `weights` + `subsets: ["latin"]` + `ignoreTooManyRequestsWarning: true`.
- **Full render before stills.** Still every beat. Then render once.
- **Missing `--gl=angle` on macOS** and a hang on frame 0.

## Picture

- **One chrome for two products.** Light team chat and dark local bot are different computers. They must look like it.
- **Invented pretty UI.** If the product is QM, copy QM. Do not ship a shadcn dashboard and caption it as the product.
- **Inter / system-ui / AI-purple mesh** as the default look.
- **Ken Burns on a screenshot** of a terminal. Type instead.
- **Unreadable tables.** If the artifact is a 12-column CRM grid, show the four columns the ask cares about.
- **Caption that repeats the bubble.** Caption = the cut you cannot see (the POST, the computer switch).

## Generation

- **Kling / Veo / Sora of the whole spec.** fal.ai is for holes, not the film.
- **Stock "team smiling at laptop"** as a substitute for the product.
- **AI voice reading the README.**

## Process

- **Skipping the Film Read.** If you cannot say the path in one sentence, you are not ready to scaffold.
- **Delivering a description of the video** instead of `out/<slug>.mp4` plus `npm run dev`.
- **Placeholder comments in compositions** (`{/* rest of scenes */}`). Full timeline or it is not done.
