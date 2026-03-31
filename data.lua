require('tweaks')
require('debuglib')

log(string.sprint(
    'SETTINGS', debuglib.sprint(settings.startup)
))

tweaks.data()