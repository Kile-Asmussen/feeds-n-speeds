require('testlib')

require('debuglib')
require('table-upgrades')

require('tweaks')

tweaks.settings()
tweaks.settings_updates()
tweaks.settings_final_fixes()

tweaks.data()
tweaks.data_updates()
tweaks.data_final_fixes()

-- debuglib.print(table.descend(data.raw, ...))