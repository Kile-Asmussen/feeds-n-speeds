--! data: balance tweaks for guns
local gun = data.raw.gun

gun.pistol.attack_parameters.cooldown = 20
gun.pistol.attack_parameters.damage_modifier = 1.5

gun.shotgun.attack_parameters.cooldown = 80
gun.shotgun.attack_parameters.damage_modifier = 1.5
gun.shotgun.attack_parameters.movement_slow_down_factor = 0.3

gun['submachine-gun'].attack_parameters.cooldown = 10
gun['submachine-gun'].attack_parameters.movement_slow_down_factor = 0.4
gun['submachine-gun'].attack_parameters.damage_modifier = 1.2

gun['combat-shotgun'].attack_parameters.cooldown = 40
gun['combat-shotgun'].attack_parameters.damage_modifier = 1.2
gun['combat-shotgun'].attack_parameters.movement_slow_down_factor = 0.5
