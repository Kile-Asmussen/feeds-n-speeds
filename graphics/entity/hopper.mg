#!/usr/bin/env magick-script

PNG:steel-chest.png
( +clone -crop 56x29+4+6 +repage
    ( -size 56x29 gradient:black-transparent -flip )
    -compose Over -composite )
-gravity NorthWest -geometry +4+6 -compose Over -composite
( -size 45x2 xc:black )
-gravity NorthWest -geometry +9+35 -compose Over -composite
-write hopper.png