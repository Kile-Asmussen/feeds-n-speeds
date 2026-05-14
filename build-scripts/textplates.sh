#! /usr/bin/env bash

(
    cd ./graphics/textplates

    typst compile textplates.typ 0.png --format png 
)