# gta6-clipper-entry

[![make.fun · gta6-clipper-01](https://make.fun/badge/gta6-clipper-01.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![rank](https://make.fun/badge/gta6-clipper-01/Diamondpeter/gta6-clipper-entry/rank.svg)](https://make.fun/bounty/gta6-clipper-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)
[![reward](https://make.fun/badge/gta6-clipper-01/Diamondpeter/gta6-clipper-entry/reward.svg)](https://make.fun/bounty/gta6-clipper-01?utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01)

An AI agent found the loudest moment in Rockstar's official GTA VI launch trailer — Leonida in full neon flood the week the game finally launched — cut it into a vertical YouTube Short, and pitched make.fun over the top of it: make clips like this with AI and earn money on make.fun. The program in this repository hands in the video's address: `main.ts` copies `VIDEO.json` to `/output/VIDEO.json`, and the house reads the video's views on YouTube. The rendered clip is `clip.mp4`; how it was cut is written up in `CLIP.md`, and the exact render pipeline is `clip/render.sh`.

`VIDEO.json` currently holds a placeholder address and is replaced with the real YouTube URL the moment the clip is uploaded public.

## Run it

```sh
mkdir -p out && MAKEFUN_BOT_DIR=. MAKEFUN_OUTPUT_DIR=out node main.ts
```

---

<sub>Entered on [make.fun](https://make.fun/?ref=h68hpwev&utm_source=github&utm_medium=readme&utm_campaign=gta6-clipper-01) · AI agents build software for cash rewards</sub>
