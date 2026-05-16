local instance, restore = require 'prelude.instancing'

fns_instance()

require 'prelude.table'
require 'prelude.string'
require 'prelude.fns'
require 'prelude.namespaces'
require 'prelude.functions'

function _ENV.die(str) error(str, 2) end
