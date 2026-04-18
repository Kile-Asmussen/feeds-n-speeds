# Patch: Enable debuglib tests

To run the debuglib regression tests in `unit-tests/debuglib.lua`, apply these changes to `unit-tests.lua`:

## 1. Add debuglib to allowed namespaces (around line 26)

```lua
local allowed_namespaces = table.set {
    'prelude.table',
    'prelude.string',
    'debuglib',  -- ADD THIS LINE
}
```

## 2. Require debuglib before sandboxing (after line 15)

```lua
require 'prelude'
require 'debuglib'  -- ADD THIS LINE
```

This must be done before sandboxing because debuglib uses `setmetatable` when it loads.
