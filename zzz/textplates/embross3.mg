#!/usr/bin/env magick-script

#input
PNG:fd:0 -write mpr:plate
-alpha extract -alpha off -write mpr:alpha

-delete 0--1

mpr:alpha ( +clone -morphology Erode Disk:10 -write mpr:inline -negate ) -compose Multiply -flatten
-write mpr:outline

-delete 0--1

mpr:alpha
mpr:outline
mpr:inline

-distort Perspective
' 0,0 1,0     256,0 255,0    256,256 258,256    0,256 -2,256 '

( -clone 0 -write mpr:alpha_p )
( -clone 1 -write mpr:outline_p )
( -clone 2 -write mpr:inline_p )

-delete 0--1

mpr:alpha_p -colorize 10%

( +clone -fill black -colorize 15%
-distort Affine ' 0,0 0,1.5 '
-morphology Dilate Disk:1 )

( +clone -fill black -colorize 20%
-distort Affine ' 0,0 0,1.5 '
-morphology Dilate Disk:1 )

( +clone -fill black -colorize 30%
-distort Affine ' 0,0 0,1.5 '
-morphology Dilate Disk:1 )

( +clone -fill black -colorize 45%
-distort Affine ' 0,0 0,1.5 '
-morphology Dilate Disk:1 )

-reverse

mpr:outline_p

-background black
-compose Lighten -flatten

-write mpr:stack

-delete 0--1

mpr:stack
-shade 160x60
-write mpr:shaded

-delete 0--1

mpr:stack -threshold 1%
-write mpr:mask

-delete 0--1

mpr:shaded
-write-mask mpr:mask
-fill black -colorize 100%
+write-mask
-write mpr:blocky

-delete 0--1

mpr:blocky

( PNG:./copper-plate.png
-write-mask mpr:mask
-fill black -colorize 100%
+write-mask
-fill white -colorize 10% )



-compose Interpolate -flatten
-auto-level
-write show:
