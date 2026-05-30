--! data, data-updates: submodule governing integrations with other mods, currently only the textplates family

local integrations = require('namespace')('integrations')

local set = table.intoset

integrations.data = set{
    ".textplates.unobtainables"
}

integrations['data-updates'] = set{
    ".textplates.unlocks"
}

return integrations:seal()