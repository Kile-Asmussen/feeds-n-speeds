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
├── settings-updates.lua  # Entry point for settings-updates stage
├── settings-final-fixes.lua # Entry point for settings-final-fixes stage
├── control.lua           # Entry point for runtime stage
├── loading.lua           # Lifecycle loader for modules
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
│   ├── earlygame.lua     # Early game recipe changes
│   ├── malltech.lua      # Mall technology restructure
│   └── timewaster.lua    # Recipe time adjustments
├── extras.lua            # Extras module coordinator
├── extras/               # New modded entities
│   ├── chests/           # Big steel chest variants + hopper
│   ├── radars/           # Small radar entity
│   ├── drills/           # Mining drill variants + wet-drilling tech
│   ├── ores/             # New ore resources (sulfur)
│   └── altrecipes/       # Alternative recipes + technologies
├── test/                 # Test stubs for control stage
│   ├── script.lua        # Event registration stub
│   ├── defines.lua       # defines.events mock
│   └── ...
├── unit-tests.lua        # Test harness entry point (sandboxed)
├── unit-tests-trusted.lua # Trusted tests (pre-sandbox)
├── unit-tests/           # Test modules
├── debug-data-raw.lua    # Vanilla data.raw inspector
├── debug-data-modded.lua # Modded data.raw inspector
├── debug-load.lua        # Module loading debugger
├── debuglib.lua          # Pretty-printer for Lua structures
├── graphics/             # Sprite assets
├── locale/en/            # Localization strings
├── build-scripts/        # Build tooling (export-ignored)
├── output/               # Build artifacts
├── slop/                 # Draft code and session logs
│   ├── LOG.md            # Session progress tracking
│   └── TODO.md           # Development task list
└── .claude/              # Claude Code safety hooks and skills
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
| `earlygame` | Early game recipe modifications (lab, etc.) |
| `malltech` | Technology restructure (uranium-processing prerequisites) |
| `timewaster` | Recipe time adjustments |

### Extras (New Entities & Features)

| Feature | Description |
|---------|-------------|
| `chests/big-steel-chest` | 2x2 chest with 96 slots, filterable slots like cargo wagon |
| `chests/big-steel-hopper` | Linked proxy container for big-steel-chest |
| `radars/small-radar` | Lower power radar without exploration, replaces radar in artillery shells |
| `drills/wet-drilling` | Technology triggered by offshore pump; enables fluid mining |
| `drills/burner-mining-drill-fluid` | Burner drill variant with fluid input for steam mining |
| `drills/electric-mining-drill-fluid` | Electric drill variant with fluid input |
| `ores/sulfur-ore` | Minable sulfur resource requiring steam (Frasch process) |
| `altrecipes/concrete-rail` | Concrete rail technology with tiered recipes |

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

## Safety Considerations

This project uses a safety harness (`.claude/settings.json` and hooks) to limit Claude's capabilities.

The operator wants to provide Claude with a high degree of autonomy, without having to be repeatedly
prompted to accept sensible actions. At the same time the operator is highly conscious of safety
considerations and wants Claude to only have autonomy to perform a certain class of useful, safe actions.

This has led to the development of the hooks suite currently installed in the `.claude/` directory.
Claude should familiarize itself with these restrictions to fully employ the allowed degree of
autonomy for maximum productivity. For this reason, hook denial messages include the allowed
patterns/commands to enable immediate course-correction without requiring Claude to search configuration files.  

The `"defaultMode": "dontAsk"` will auto-deny any tool usages not explicitly permitted, and the hooks are there to provide an extra layer of security in case the mode is erroneously changed during a session, e.g. by accepting the execution of a plan.

### Allowed Tools

- **File reading**: Read, Glob, Grep (within project directory and allowed paths, see `.claude/read-grep-glob-paths.json`)
- **File writing**: Write, Edit (only in `slop/**/*` and `unit-tests/*`)
- **File editing**: Edit (in `extras/**/*`, `tweaks/**/*`, `locale/**/*`, and `CLAUDE.md`)
- **Shell execution**: Bash (restricted to allowlist via hook, see `.claude/allowed-bash-commands.json`)
- **File deletion**: Through the `.claude/safe-rm.py` script, permitted as a shell command, which can clean up the slop/ directory
- **Web access**: WebFetch (restricted domains), WebSearch
- **Interaction**: AskUserQuestion
- **Task management**: TaskCreate, TaskGet, TaskList, TaskStop, TaskOutput, TaskUpdate
- **Scheduling**: CronCreate, CronDelete, CronList

### Denied Tools

- **Agent**: Subagent spawning disabled, due to concerns about subagents not having the same enforced
  restrictions as the parent Claude session.
- **Protected paths**: Write/Edit to `.claude/**/*` is explicitly denied as defense-in-depth measure,
  but limited editing is enabled through scripts.

### Hook Restrictions

| Hook | Effect |
|------|--------|
| `hook-restrict-read-grep-glob-paths.py` | File operations limited to project directory and Factorio's game files |
| `hook-forbid-reads-by-glob.py` | Blocks reading `**/raw.lua` (a very large, >20MB) |
| `hook-restrict-webfetch-urls.py` | WebFetch limited to Factorio-related domains (see `.claude/webfetch-urls.json`) |
| `hook-restrict-bash.py` | Bash commands must match patterns in `allowed-bash-commands.json`; shell metacharacters blocked. |
| `hook-backup-write-edit-defense.py` | last line of defense against unauthorized writes and edits |

### Allowed Bash Commands

Defined in `.claude/allowed-bash-commands.json`:
- `lua unit-tests.lua *` - Run unit tests with explicit module names from the `unit-tests/` directory
- `lua debug-load.lua` - Debug module loading
- `DEPTH=N lua debug-data-raw.lua *` - Inspect vanilla data.raw (N=1-5)
- `DEPTH=N lua debug-data-modded.lua *` - Inspect modded data.raw (N=1-5)
- `python .claude/safe-rm.py *` - Safe file deletion for cleaning up the `slop/` directory
- `.claude/fetch-factorio-research.sh` - Copy factorio-research skill to slop/ for editing
- `.claude/install-factorio-research.sh` - Install edited skill back to .claude/skills/

The `debug-data-raw` and `debug-data-modded` scripts are part of the factorio-research skill.

### Implications

- Claude can run unit tests and research scripts, but not arbitrary shell commands
- Claude can write test files directly to `unit-tests/`
- Claude can draft other code in `slop/` for operator review
- Claude can edit CLAUDE.md directly to maintain documentation
- Claude can edit the factorio-research skill via fetch/install scripts
- Claude cannot directly modify hook configuration or settings
- Claude can edit (not write) files in the `extras/`, `tweaks/`, and `locale/` directories,
  ask operator to create new template files as needed
- File reads outside the project require explicit allowlist entries
- Web documentation access limited to Factorio-related domains
