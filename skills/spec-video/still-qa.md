# Still-frame QA

A full render that you have not still-checked is a waste of minutes. Stills are the unit of review.

## Which frames

Grab the **first readable frame of each beat**, plus one mid-beat if the beat types or lists.

Example (30fps, 54s film):

| Beat | Frame | Why |
|------|-------|-----|
| Title | 12 | spring settled, not frame 0 |
| Ask (typing) | 160 | enough characters to judge overflow |
| Ask (sent) | 280 | bubble + caption together |
| Dispatch split | 430 | both windows visible |
| Work mid | 700 | densest UI state |
| Result | 1100 | table/artifact readable |
| End | 1450 | type not clipped |

Command:

```bash
# from films/<slug>
npx remotion still <CompositionId> out/stills/f-012.png --frame=12
npx remotion still <CompositionId> out/stills/f-160.png --frame=160
```

Or:

```bash
bash /path/to/spec-video/skills/spec-video/scripts/still.sh <CompositionId> 12,160,280,430,700,1100,1450
```

## Fail the still (must re-shoot)

- Headline or caption clipped, wrapping through the window chrome, or overflowing 1920
- Two products sharing the same window chrome / palette
- Empty state that looks like a missing component ("No messages" on a result beat)
- Typed ask truncated mid-word because `Math.floor(frame * n)` is too slow or too fast
- URL bar says `localhost` or `example.com` — use the real host from the spec
- Sidebar + composer + content stacked until the message is 40px tall
- Caption covering the sentence the viewer is supposed to read
- Font fallback (Times / Arial) — fonts did not finish loading; fix `loadFont` options and still again

## Pass

- You can screenshot the still and a teammate names the product without the caption
- The ask is a sentence a human would type
- The artifact on the result beat is legible at 100% zoom in Preview

## After stills pass

Render once. Do not re-render to "see if it's better" without a new still of the changed beat.
