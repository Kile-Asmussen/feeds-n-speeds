require 'prelude'


local modules = namespace 'modules'

modules.__loaded = false
modules.military = table.null
modules.logistics = table.null
modules.bootstrap = table.null
modules.production = table.null
modules.construction = table.null

function modules.load()
    if modules.__loaded then return end

    modules.__loaded = true
    modules.construction = require 'module.construction'
    modules.production = require 'module.production'
    modules.bootstrap = require 'module.bootstrap'
    modules.military = require 'module.military'
    modules.logistics = require 'module.logistics'

end

function modules.prototypes()

end

function modules.edits()

end


return seal_namespace(modules)