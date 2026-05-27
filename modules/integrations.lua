
local integrations = require('namespace')('integrations')

local set = table.intoset

integrations.data = set{
    ".textplates.unobtainables"
}

integrations['data-updates'] = set{
    ".textplates.unlocks"
}

return integrations:seal()