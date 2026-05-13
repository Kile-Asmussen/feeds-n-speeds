#! /usr/bin/env bash

(
    cd ./graphics/textplates

    typst compile --format png textplates.typ
)