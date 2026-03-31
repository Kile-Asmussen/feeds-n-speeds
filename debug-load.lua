require('prelude')
require('testlib')
require('debuglib')
require('tweaks')

log("SETTINGS")
tweaks.settings()

log("SETTINGS-UPDATES")
tweaks.settings_updates()

log("SETTINGS-FINAL-FIXES")
tweaks.settings_final_fixes()

log("DATA")
tweaks.data()

log("DATA-UPDATES")
tweaks.data_updates()

log("DATA-FINAL-FIXES")
tweaks.data_final_fixes()