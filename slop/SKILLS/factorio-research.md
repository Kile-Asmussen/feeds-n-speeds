# Skill: /factorio-research

Research Factorio prototypes by inspecting data.raw structures and cross-referencing API documentation.

## When to Use

- Before modifying or creating prototypes
- When unsure about field names, types, or valid values
- To understand relationships between prototype types
- To find examples of how vanilla Factorio implements features
- To verify mod prototypes are defined correctly

## Available Lua Scripts

- `debug/load.lua` : mod loading simulation to debug module loading issues, will also list missing localization keys
- `debug/data-raw.lua` : reference lookup of vanilla prototypes
- `debug/data-modded.lua` : reference lookup of prototypes altered/added/left as-is by this mod
- `debug/search.lua` : text search of prototype categories, names, and fields

There is a filter in place which restricts bash commands. Check `.claude/bash-commands.json` for
the exact forms these commands can take. DO NOT attempt to use `cd` to change to the project directory as
this is always the default working directory, DO NOT attempt to pipe script output into `head` or `tail` to 
extract only part of the output.

## Factorio Source Data Access

A copy of factorio's vanilla data is available in the `./target/` directory (under .gitignore):

- `./target/base`: Base game prototypes, graphics, locale
- `./target/elevated-rails`: Elevated rails (small)
- `./target/quality`: Quality mod (small)
- `./target/space-age`: Space Age expansion

### Use Cases

- **Locale strings**: Find vanilla descriptions to override or reference
  ```
  Grep: pattern="nuclear-reactor" path="./target/base/locale/en"
  ```
- **Graphics paths**: Discover sprite filenames for reuse
  ```
  Glob: pattern="**/nuclear-reactor*.png" path="./target/base/graphics"
  ```
- **Prototype definitions**: Read actual Lua source for game mechanics
  ```
  Read: ./target/base/scenarios/freeplay/control.lua
  ```

## Workflow

### Step 1: Choose Script

- **Inspecting vanilla prototypes:** Use `debug/data-raw.lua`
- **Inspecting mod prototypes:** Use `debug/data-modded.lua`
- **Unsure about exact names:** Use `debug/search.lua`

### Step 2: List Instances in Category

Inspect a category at depth 1 to see all instances:
```bash
DEPTH=1 lua debug/data-raw.lua <category>
DEPTH=1 lua debug/data-modded.lua <category>
```

Example:
```bash
DEPTH=1 lua debug/data-raw.lua inserter
DEPTH=1 lua debug/data-modded.lua container
```

Common categories:
- Entities: `container`, `inserter`, `assembling-machine`, `reactor`, `boiler`, `electric-pole`
- Items: `item`, `item-with-entity-data`, `tool`, `ammo`, `module`, `capsule`
- Recipes: `recipe`
- Technologies: `technology`
- Fluids: `fluid`
- Resources: `resource`

### Step 3: Inspect Specific Prototype

Drill into a specific prototype with increasing depth:
```bash
DEPTH=2 lua debug-data-modded.lua <category> <name>
DEPTH=3 lua debug-data-modded.lua <category> <name>
```

Example:
```bash
DEPTH=3 lua debug-data-raw.lua inserter inserter
DEPTH=3 lua debug-data-modded.lua container feeds-n-speeds-steel-chest
```

### Step 4: Inspect Nested Fields

Descend into specific nested structures:
```bash
DEPTH=3 lua debug-data-modded.lua <category> <name> <field> <subfield>
```

Example:
```bash
DEPTH=2 lua debug-data-raw.lua reactor nuclear-reactor heat_buffer
DEPTH=3 lua debug-data-modded.lua container feeds-n-speeds-steel-chest picture
```

### Wildcard queries with `-`

Use `-` as a wildcard segment to match all keys at that level. This produces groupings of all results under the nearest non-wildcard prefix. At most one wildcard is allowed in the first two arguments (category and name); further wildcards deeper in the path are unrestricted.

