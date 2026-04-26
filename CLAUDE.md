# FeedsNSpeeds - Factorio Mod

A Factorio 2.0 mod providing value tweaks, balance changes, and new items.

## Operator Profile

- Name: Kashmira Qeel — address as **Operator**
- Pronouns: she/her
- Background: CS master's, 5 years professional software development, fluent in Lua/Python/Rust/Bash

## Permissions

### What I can do without asking

- **Read** anything in this project directory, plus Factorio game data and `~/.factorio` (see `.claude/read-grep-glob-paths.json` for the full allowlist)
- **Edit** files in `extras/**/*`, `tweaks/**/*`, `locale/**/*`, `unit-tests/*`, `slop/**/*`, `CLAUDE.md`
- **Write** (create) files in `extras/*/*`, `tweaks/*/*`, `unit-tests/*`, `slop/**/*`
- **Run** the specific Bash commands listed in `.claude/bash-commands.json` (see below)
- **WebFetch** from `lua-api.factorio.com`, `wiki.factorio.com`, `forums.factorio.com`, `mods.factorio.com`, `github.com/wube/factorio-data/*`, `raw.githubusercontent.com/wube/factorio-data/*`

### What I must ask the Operator to do

- **Create new files** directly in `extras/` or `tweaks/` (top level — I can only edit, not write there). Ask her to create a blank template file with the right name, then I can fill it in.
- **Modify hook or settings configuration** — `.claude/` is fully off-limits for edits and writes.
- **Add new allowed Bash commands** — Operator must update `.claude/bash-commands.json`.
- **Read files outside the project** that aren't in the allowlist (e.g. new system paths).
- **Fetch from new web domains** — Operator must update `.claude/webfetch-urls.json`.

### Allowed Bash commands

Exact patterns (glob `*` is allowed only where shown):

```
lua debug/load.lua
DEPTH=[1-5] lua debug/data-raw.lua [<category> [<name>]]
DEPTH=[1-5] lua debug/data-modded.lua [<category> [<name>]]
lua unit-tests.lua <module-name>
python .claude/safe-rm.py <path>
.claude/factorio-research.sh fetch
.claude/factorio-research.sh install
```

**Important:** The bash hook rejects pipes (`|`), redirects (`>`/`<`), chained commands (`&&`, `;`, `||`), subshells, and glob characters in the command string. Commands must match the pattern exactly. When a command is blocked, the error message lists the allowed patterns — use that to self-correct immediately.

## Architecture

The project is split into `extras` (new game objects) and `tweaks` (changes to existing objects).

### Namespace System (`prelude.lua`)

- `namespace(path)` — declares a new namespace; errors on duplicate
- `import(path)` — retrieves a declared namespace; errors if not found
- `fns(name)` — returns `feeds-n-speeds-{name}`, registering it globally; normalizes non-alphanumeric chars to `-`
- `fns(category, name)` — same but also registers under a named category for localization lookup
- `isnamespace(thing)` — type check, works on sealed and unsealed namespaces
- `namespace:__seal()` — makes namespace read-only; call at end of every module as `return module:__seal()`

### Module Pattern

Both `tweaks` and `extras` follow an identical pattern:

1. **Coordinator** (`tweaks.lua`, `extras.lua`) — requires submodules, exposes `create_toggles()`, `settings()`, `data()`, etc.
2. **Domain modules** (`tweaks/inserter.lua`, `extras/chests.lua`) — individual features
3. **Loading system** (`loading.lua`) — calls lifecycle methods across all domains, sorted by `priority`

Each domain module:
- Declares `namespace 'tweaks.foo'` or `namespace 'extras.foo'`
- Setting `module.enabled = true` causes `loading.create_toggle()` to auto-create a startup bool-setting named `fns(tostring(domain) .. '-enable')`
- Implements whichever lifecycle functions it needs: `data()`, `data_updates()`, `data_final_fixes()`, `settings()`, `control()`
- Returns `module:__seal()`

### Lifecycle Stages

- `settings.lua` — create new settings (also where `extras.create_toggles()` / `tweaks.create_toggles()` run)
- `settings-updates.lua`, `settings-final-fixes.lua` — unused
- `data.lua` — load new prototypes (chiefly `extras`)
- `data-updates.lua` — modify existing prototypes (chiefly `tweaks`)
- `data-final-fixes.lua` — last resort; currently only `tweaks.ores`
- `control.lua` — runtime event handlers

## Testing

### Running tests

```
lua unit-tests.lua <module-name>
```

`<module-name>` maps to `unit-tests/<module-name>.lua`. There is no "run all" — specify a module. Multiple module names can be passed as separate arguments.

### Writing tests

- `fact('description', fn)` — test expected to pass
- `fiction('description', fn)` — test expected to error
- Assertion helpers: `assert_eq(a, b)`, `assert_ok(val)`, `assert_is(val, type)`
- Write test files to `unit-tests/<name>.lua` — I can create these directly
- If a test needs `setmetatable`/`getmetatable`/`rawget`/`rawset`, it must go in `unit-tests-trusted.lua` (runs before sandbox). Ask Operator to add it there if needed.
- The sandbox nil's: `require`, `io`, `os`, `package`, `debug`, `load`, `loadfile`, `dofile`, `print`, `rawget`, `rawset`, `getmetatable`, `setmetatable`, `coroutine`, `string.dump`, `collectgarbage`

### Debug scripts

- `lua debug/load.lua` — runs the full settings → data → control pipeline and prints missing localization strings at the end
- `DEPTH=N lua debug/data-raw.lua [category [name]]` — inspect vanilla `data.raw`
- `DEPTH=N lua debug/data-modded.lua [category [name]]` — inspect `data.raw` after mod changes

## Localization

- Locale file: `locale/en/localization.cfg`
- Run `lua debug/load.lua` to find missing strings — it prints stubs for anything registered via `data:extend` that isn't in the locale file
- `fns(category, name)` registers the name under `category` for localization tracking; `fns(name)` without a category only registers it in `mod_identifiers`, not in any named category — the localization checker finds it via `localization.keys` instead
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

## Safety Harness Notes

- `defaultMode: dontAsk` means any tool not explicitly allowed is auto-denied without prompting.
- Hooks are a defense-in-depth layer; they fire even if permissions are misconfigured.
- When a hook denies a tool call, the error message includes the full list of allowed patterns. Use that list to self-correct — no need to read config files.
- Hook and settings files (`.claude/`) cannot be read-restricted at the moment, but must not be edited.
