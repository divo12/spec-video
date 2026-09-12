# Storyboard

Write this **before** Remotion. Paste it into the film README so a human can re-cut later.

## Template

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
| Title | 0–90 | 0:00 | Time, room, who asks | (none, or none needed) |
| Ask | 78–378 | 0:02 | Person types the ask in the real UI | The team room is X. Y is a named agent. |
| Dispatch | 360–540 | 0:12 | Split: room stays, other computer opens | X POSTs a job. 200 only means the run started. |
| Work | 520–940 | 0:17 | Other computer does the job, step by step | Work runs where the account is already signed in. |
| Result | 920–1340 | 0:30 | Artifact returns to the room | (name the artifact) |
| End | 1320–1620 | 0:44 | One sentence of what changed | (optional) |
```

Overlap beats by 8–16 frames. Hard cuts feel like a slide deck.

## Timing rules

- **Title:** 2–3 seconds. Place and time ("Monday, 9:12am"), not the system name.
- **Ask:** long enough to *type* the real sentence. If the ask is 30+ words, type at ~1 char/frame and hold 1s after send.
- **Work:** one visual step per 2–2.5s. Not a montage of logos.
- **Result:** the artifact must be readable on a 1080p still. If a table has 12 columns, show 4.
- **Total:** 45–75s for an internal spec. 90s only if the brief is a talk.

## Copy rules

- Dialogue is what someone would actually type. Not "User submits QueryRequest to Orchestrator."
- Captions explain the **cut the viewer cannot infer** ("QM POSTs a job envelope"). They do not repeat the on-screen text.
- No caption on the title card.
- One caption per beat. Two captions = two beats.

## What to cut from the spec

Drop: retry graphs, IAM matrices, mermaid that is not a scene, "future work", every service that does not appear in this one run.

Keep: names of people, names of rooms, names of computers, the ask, the artifact.

## Duration math

```
DURATION = seconds * FPS
FPS = 30
```

Export `FPS` and `DURATION` from the film file. `Root.tsx` imports them. Do not hardcode `1620` in two places.
