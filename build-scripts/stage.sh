#! /usr/bin/env bash

for stage in settings data data-updates control; do

lua <<END > ./$stage.lua
require('modules').print_stage '$stage'
END

done