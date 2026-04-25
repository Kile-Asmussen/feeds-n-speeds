# FeedsNSpeeds - Factorio Mod

A Factorio 2.0 mod providing value tweaks, balance changes, and new items.

## Etiquette and User Profile

- Name: Kashmira Qeel
- Pronouns: she/her/hers/herself
- Preferred mode of address: Operator
- Nationality: Dane
- Education: master's degree in computer science
- Experience: 5 years employment as software developer
- Programming languages: Lua, Python, Rust, Bash, several others

## Architecture

The project is split into `extras`, which contains new game objects, while `tweaks` contains changes to existing game objects.

### Namespace System

The mod uses a custom namespace system defined in `prelude.lua`:

- `namespace(path)` - Creates a new namespace
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
- Implicitly creates an in-game mod setting with the `enabled = true` line
- Implements lifecycle functions: `data()`, `data_updates()`, `data_final_fixes()`
- Seals itself with `return module:__seal()`

### Lifecycle Stages

Factorio mod loading stages, each with corresponding entry points:

- `settings.lua` -- create new settings
- `settings-updates.lua` -- unused
- `settings-final-fixes.lua` -- unused
- `data.lua` -- load new prototypes (chiefly `extras`)
- `data-updates.lua` -- modify existing prototypes (chiefly `tweaks`)
- `data-final-fixes.lua` -- extreme last resort (only `tweaks.ores`)
- `control.lua`

## Utilities

### Sandboxing

The test harness sandboxes test code by nil'ing dangerous globals (`io`, `os`, `debug`, `load`, etc.) after loading trusted modules. This allows Claude to write tests autonomously with reduced risk.

`unit-tests-trusted.lua` contains tests requiring privileged functions (e.g., `setmetatable`) and runs before the sandbox is applied.

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

There are five hooks:
- Read/grep/glob access to the current project directory and a select others, see `.claude/read-grep-glob-paths.json` for a list.
- Bash tool restricted to only a set list of allowed commands, see `.claude/bash-commands.json` for the list.
- Read/grep (with output) access is prevent for certain files (currently none)
- WebFetch is limited to only a set list of allowed domains, see `.claude/webfetch-urls.json` for the full list. 
- One as a defense-in-depth safeguard against edits or writes that claude shouldn't do anyway.

Hook denial messages include the allowed patterns/commands to enable immediate course-correction without requiring Claude to search configuration files.  

The `"defaultMode": "dontAsk"` will auto-deny any tool usages not explicitly permitted, and the hooks are there to provide an extra layer of security in case the mode is erroneously changed during a session, e.g. by accepting the execution of a plan.

### Access

Claude has free edit/write access to the following directories:

- `unit-tests/` for setting up a test suite
- `slop/` for notes and tracking progress
- All subdirectories of `extras/`
- All subdirectories of `tweaks/`
- All subdirectories of `locale/`

Claude has edit rights (not writing rights) to files in `extras/` and `tweaks/`

Claude can edit CLAUDE.md

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
