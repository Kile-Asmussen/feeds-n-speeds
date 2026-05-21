# FeedsNSpeeds - Factorio Mod

A Factorio 2.0 overhaul mod providing value tweaks, balance changes, and new items.

A factorio-research skill is available.

Primary programming language: Lua
Supplementary utilities: Rust, Bash, Makefile
Claude hooks: Python

## User Profile

- Name: Kashmira Qeel
- Pronouns: she/her
- Background: CS master's, 5 years professional software development, fluent in Lua/Python/Rust/Bash

## Permissions

### What I can do without asking

- **Read** anything in this project directory.
- **Edit** files in  `locale/**/*`, `slop/**/*`, as well as `CLAUDE.md`
- **Write** (create) files in `slop/**/*`
- **Run** the specific Bash commands listed in `.claude/bash-commands.json` (see below)
- **WebFetch** from `lua-api.factorio.com`, `wiki.factorio.com`, `forums.factorio.com`, `mods.factorio.com`, `github.com/wube/factorio-data/*`, `raw.githubusercontent.com/wube/factorio-data/*`

### What I must ask the user to do

- **Modify hook or settings configuration** — `.claude/` is fully off-limits for edits and writes.
- **Add new allowed Bash commands** — user must update `.claude/bash-commands.json`.
- **Read files outside the project** that aren't in the allowlist (e.g. new system paths).
- **Fetch from new web domains** — user must update `.claude/webfetch-urls.json`.

### Allowed Bash commands

Exact patterns:

```
lua debug/load.lua
DEPTH=[1-3] lua debug/data-raw.lua [<category> [<name> [<further properties/indexes>]]]
DEPTH=[1-3] lua debug/data-modded.lua [<category> [<name> [<further properties/indexes>]]] 
lua unit-tests.lua <module-name>
python .claude/safe-rm.py <path>
.claude/factorio-research.sh fetch
.claude/factorio-research.sh install
```
The debug/data-raw.lua and debug/data-modded.lua scripts will only print DEPTH=1 until a specific prototype is requested, to limit token usage.

**Important:** The bash hook rejects pipes (`|`), redirects (`>`/`<`), chained commands (`&&`, `;`, `||`), subshells, and glob characters in the command string. Commands must match the pattern exactly. When a command is blocked, the error message lists the allowed patterns — use that to self-correct immediately.

## Architecture

The project built around `module.lua` and the `module/` directory, which contains a full module loading system with dependency ordering, loading specific lua files. Currely a migration is ongoing, with `zzz/` containing the old code.

### Namespace System (`namespace.lua`)

- `let foo = namespace('foo')` — declares a new namespace; errors on duplicate
- `namespace.import('foo')` — retrieves a declared namespace; errors if not found
- `foo:require 'bar'` — requires `'foo.bar'` and assigns it to `foo.bar`
- `return foo:seal()` — makes namespace read-only

### Instancing and isolation

In `fns.lua` a namespace is declared, with functionality to isolate this mod from other mods.

- `fns.use()` replaces the global namespaces `string`, `table`, etc. with their default versions from Lua 5.2, removing access to any factorio-specific functions (chiefly `core/lualib`) and also changes the `getmetatable("").__index` to the new `string` namespace, allowing the use of new functions. `fns.restore()` undoes these changes.
- In the instanced version of these namespaces, new utility functions are declared, see the `fns/` directory.
- Instanced namespaces are also available as `fns.table`, `fns.string`, etc.
- In non-performance-critical code (data stages) calling `fns.use()` at the top of the file is acceptable.
- In the control stage, care must be taken to remain isolated, and so calling `fns.use()` and `fns.restore()` is necessary in each function body. Therefore prefer directly using `fns.table`, `fns.string`, etc.

Game object identifiers are generated via `fns.name()` or its alias via operator overloading, `fns()`, which prepends `feeds-n-speeds-` to any given string, making collisions with other mods unlikely.

### Module Pattern

1. **Coordinator** (`module.lua`) — requires submodules listed in each stage, performs dependency ordering, requires each file in that order.
2. **Domain modules** (`module/`) — individual features, `production`, `construction`, etc.
3. **Loading system** (`loading.lua`) — calls lifecycle methods across all domains, sorted by `priority`

Each domain module:
- Declares `local some_domain = namespace 'module.some-domain'`
- Declares `some_domain.data`, `some_domain['data-updates']` and other properties as dependency graphs of this stage
- Returns `some_domain:seal()`.

The dependency graphs are declared with the `asset` function, a pun on "as set" since it removes the numbered
keys from a table and inserts their string values as named keys, set to `true`. This data format is used in `module.lua`.

Each entry in the dependency graphs are either fully qualified require paths or start with `.` and are assumed to be
local to the submodule, prefixed with the submodule require path in `module.load_stage`.

The individual required files have no special formatting, just execute as lua code.

### Lifecycle Stages

Each lifecycle stage calls `modules.load_stage '<stage-name>'`

- `settings.lua` — loads a few files in the `models.utility` namespace
- `data.lua` — load new prototypes
- `data-updates.lua` — modify existing prototypes (chiefly `tweaks`)
- `control.lua` — runtime event handlers

Other stages are unused.

## Testing

### Debug scripts

- `lua debug/load.lua` — runs the full settings → data → control pipeline and prints missing localization strings at the end
- `DEPTH=N lua debug/data-raw.lua [category [name [additional properties]]]` — inspect vanilla `data.raw`
- `DEPTH=N lua debug/data-modded.lua [category [name [additional properties]]]` — inspect `data.raw` after mod changes

The simulated pipeline is imperfect: it does not include full consistency checks, and does not account for staging of
the vanilla mods -- for instance auto-generation of recycling and barelling recipes.

## Localization

- Locale file: `locale/en/localization.cfg`
- Run `lua debug/load.lua` to find missing strings — it prints stubs for anything registered via `data:extend` that isn't in the locale file
- `fns.locale_key(category, name)` registers the name under `category` for localization tracking; `fns(name)` only registers it in `mod_identifiers`, not in any named category — the localization checker finds it via `localization.keys` instead
- Noise expressions (`noise-expression` type) are internal and their entity-name/description entries are never shown to players, but the localization checker flags them anyway — fill them with internal-facing descriptions

## Skills

### /factorio-research

Inspects live `data.raw` structures from the installed game.

Use before modifying or creating prototypes, or when unsure about field names/types/valid values.

```
DEPTH=1 lua debug/data-raw.lua                    # list all prototype categories
DEPTH=1 lua debug/data-raw.lua <category>         # list entries in a category
DEPTH=3 lua debug/data-raw.lua <category> <name>  # drill into a specific prototype
```

Cross-reference with WebFetch to `lua-api.factorio.com` or `wiki.factorio.com`.

See `.claude/skills/factorio-research/SKILL.md` for full documentation.

The skill file can be edited through symbolic link in `slop/scratch/factorio-research.md`.

## Safety Harness Notes

- `defaultMode: dontAsk` means any tool not explicitly allowed is auto-denied without prompting.
- Hooks are a defense-in-depth layer; they fire even if permissions are misconfigured.
- When a hook denies a tool call, the error message includes the full list of allowed patterns. Use that list to self-correct — no need to read config files.
- No edit access to `.claude/`, ask user for help if Claude's configration files or any of the hook scripts cause problems.
