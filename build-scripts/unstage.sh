#! /usr/bin/env bash

for stage in settings data data-updates control; do

cat <<END >  ./$stage.lua
require('modules').load_stage '$stage'
END

done