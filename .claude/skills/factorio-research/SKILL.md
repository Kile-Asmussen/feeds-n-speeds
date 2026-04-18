# Skill: /factorio-research

Research Factorio prototypes by inspecting data.raw structures and cross-referencing API documentation.

## When to Use

- Before modifying or creating prototypes
- When unsure about field names, types, or valid values
- To understand relationships between prototype types
- To find examples of how vanilla Factorio implements features
- To verify mod prototypes are defined correctly

## Available Scripts

| Script | Contents | Use Case |
|--------|----------|----------|
| `debug-data-raw.lua` | Vanilla prototypes only | Reference vanilla implementations |
| `debug-data-modded.lua` | Vanilla + mod prototypes | Verify mod additions, check merged state |
| `debug-load.lua` | Verbose loading output | Debug module loading issues |

## Workflow

### Step 1: Choose Script

- **Inspecting vanilla prototypes:** Use `debug-data-raw.lua`
- **Inspecting mod prototypes:** Use `debug-data-modded.lua`

### Step 2: List Instances in Category

Inspect a category at depth 1 to see all instances:
```bash
DEPTH=1 lua debug-data-raw.lua <category>
DEPTH=1 lua debug-data-modded.lua <category>
```

Example:
```bash
DEPTH=1 lua debug-data-raw.lua inserter
DEPTH=1 lua debug-data-modded.lua container
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
DEPTH=3 lua debug-data-modded.lua container feeds-n-speeds-big-steel-chest
```

### Step 4: Inspect Nested Fields

Descend into specific nested structures:
```bash
DEPTH=3 lua debug-data-modded.lua <category> <name> <field> <subfield>
```

Example:
```bash
DEPTH=2 lua debug-data-raw.lua reactor nuclear-reactor heat_buffer
DEPTH=3 lua debug-data-modded.lua container feeds-n-speeds-big-steel-chest picture
```

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

| DEPTH | Use Case |
|-------|----------|
| 1 | List keys only, category overview |
| 2 | See immediate field values, identify structure |
| 3 | Standard inspection, most fields visible |
| 4 | Deep nested structures (sprites, circuit connectors) |
| 5 | Maximum detail, use sparingly |

## Common Patterns

### Entity-Item-Recipe Chain
Most placeable entities require:
1. Entity prototype (e.g., `data.raw.container['steel-chest']`)
2. Item prototype (e.g., `data.raw.item['steel-chest']`)
3. Recipe prototype (e.g., `data.raw.recipe['steel-chest']`)
4. Technology unlock (added to `data.raw.technology[...].effects`)

### Energy Sources
Entities with power consumption have `energy_source`:
- `type = "electric"` - uses electricity
- `type = "burner"` - burns fuel
- `type = "heat"` - uses heat pipes
- `type = "void"` - no power (free)

### Graphics Layers
Entity graphics typically have:
- `picture` or `pictures` - main sprite
- `shadow` - drop shadow
- `animation` - animated sprites

## Output Format

When reporting findings, include:
1. Prototype type and name inspected
2. Relevant fields discovered
3. API documentation reference if consulted
4. Recommended approach for modification

## Limitations

- Cannot inspect prototypes defined by other mods (only base game + this mod)
- Deep inspection (DEPTH=4+) produces verbose output
- Some fields are computed/inherited and not visible in raw data
