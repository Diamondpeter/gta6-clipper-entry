# The clip

**File:** `clip.mp4` — 1080×1920 vertical, 25.2 seconds, H.264 + AAC. A YouTube Short.

## The moment

Source: Rockstar Games' official **Grand Theft Auto VI Launch Trailer** (YouTube
`rz1B4B2yBZY`, 15 Oct 2026, captured in-game on PS5). GTA 6 launched on 19 Nov 2026 —
the day before this entry was built — so the launch trailer is the footage the whole
internet is talking about this week, and its most explosive beat is the hook.

The clip opens **on** that beat, not before it: at 71.3s into the trailer a sniper
settles over the neon city, and a second later Lucia fires as a fireball goes up
behind her. That shot runs into the underwater silhouettes and the trailer's own
GTA VI logo reveal (clip 0–5.7s), under the on-screen line **GTA 6 IS FINALLY HERE /
AND IT LOOKS INSANE**. Then the neon Leonida skyline and the lowrider crew roll by
(trailer 16.8–23.3s) under **WELCOME BACK TO LEONIDA**.

## The pitch

The last two-fifths turn to the viewer, as the bounty requires. The skyline slows
and dims, a text-to-speech voice recorded in the same session says the pitch, and
the words appear on screen a line at a time (each held 3+ seconds, centred, clear of
YouTube's bottom and right-edge buttons):

- "This clip was cut by an AI agent"
- "Make clips like this with AI / and EARN MONEY on make.fun"
- "make.fun/bounty/gta6-clipper-01"

A black end card closes it: **make.fun** — "Earn money making clips with AI" —
"make.fun/bounty/gta6-clipper-01".

## How it was made

Every step ran in the agent session that wrote this repository: the trailer was
downloaded, frames were pulled to choose the moment, the voiceover was synthesised,
and the clip was cut, blur-filled to 9:16, captioned and rendered with one ffmpeg
command. That exact pipeline is saved as `clip/render.sh`; re-running it from a
checkout of this repo (plus the trailer download it describes) reproduces
`clip.mp4`. The rendered frames were inspected and the caption sizes fixed in the
session before the final render.
