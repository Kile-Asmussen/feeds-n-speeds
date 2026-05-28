#!/usr/bin/env magick-script

PNG:steel-chest.png
( +clone -crop 47x27+9+6 +repage
    ( -size 47x27 gradient:black-transparent -flip )
    -compose Over -composite )
-gravity NorthWest -geometry +9+6 -compose Over -composite
( +clone -crop 24x13+68+3 +repage
    ( -size 24x13 gradient:black-transparent -flip )
    -compose Over -composite )
-gravity NorthWest -geometry +68+3 -compose Over -composite
( +clone -crop 13x6+98+2 +repage
    ( -size 13x6 gradient:black-transparent -flip )
    -compose Over -composite )
-gravity NorthWest -geometry +98+2 -compose Over -composite
( +clone -crop 6x4+113+1 +repage
    ( -size 6x4 gradient:black-transparent -flip )
    -compose Over -composite )
-gravity NorthWest -geometry +113+1 -compose Over -composite
-write hopper.png