```bash
# All entities in a category at a specific field
DEPTH=1 lua debug/data-raw.lua electric-pole - minable

# All values of a nested array field across all entities (two wildcards)
DEPTH=1 lua debug/data-modded.lua electric-pole - selection_box -
```

Example output:
```
data.raw["electric-pole"] = {
  substation.minable = { mining_time = 0.8, result = "substation" },
  ["medium-electric-pole"].minable = { mining_time = 0.3, result = "medium-electric-pole" },
  ...
}
```

Notes:
- DEPTH is overridden to `(number of wildcards)` when wildcards are present — the env var is ignored
- Error if both category and name (first two args) are wildcards

### Step 5: Cross-Reference API Documentation

Fetch type definitions from the Factorio Lua API:
```
WebFetch: https://lua-api.factorio.com/latest/types/<TypeName>.html
```

Common type pages:
- `https://lua-api.factorio.com/latest/types/EnergySource.html`
- `https://lua-api.factorio.com/latest/types/ItemPrototype.html`
- `https://lua-api.factorio.com/latest/types/EntityPrototype.html`
- `https://lua-api.factorio.com/latest/types/RecipePrototype.html`

For prototype definitions:
- `https://lua-api.factorio.com/latest/prototypes/<PrototypeName>.html`

Example:
- `https://lua-api.factorio.com/latest/prototypes/InserterPrototype.html`
- `https://lua-api.factorio.com/latest/prototypes/ContainerPrototype.html`

## Depth Guidelines

DEPTH = 1  List keys only, category overview
DEPTH = 2  See immediate field values, identify structure
DEPTH = 3  Standard inspection, most fields visible, large printouts

## Common Patterns

### Entity-Item-Recipe-Technology Chain

Most placeable entities require:
1. Entity prototype (e.g., `data.raw.container['steel-chest']`)
2. Item prototype (e.g., `data.raw.item['steel-chest']`)
3. Recipe prototype (e.g., `data.raw.recipe['steel-chest']`)
4. Technology unlock for precipe (added to `data.raw.technology[...].effects`)

This mod has a helper for recipe unlocks: pseudo prototype field `recipe.auto_unlocked_by`, see ./modules/utilities/assign-recipe-unlocks.lua for implementation

Usually recipes will take the name of their main product, items will take the name of their placeable entity, meaning only entities have localised names in most cases. Same is true of icons.

## Output Format

When reporting findings, include:
1. Prototype type and name inspected
2. Relevant fields discovered
3. API documentation reference if consulted
4. Recommended approach for modification

## Factorio mod loading stages

### Settings stage

Configuration of mods. Runs first during startup.

data.raw is not available, data:extend only to create settings

settings.lua:
Create settings
startup, per-player, per-game, boolean, string, number
many mods use this

settings-updates.lua:
modify other mod's settings, generate settings dynamically
rarely needed

settings-final-fixes.lua:
modify other mod's modifications of settings
extremly rarely needed

### Data stage

Mod content. Runs second during startup.

data.lua:
create prototypes, change vanilla prototypes, edit the prototypes of mods this mod depends on
most mods use this

data-updates.lua:
dynamically generate prototypes based on requests from other mods (remote, pseudo-prototype fields)
vanilla examples: `item/recipe.auto_recycling :: boolean`, `fluid.auto_barrel :: boolean`
this mod: `recipe.auto_unlocked_by`, `entity.auto_reuquire_pavement`

rarely needed but has legitimate usecases

data-final-fixes.lua:
modify other mod's dynamically generated prototypes
basically never needed

### Control stage

Runs when a map is loaded in-game and play begins.

control.lua:
Allows registering event hooks for runtime behavior

### Ordering

All mods are loaded in dependency order, for each stage.

Ordering is determined first by dependency resolution, then by alphabetical ordering of mod names.

First ALL the settings.lua are loaded, then ALL the settings-updates.lua and so on.
