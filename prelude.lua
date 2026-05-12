
require 'prelude.table'
require 'prelude.string'
require 'prelude.fns'
require 'prelude.namespaces'
require 'prelude.functions'

_G.module = nil
_G.TESTING = false

function _G.die(str) error(str, 2) end