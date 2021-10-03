#/usr/bin/env bash

convert -delay 20 frame000*.png -scale '>800x600' -colors 8 -coalesce -layers Optimize anim.gif
