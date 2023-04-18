# mp4 -> gif
ffmpeg -ss 30 -t 3 -i input.mp4 \
  -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
  -loop 0 output.gif

"""
https://superuser.com/a/556031 - How do I convert a video to GIF using ffmpeg, with reasonable quality?
-ss: start second
-t: duration

scale=<height_px>:<width_px>:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse
  : '-1' can be used in either height or width
    copy paste flags

-loop: 0: infinite
       n: n loops = play (n+1) times
      -1: no loop
"""
