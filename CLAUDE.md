# FeedsNSpeeds - Factorio Mod

A Factorio 2.0 mod providing value tweaks, balance changes, and new items.

## Etiquette

Prefer to use passive voice and referring to the user as 'operator'.

When noting line of a code file, refer to it of the form ./file_name:line_number
so it becomes a clickable link in terminal.

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
├── unit-tests.lua        # Test harness entry point (sandboxed)
├── unit-tests-trusted.lua # Trusted tests (pre-sandbox)
├── unit-tests/           # Test modules
│   ├── table.lua         # Tests for prelude/table.lua
│   ├── string.lua        # Tests for prelude/string.lua
│   └── prelude.lua       # Tests for namespace system
├── graphics/             # Sprite assets
├── locale/en/            # Localization strings
├── build-scripts/        # Build tooling (export-ignored)
├── output/               # Build artifacts
├── slop/                 # Draft code for review
└── .claude/              # Claude Code safety hooks
```

## Architecture

### Namespace System

The mod uses a custom namespace system defined in `prelude.lua`:

- `namespace(path, tbl?)` - Creates a new namespace (optionally from existing table)
- `import(path)` - Retrieves a declared namespace
- `fns(name)` - Generates mod-prefixed identifiers (`feeds-n-speeds-{name}`)
- `isnamespace(thing)` - Type check for namespaces (sealed or unsealed)

Namespaces can be sealed after initialization via `__seal()` to prevent accidental modification.

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
make test       # Run unit tests via unit-tests.lua
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

Key functions: `table.new()`, `table.null`, `table.matches()`, `table.find_matching()`, `table.descend()`, `table.clone()`, `table.traverse()`, `table.set()`, vector operations (`table.add()`, `table.scale()`, `table.vecadd()`, `table.vecmul()`)

### prelude/string.lua

Key functions: `string.lpad()`, `string.rpad()`, `string.predicate()`, `string.sprint()`, `string.chomp()`

### debuglib.lua

Pretty-printer for Lua data structures with recursion limiting and cycle detection. Controlled by `DEPTH` environment variable.

## Conventions

- All mod identifiers use `fns()` prefix: `feeds-n-speeds-{name}`
- Entity definitions split across `-building.lua`, `-item.lua`, `-recipe.lua`, `-remnants.lua`, `-explosion.lua`
- Cross-module references use `import()` to access other namespaces
- Settings interact: e.g., `tweaks.concrete.enabled` affects `tweaks.electric` and `tweaks.nuclear` recipes

## Testing

### Test Harness

Unit tests are run via `unit-tests.lua`, a sandboxed test harness:

```bash
lua unit-tests.lua table string prelude    # Run specific test modules
```

Test files in `unit-tests/` use global functions defined by the harness:
- `fact(description, fn)` - Register test expected to pass
- `fiction(description, fn)` - Register test expected to error
- `assert_eq(a, b)` - Assert equality
- `assert_ok(val)` - Assert truthy
- `assert_is(val, type)` - Assert type

### Sandboxing

The test harness sandboxes test code by nil'ing dangerous globals (`io`, `os`, `debug`, `load`, etc.) after loading trusted modules. This allows Claude to write tests autonomously with reduced risk.

`unit-tests-trusted.lua` contains tests requiring privileged functions (e.g., `setmetatable`) and runs before the sandbox is applied.

### Coverage

112 tests covering `prelude/table.lua`, `prelude/string.lua`, and namespace system.

## Reference Materials

The `references/` sibling directory contains example Factorio mods for reference:
- 2x2-Chest, Smart_Inserters, SimpleAdjustableInserters
- NuclearTweaks, ChemicalConcrete, CrushBrickToStone
- auto_sort_chests, zzzzStopChasingBeltItems

## API Documentation

Factorio Lua API docs: https://lua-api.factorio.com (version 2.0.x)

## Skills

### /factorio-research

Skill for researching Factorio prototypes by inspecting live `data.raw` structures.

**When to use:**
- Before modifying or creating prototypes
- When unsure about field names, types, or valid values
- To find examples of vanilla implementations

**Workflow:**
1. List prototype categories: `DEPTH=1 lua debug-data-raw.lua`
2. Inspect category: `DEPTH=1 lua debug-data-raw.lua <category>`
3. Drill into prototype: `DEPTH=3 lua debug-data-raw.lua <category> <name>`
4. Cross-reference API docs via WebFetch

See `.claude/skills/factorio-research/SKILL.md` for full documentation.

## Claude Code Restrictions

This project uses a safety harness (`.claude/settings.json` and hooks) to limit Claude's capabilities.

### Allowed Tools

- **File reading**: Read, Glob, Grep (within allowed paths)
- **File writing**: Write, Edit (in `slop/**/*` and `unit-tests/*`)
- **Shell execution**: Bash (restricted to allowlist via hook)
- **Web access**: WebFetch (restricted domains), WebSearch
- **Interaction**: AskUserQuestion
- **Task management**: TaskCreate, TaskGet, TaskList, TaskStop, TaskOutput, TaskUpdate

### Denied Tools

- **Agent**: Subagent spawning disabled
- **Protected paths**: Write/Edit to `.claude/**/*`

### Hook Restrictions

| Hook | Effect |
|------|--------|
| `hook-restrict-read-grep-glob-paths.py` | File operations limited to project directory and `../references/` |
| `hook-forbid-reads-by-glob.py` | Blocks reading `**/raw.lua` and `**/too-big.txt` (large files) |
| `hook-restrict-webfetch-urls.py` | WebFetch limited to `lua-api.factorio.com` |
| `hook-restrict-bash.py` | Bash commands must match patterns in `allowed-bash-commands.json`; shell metacharacters blocked |

### Allowed Bash Commands

Defined in `.claude/allowed-bash-commands.json`:
- `lua unit-tests.lua *` - Run unit tests with explicit module names
- `lua debug-load.lua` - Debug module loading
- `lua debug-data-raw.lua *` - Inspect data.raw

### Implications

- Claude can run unit tests but not arbitrary shell commands
- Claude can write test files directly to `unit-tests/`
- Claude can draft other code in `slop/` for operator review
- Claude cannot modify hook configuration or settings
- File reads outside the project require explicit allowlist entries
- Web documentation access limited to Factorio Lua API
