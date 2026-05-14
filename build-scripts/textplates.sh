#! /usr/bin/env bash

(
    cd ./graphics/textplates

    typst compile textplates.typ plastic.png --format png --input fill=plastic
    typst compile textplates.typ concrete.png --format png --input fill=concrete
)