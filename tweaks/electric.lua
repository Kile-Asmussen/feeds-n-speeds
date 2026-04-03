require 'prelude'

local electric = namespace('tweaks.electric')

electric.toggle = 'feeds-n-speeds-tweaks-electric-enable'
electric.enabled = true

function electric.data_updates()

    if not electric.enabled then return end

    local electric_pole = data.raw['electric-pole']

    local small = electric_pole['small-electric-pole']
    local medium = electric_pole['medium-electric-pole']
    local big = electric_pole['big-electric-pole']
    local substation = electric_pole.substation

    small.maximum_wire_distance = 9.5
    medium.maximum_wire_distance = 15.5
    big.maximum_wire_distance = 60
    substation.maximum_wire_distance = 25
end

return electric:__seal()