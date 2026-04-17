# FeedsNSpeeds - Factorio Mod

A Factorio 2.0 mod providing value tweaks, balance changes, and new items.

## Project Structure

```
FeedsNSpeeds/
├── data.lua              # Entry point for data stage
├── data-updates.lua      # Entry point for data-updates stage
├── data-final-fixes.lua  # Entry point for data-final-fixes stage
├── settings.lua          # Entry point for settings stage
├── prelude.lua           # Core module loader (namespace system)
├── prelude/              # Baseline utilities
│   ├── table.lua         # Table manipulation functions
│   └── string.lua        # String utilities
├── tweaks.lua            # Tweaks module coordinator
├── tweaks/               # Game value modifications
│   ├── inserter.lua      # Inserter speed/behavior tweaks
│   ├── chests.lua        # Chest inventory rebalancing
│   ├── electric.lua      # Electric pole reach extensions
│   ├── nuclear.lua       # Nuclear power ratio fixes
│   ├── ores.lua          # Infinite ore modifications
│   ├── concrete.lua      # Concrete recipe importance
│   └── ...
├── extras.lua            # Extras module coordinator
├── extras/               # New modded entities
│   ├── chests/           # Big steel chest variants
│   └── radars/           # Small radar entity
├── graphics/             # Sprite assets
├── locale/en/            # Localization strings
├── build-scripts/        # Build tooling (export-ignored)
├── output/               # Build artifacts
└── .claude/              # Claude Code safety hooks
```

## Architecture

### Namespace System

The mod uses a custom namespace system defined in `prelude.lua`:

- `namespace(path)` - Creates a new sealed namespace
- `import(path)` - Retrieves a declared namespace
- `fns(name)` - Generates mod-prefixed identifiers (`feeds-n-speeds-{name}`)
- `isnamespace(thing)` - Type check for namespaces

Namespaces are sealed after initialization via `__seal()` to prevent accidental modification.

### Module Pattern

Both `tweaks` and `extras` follow an identical pattern:

1. **Coordinator module** (`tweaks.lua`, `extras.lua`) - Loads submodules and provides lifecycle methods
2. **Domain modules** (`tweaks/inserter.lua`, `extras/chests.lua`) - Individual feature implementations
3. **Loading system** (`loading.lua`) - Executes lifecycle methods across all domains by priority

Each domain module:
- Declares a namespace (e.g., `namespace 'tweaks.inserter'`)
- Sets `enabled = true` (toggleable via settings)
- Implements lifecycle functions: `data()`, `data_updates()`, `data_final_fixes()`
- Seals itself with `return module:__seal()`

### Lifecycle Stages

Factorio mod loading stages, each with corresponding entry points:

| Stage | Entry Point | Purpose |
|-------|-------------|---------|
| settings | `settings.lua` | Define mod settings |
| data | `data.lua` | Define new prototypes |
| data-updates | `data-updates.lua` | Modify existing prototypes |
| data-final-fixes | `data-final-fixes.lua` | Final adjustments after all mods |

### Settings Integration

Domains with `enabled` boolean get automatic startup settings via `loading.create_toggle()`. Settings are read back via `loading.read_toggle()` before each lifecycle stage.

## Features

### Tweaks (Game Value Modifications)

| Tweak | Description |
|-------|-------------|
| `inserter` | Yellow inserter speed parity, burner leech, disable belt chasing |
| `chests` | Rebalanced inventory sizes (wooden:9, iron:19, steel:29) |
| `electric` | Extended pole reach (small:9.5, medium:15.5, big:50, substation:25) |
| `nuclear` | Smart reactor scaling, adjusted ratios (1 reactor : 5 HX), 50% neighbor bonus |
| `ores` | Infinite ores with richness based on map settings |
| `concrete` | Makes concrete prerequisite for advanced infrastructure |

### Extras (New Entities)

| Entity | Description |
|--------|-------------|
| `big-steel-chest` | 2x2 chest with 96 slots, unlocked via steel-processing |
| `smart-big-steel-chest` | variant of the above with filterable slots like a cargo wagon |
| `big-steel-hopper` | Linked chest variant (functionality pending) |
| `small-radar` | Lower power radar without exploration, replaces radar in artillery shells |

## Build System

### Prerequisites (via Nix Flake)

- lua, jq, gnumake, ripgrep, wget, python3.14

### Commands

```bash
make build      # Create distributable zip via git archive
make test       # Run test-*.lua files
make install    # Copy to ~/.factorio/mods
make uninstall  # Remove from ~/.factorio/mods
make nuke       # Uninstall + remove mod-settings.dat
```

### Distribution

`.gitattributes` marks files for exclusion from the distribution zip:
- Build tooling, tests, debug files
- Source graphics (`.xcf`)
- Nix/direnv configuration
- `.claude/` safety hooks

## Utilities

### prelude/table.lua

Key functions: `table.new()`, `table.null`, `table.matches()`, `table.find_matching()`, `table.descend()`, `table.clone()`, `table.traverse()`, vector operations (`table.add()`, `table.scale()`)

### prelude/string.lua

Key functions: `string.lpad()`, `string.rpad()`, `string.predicate()`, `string.sprint()`

### debuglib.lua

Pretty-printer for Lua data structures with recursion limiting and cycle detection. Controlled by `DEPTH` environment variable.

## Conventions

- All mod identifiers use `fns()` prefix: `feeds-n-speeds-{name}`
- Entity definitions split across `-building.lua`, `-item.lua`, `-recipe.lua`, `-remnants.lua`, `-explosion.lua`
- Cross-module references use `import()` to access other namespaces
- Settings interact: e.g., `tweaks.concrete.enabled` affects `tweaks.electric` and `tweaks.nuclear` recipes

## Testing

Local Lua tests run via `make test` or `./build-scripts/test.sh`. Test files match `test-*.lua` pattern.

Currently tests are not well covered.

Manual sanity-checking is done with `debug-load.lua` prior to loading mod into Factorio itself.

## Reference Materials

The `references/` sibling directory contains example Factorio mods for reference:
- 2x2-Chest, Smart_Inserters, SimpleAdjustableInserters
- NuclearTweaks, ChemicalConcrete, CrushBrickToStone
- auto_sort_chests, zzzzStopChasingBeltItems

## API Documentation

Factorio Lua API docs: https://lua-api.factorio.com (version 2.0.x)
