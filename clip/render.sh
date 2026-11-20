#!/bin/sh
# render.sh — the exact pipeline that produced ../clip.mp4, run end to end in the
# agent session that built this entry. Re-running it reproduces the clip.
#
# Inputs fetched/generated in the session:
#   1. Rockstar's official GTA VI Launch Trailer (YouTube rz1B4B2yBZY):
#        yt-dlp -f "bv*[height<=1080][ext=mp4]+ba[ext=m4a]/b[height<=1080]" \
#          --merge-output-format mp4 -o "launch-trailer.%(ext)s" \
#          "https://www.youtube.com/watch?v=rz1B4B2yBZY"
#   2. voiceover.mp3 — text-to-speech of:
#        "This clip was cut by an AI agent. Make clips like this with AI,
#         and earn money on make dot fun."
#      (committed beside this script; 5.95s, mixed in at 13.2s below)
#
# Structure: 0-5.7s trailer 71.3-77.0 (sniper -> Lucia explosion -> logo),
# 5.7-12.2s trailer 16.8-23.3 (neon skyline, lowriders), 12.2-21.2s the skyline
# slowed to half speed and dimmed under the pitch lines + voiceover,
# 21.2-25.2s black make.fun end card. Landscape footage is blur-filled to 9:16.
set -e
cd "$(dirname "$0")"
FONT=/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf
ffmpeg -y -i launch-trailer.mp4 -i voiceover.mp3 -filter_complex "
[0:v]split=3[srcA][srcB][srcC];
[srcA]trim=71.3:77.0,setpts=PTS-STARTPTS,fps=30,split[a1][a2];[a1]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45[abg];[a2]scale=1080:-2[afg];[abg][afg]overlay=(W-w)/2:(H-h)/2,drawtext=fontfile=$FONT:text='GTA 6 IS FINALLY HERE':fontsize=80:fontcolor=white:borderw=7:bordercolor=black:box=1:boxcolor=black@0.35:boxborderw=26:x=(w-text_w)/2:y=170:enable='between(t,0,3.4)',drawtext=fontfile=$FONT:text='AND IT LOOKS INSANE':fontsize=64:fontcolor=0x4DE3FF:borderw=6:bordercolor=black:box=1:boxcolor=black@0.35:boxborderw=22:x=(w-text_w)/2:y=300:enable='between(t,0.7,3.4)',setsar=1[vA];
[srcB]trim=16.8:23.3,setpts=PTS-STARTPTS,fps=30,split[b1][b2];[b1]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45[bbg];[b2]scale=1080:-2[bfg];[bbg][bfg]overlay=(W-w)/2:(H-h)/2,drawtext=fontfile=$FONT:text='WELCOME BACK TO LEONIDA':fontsize=70:fontcolor=white:borderw=7:bordercolor=black:box=1:boxcolor=black@0.35:boxborderw=24:x=(w-text_w)/2:y=170:enable='between(t,0.4,5.6)',setsar=1[vB];
[srcC]trim=16.8:21.3,setpts=2.0*(PTS-STARTPTS),fps=30,split[c1][c2];[c1]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,gblur=sigma=45[cbg];[c2]scale=1080:-2[cfg];[cbg][cfg]overlay=(W-w)/2:(H-h)/2,eq=brightness=-0.30:saturation=0.6,drawtext=fontfile=$FONT:text='This clip was cut by an AI agent':fontsize=66:fontcolor=white:borderw=6:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=760:enable='between(t,0.5,3.8)',drawtext=fontfile=$FONT:text='Make clips like this with AI':fontsize=72:fontcolor=white:borderw=6:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=730:enable='between(t,3.3,8.5)',drawtext=fontfile=$FONT:text='and EARN MONEY on make.fun':fontsize=72:fontcolor=0xFFD23F:borderw=6:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=24:x=(w-text_w)/2:y=850:enable='between(t,3.3,8.5)',drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=54:fontcolor=0x4DE3FF:borderw=5:bordercolor=black:box=1:boxcolor=black@0.45:boxborderw=20:x=(w-text_w)/2:y=1010:enable='between(t,6.0,9.0)',setsar=1[vC];
color=c=black:s=1080x1920:r=30:d=4.0,drawtext=fontfile=$FONT:text='make.fun':fontsize=170:fontcolor=white:x=(w-text_w)/2:y=760,drawtext=fontfile=$FONT:text='Earn money making clips with AI':fontsize=58:fontcolor=0xFFD23F:x=(w-text_w)/2:y=990,drawtext=fontfile=$FONT:text='make.fun/bounty/gta6-clipper-01':fontsize=50:fontcolor=0x4DE3FF:x=(w-text_w)/2:y=1100,setsar=1[vD];
[vA][vB][vC][vD]concat=n=4:v=1:a=0[vout];
[0:a]asplit=4[aA][aB][aC][aD];
[aA]atrim=71.3:77.0,asetpts=PTS-STARTPTS,volume=0.85,afade=t=in:st=0:d=0.25,afade=t=out:st=5.3:d=0.4[aa];
[aB]atrim=16.8:23.3,asetpts=PTS-STARTPTS,volume=0.85,afade=t=in:st=0:d=0.3,afade=t=out:st=6.1:d=0.4[ab];
[aC]atrim=34.0:43.0,asetpts=PTS-STARTPTS,volume=0.15[ac];
[aD]atrim=43.0:47.0,asetpts=PTS-STARTPTS,volume=0.15,afade=t=out:st=2.0:d=2.0[ad];
[aa][ab][ac][ad]concat=n=4:v=0:a=1[base];
[1:a]adelay=13200:all=1,volume=1.1[vo];
[base][vo]amix=inputs=2:duration=first:dropout_transition=0,alimiter=limit=0.95[aout]
" -map "[vout]" -map "[aout]" -c:v libx264 -preset veryfast -crf 20 -pix_fmt yuv420p -c:a aac -b:a 160k -movflags +faststart ../clip.mp4
