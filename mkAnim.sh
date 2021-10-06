#/usr/bin/env bash

convert -delay 20 frame000*.png -scale '>800x600' -dither none -colors 32 -coalesce -layers Optimize anim.gif
