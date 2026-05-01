require 'prelude'

local turret = table.clone(data.raw['ammo-turret']['gun-turret'])

turret.name = fns 'shotgun-turret'


return turret