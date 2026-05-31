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
- **Edit and write/create** any and all files under the following folders:
  - `slop/`: notes and progress tracking, temporary files
  - `locale/`: cfg files with localisation strings
  - 'modules/`: module structure of the mod, as described below
  - `src/`: utilities written in Rust with the mlua library
  - `debug/dump-defines/`: a work in progress diagnostic mini-mod for debugging (unused)
- **Edit** certain other select files:
  - `TODO.md`: the to-do list
  - `CLAUDE.md`: this file
  - `test/localisation.lua`: tracker for missing localisation strings in the test pipeline
  - `module.lua`: the module loader
  - `fns/gadgets.lua`: the utility library
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
VERBOSE=1 lua debug/load.lua
VERBOSE=1 PROXY-1 lua debug/load.lua
DEPTH=[1-3] lua debug/data-raw.lua [<category> [<name> [<further properties/indexes>]]]
DEPTH=[1-3] lua debug/data-modded.lua [<category> [<name> [<further properties/indexes>]]] 
python .claude/safe-rm.py <path>
```
The debug/data-raw.lua and debug/data-modded.lua scripts will only print DEPTH=1 until a specific prototype is requested, to limit token usage. Similarly refrain from using the verbose and proxy (even more verbose) version of debug/load.lua .

**Important:** The bash hook rejects pipes (`|`), redirects (`>`/`<`), chained commands (`&&`, `;`, `||`), subshells, and glob characters in the command string. Commands must match the pattern exactly. When a command is blocked, the error message lists the allowed patterns — use that to self-correct immediately.

## Architecture

The project built around `module.lua` and the `module/` directory, which contains a full module loading system with dependency ordering.

Every file contains a toplevel doc-comments (prefix: `--!`) as the first line(s) of the file, telling what stage the file is loaded at (if any), and what the contents of the file does.

Use Grep tool with pattern `^--!` in `module/**/*.lua` for a concise overview of the entire project, or read the first line of an individual file to check whether it is relevant.

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

### Utility functions

The `fns.table` module provides many useful functions, notably `fns.table.merge` defined in `./fns/table/updates.lua`, which is very powerful.

Additionally `gadgets.lua` contains some useful functions, notably `gadgets.throughputs` that creates the arrays used for ingredients and results of recipes.

### Module Pattern

1. **Coordinator** (`module.lua`) — requires submodules listed in each stage, performs dependency ordering, requires each file in that order.
2. **Domain modules** (`module/`) — individual features, `production`, `construction`, etc.
3. **Loading system** (`loading.lua`) — calls lifecycle methods across all domains, sorted by `priority`

Each domain module:
- Declares `local some_domain = namespace 'some-domain'`
- Declares `some_domain.data`, `some_domain['data-updates']` and other properties as dependency graphs of this stage
- Returns `some_domain:seal()`.

The dependency graphs are declared with the `fns.table.intoset` function, usually renamed to `set`. It removes the numbered keys from a table and inserts their string values as named keys, set to `true`. This data format is used in `module.lua`.

Additionally entries in these dependency graphs may instead map to a numbered priority, or a set of direct dependencies. In the case of priorities, a value of `true` as above counts as 0, and all dependencies without subdependencies are ordered according to priority, lowest to highest. This is to account for submodules that should run before most other submodules.

Entries that are sets of dependencies are ordered according to a dependency ordering algorithm.

The individual required files have no special formatting, just execute as Lua code.

### Lifecycle Stages

Each lifecycle stage calls `modules.load_stage '<stage-name>'`

- `settings.lua` — loads a few files in the `models.utility` namespace
- `data.lua` — load new prototypes
- `data-updates.lua` — modify existing prototypes (chiefly `tweaks`)
- `control.lua` — runtime event handlers

Other stages are unused.

## Testing

### Debug scripts

- `lua debug/load.lua` — runs the full settings → data → control pipeline and prints missing localisation strings at the end
- `DEPTH=N lua debug/data-raw.lua [category [name [additional properties]]]` — inspect vanilla `data.raw`
- `DEPTH=N lua debug/data-modded.lua [category [name [additional properties]]]` — inspect `data.raw` after mod changes

The simulated pipeline is imperfect: it does not include full consistency checks, and does not account for staging of
the vanilla mods -- for instance auto-generation of recycling and barelling recipes.

## Localisation

- Locale file: `locale/en/localisation.cfg`
- Run `lua debug/load.lua` to find missing strings — it prints stubs for anything registered via `data:extend` that isn't in the locale file
- `fns.locale_key(category, name)` registers the name under `category` for localizations tracking; `fns(name)` only registers it in `mod_identifiers`, not in any named category — the localisation checker finds it via `localisation.keys` instead
- Noise expressions (`noise-expression` type) are internal and their entity-name/description entries are never shown to players, but the localisation checker flags them anyway — fill them with internal-facing descriptions

## Skills

### /factorio-research

Inspects live `data.raw` structures from the installed game and researches the prototypes and scripting utility of the game via the online API documentation.

Use before modifying or creating prototypes, or when unsure about field names/types/valid values.

The following lua scripts are available:

```
lua debug/data-raw.lua ...    # inspect vanilla prototypes directly
lua debug/data-modded.lua ... # inspect prototypes 
lua debug/search.lua ...      # search for prototypes/components by name
```

Use `--help` flag to be reminded of how they work.

Cross-reference with WebFetch to `lua-api.factorio.com` as needed.

See `.claude/skills/factorio-research/SKILL.md` for full documentation.

The skill file can be edited through symbolic link in `slop/SKILLS/factorio-research.md`.

## Safety Harness Notes

- `defaultMode: dontAsk` means any tool not explicitly allowed is auto-denied without prompting.
- Hooks are a defense-in-depth layer; they fire even if permissions are misconfigured.
- When a hook denies a tool call, the error message includes the full list of allowed patterns. Use that list to self-correct — no need to read config files.
- No edit access to `.claude/`, ask user for help if Claude's configration files or any of the hook scripts cause problems.
