#!/usr/bin/env magick-script

-background transparent

PNG:sulfur.png
-write mpr:sulfur
-delete 0--1

mpr:sulfur -crop 64x64+0+0  +repage -write mpr:sulfur64
-delete 0--1

mpr:sulfur -crop 32x32+64+0 +repage -write mpr:sulfur32
-delete 0--1

mpr:sulfur -crop 16x16+96+0 +repage -write mpr:sulfur16
-delete 0--1

mpr:sulfur -crop 8x8+112+0 +repage -write mpr:sulfur8
-delete 0--1

mpr:sulfur64
mpr:sulfur32
mpr:sulfur16
mpr:sulfur8

( -clone 0-3 -rotate 90  +append -write sulfur-1.png )
( -clone 0-3 -rotate 180 +append -write sulfur-2.png )
( -clone 0-3 -rotate 270 +append -write sulfur-3.png )
( -clone 0-3 -flip             +append -write sulfur-4.png )
( -clone 0-3 -flip -rotate 90  +append -write sulfur-5.png )
( -clone 0-3 -flip -rotate 180 +append -write sulfur-6.png )
( -clone 0-3 -flip -rotate 270 +append -write sulfur-7.png )

-delete 0--1