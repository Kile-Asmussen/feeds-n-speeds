
require 'prelude.table'
require 'prelude.string'
require 'prelude.fns'
require 'prelude.namespaces'
require 'prelude.functions'

_ENV.module = nil
_ENV.TESTING = false

function _ENV.die(str) error(str, 2) end