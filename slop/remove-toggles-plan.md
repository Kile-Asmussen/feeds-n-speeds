# Plan: Remove Feature Toggles

## Current State

Each tweak and extra module has an `enabled` boolean that gets wired to a startup setting via `loading.create_toggle()` and `loading.read_toggle()`. This creates:

1. **Startup settings** in `settings.lua` for each module
2. **Early-exit checks** at the top of each lifecycle function (`if not module.enabled then return end`)
3. **Cross-module dependencies** where one module checks if another is enabled (e.g., `tweaks.electric` checks `tweaks.concrete.enabled`)

## Problems

1. **Complexity**: The toggle system adds boilerplate to every module
2. **Cross-dependencies**: Modules checking other modules' enabled state creates coupling
3. **User confusion**: Too many settings, most users want "all or nothing"
4. **Testing burden**: Each combination of toggles is a potential test case
5. **Recipe conflicts**: When features are partially enabled, recipe prerequisites can break

## Proposal

Remove all per-feature toggles. The mod is either installed or not.

## Modules Affected

### Tweaks
- `tweaks.inserter`
- `tweaks.chests`
- `tweaks.electric`
- `tweaks.nuclear`
- `tweaks.ores`
- `tweaks.concrete`
- `tweaks.sensibility`

### Extras
- `extras.chests`
- `extras.radars`

## Changes Required

### 1. Remove Settings

**File: `settings.lua`**
- Delete all `create_toggle()` calls
- File may become empty or minimal

### 2. Remove Toggle Infrastructure

**File: `loading.lua`**
- Delete `create_toggle()` function
- Delete `read_toggle()` function
- Simplify `load_stage()` to not check enabled state

### 3. Simplify Module Pattern

**Each module file:**

Before:
```lua
local module = namespace 'tweaks.example'
module.enabled = true

function module.data()
    if not module.enabled then return end
    -- actual code
end
```

After:
```lua
local module = namespace 'tweaks.example'

function module.data()
    -- actual code
end
```

### 4. Remove Cross-Module Checks

**File: `tweaks/electric.lua`**
- Remove check for `tweaks.concrete.enabled`
- Always add concrete to recipes

**File: `tweaks/nuclear.lua`**
- Remove check for `tweaks.concrete.enabled`
- Always add concrete to recipes

### 5. Update Locale

**File: `locale/en/localization.cfg`**
- Remove `[mod-setting-name]` section
- Remove `[mod-setting-description]` section

## Migration Path

1. Users with existing saves will have their settings ignored
2. No data migration needed - toggles only affect prototype loading
3. Changelog should note: "All features now always enabled"

## Verification

1. Load mod in new game - all features present
2. Load mod in existing save - no errors
3. Confirm all recipes unlockable
4. Confirm no orphaned settings in mod-settings.dat

## Future Consideration

If granular control is truly needed later, consider a single "lite mode" toggle that disables the more aggressive tweaks, rather than per-feature toggles.
