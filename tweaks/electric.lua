require 'prelude'

tweaks = tweaks or {}
tweaks.electric = tweaks.electric or {}

tweaks.electric.toggle = 'feeds-n-speeds-tweaks-electric-enable'
tweaks.electric.enabled_by_default = true

function tweaks.electric.data_updates()

    if not tweaks.electric.enabled then
        log("Electric tweaks disabled")
        return
    end

    log("Electric tweaks enabled")

    local electric_pole = data.raw['electric-pole']

    local small = electric_pole['small-electric-pole']
    local medium = electric_pole['medium-electric-pole']
    local big = electric_pole['big-electric-pole']
    local substation = electric_pole.substation

    small.maximum_wire_distance = 8
    medium.maximum_wire_distance = 10
    big.maximum_wire_distance = 50
    substation.maximum_wire_distance = 25
end