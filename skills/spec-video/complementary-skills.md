# Complementary skills

`spec-video` owns **spec → Remotion product path**. It does not replace the rest of the video stack. Load the other skill when that layer is actually in the brief.

## `video-editing`

Use when **real footage exists** (Screen Studio, camera, desktop capture).

That skill's pipeline is: capture → structure → **FFmpeg cuts** → Remotion overlays → generated holes → human polish.

In a spec-video that includes a real recording:

1. Let `video-editing` produce an EDL and FFmpeg segments.
2. Drop those files into `films/<slug>/public/` and `<Video src={staticFile("segment_01.mp4")} />` inside a Sequence.
3. Keep product-UI beats (the parts that were never recorded) as Remotion scenes.

Do not re-encode raw camera in Remotion. FFmpeg `-c copy` the cuts first.

FFmpeg cheatsheet lives in that skill (trim, concat, loudnorm, 9:16 crop). Do not duplicate it here.

## `fal-ai-media`

Use only for **assets that do not exist**:

- Thumbnail / end-card texture
- One insert still (office, device, map) when a screenshot cannot be faked honestly
- Background music or a whoosh if the brief asks for sound
- Voiceover **only** if the brief is a talk track

Do **not** `generate()` a 54s "explainer video" of the spec. That is the failure mode this skill exists to prevent.

If fal.ai MCP is not configured, skip generation and ship silent Remotion. Tell the user which holes remain.

## `content-engine`

After the mp4 exists, if the user wants X / LinkedIn / a launch post. The film is the source asset. Do not write social copy before the stills pass.

## ElevenLabs

Same rule as fal.ai: narration is optional. Spec-videos default to **silent + captions**. A voice that reads the architecture doc is slop.

## Human polish (Descript / CapCut)

Optional last 5%. Captions burned in Remotion should already be readable. Use a traditional editor only if the user will publish to YouTube and wants a louder mix.

## Routing test

| User says | Load |
|-----------|------|
| "Make a video of this spec" | `spec-video` only |
| "Cut the Screen Studio recording and overlay the architecture" | `video-editing` then Remotion overlays from this skill |
| "Add a thumbnail and a tick SFX" | `fal-ai-media` after render |
| "Also tweet it" | `content-engine` after mp4 |
