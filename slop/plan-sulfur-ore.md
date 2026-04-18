# Planning Document: Sulfur as Base Ore

## Overview

Add sulfur as a minable resource on Nauvis, requiring steam injection to extract (mimicking real-world Frasch process). This provides an early-game sulfur source while maintaining interesting logistics. Complements changes to oil processing (sulfur as byproduct) and unlocks earlier explosives/ammunition progression.

## Historical Context: Frasch Process

The Frasch process (1894-early 2000s) extracted sulfur from underground "salt dome" deposits by:
1. Injecting superheated steam (~165°C) into the deposit
2. Molten sulfur rises through a pipe
3. Compressed air lifts it to the surface

This method fell out of favor in the early 21st century because:
- High energy cost (steam generation)
- Oil/gas desulfurization produces cheap sulfur as byproduct
- Environmental concerns

**Gameplay parallel:** Steam-based extraction creates early-game logistics challenge, while oil processing later provides "free" sulfur, mirroring real industrial history.

## Motivation

Currently, sulfur is only obtainable through:
1. Chemical plant: petroleum gas + water → sulfur (requires oil processing)
2. Space Age: sulfuric acid geysers on Vulcanus (late game)

This creates a bottleneck where uranium mining requires:
- Oil processing → petroleum gas → sulfur → sulfuric acid

Adding sulfur ore provides:
- Earlier access to sulfuric acid for uranium mining
- Earlier access to explosives and military tech
- Alternative pathway independent of oil (but energy-intensive)
- More strategic resource decisions
- Historical/educational element

## Implementation Components

### 1. Resource Prototype (`extras/resources/sulfur-ore.lua`)

```lua
-- Resource entity (minable patch on map)
{
    type = "resource",
    name = fns "sulfur-ore",
    icon = "__base__/graphics/icons/sulfur.png",  -- reuse existing

    -- Category determines which drills can mine it
    category = "basic-solid",  -- standard mining drills work

    -- Requires steam injection (Frasch process)
    minable = {
        mining_time = 2,  -- slower than standard ores
        result = "sulfur",
        required_fluid = "steam",
        fluid_amount = 50,  -- per unit mined
    },

    -- Map generation
    autoplace = {
        control = fns "sulfur-ore",  -- links to autoplace-control
        -- Rarer than iron/copper, similar to uranium frequency
        -- Should spawn near edges of starting area or beyond
    },

    -- Visuals
    map_color = { r = 0.8, g = 0.7, b = 0.1 },  -- yellowish
    mining_visualisation_tint = { r = 0.9, g = 0.8, b = 0.2, a = 1 },

    -- Standard solid resource fields
    stage_counts = { 15000, 9500, 5500, 2900, 1300, 400, 150, 80 },
    stages = { ... },  -- sprite sheet for resource patches
}
```

### 2. Autoplace Control (`extras/resources/sulfur-ore-autoplace.lua`)

```lua
-- Map generation control (appears in map gen settings)
{
    type = "autoplace-control",
    name = fns "sulfur-ore",
    category = "resource",
    richness = true,
    order = "b-f",  -- after uranium in list
}
```

### 3. Graphics Requirements

| Asset | Source | Notes |
|-------|--------|-------|
| Resource patch sprites | New or recolor stone | Yellow/greenish tint |
| Mining particles | Recolor existing | Optional |
| Map icon | Reuse `sulfur.png` | Already exists |

**Options for resource sprites:**
- A) Recolor stone ore sprites to yellow/green
- B) Create new sulfur crystal sprites
- C) Use placeholder (stone sprites) initially

### 4. Noise Expressions (Map Generation)

```lua
-- Control where sulfur spawns
{
    type = "noise-expression",
    name = fns "sulfur-ore-probability",
    expression = "..." -- Based on distance from start, biome, etc.
}

{
    type = "noise-expression",
    name = fns "sulfur-ore-richness",
    expression = "..." -- Scales with map settings
}
```

### 5. Balance Considerations

| Aspect | Proposed Value | Rationale |
|--------|---------------|-----------|
| Spawn frequency | ~50% of uranium | Not too common, still valuable |
| Patch richness | Similar to stone | Moderate yield per patch |
| Starting area | Outside or edge | Requires some exploration |
| Mining time | 2 seconds | Slower due to steam process |
| Yield | 1 sulfur per mine | Direct, no chemical processing |
| Steam required | 50 units per sulfur | Significant but not prohibitive |
| Steam temperature | Any (15°+) | Boiler steam works, not just heat exchanger |

**Steam logistics early game:**
- Player needs: boiler + offshore pump + pipes to mining drill
- Creates interesting "mining outpost" requiring water access
- Or long steam pipes from central boiler facility
- Trade-off: energy cost vs oil dependency

### 6. Oil Processing Changes (`tweaks/sulfur-byproduct.lua`)

**Rationale:** Real-world oil/gas processing produces sulfur as waste product (desulfurization). This makes sulfur abundant mid-game, reducing need for steam-based extraction.

**Recipe modifications:**

| Recipe | Current Output | New Output |
|--------|---------------|------------|
| Basic oil processing | petroleum gas | petroleum gas + sulfur (small) |
| Advanced oil processing | heavy/light/petroleum | heavy/light/petroleum + sulfur |
| Light oil cracking | petroleum gas | petroleum gas + sulfur (trace) |
| Coal liquefaction | heavy/light/petroleum | heavy/light/petroleum + sulfur |

**Implementation:**
```lua
-- Add sulfur to oil processing results
table.insert(recipe['basic-oil-processing'].results, {
    type = "item",
    name = "sulfur",
    amount = 1,
    probability = 0.5  -- or fixed small amount
})
```

**Balance:** Sulfur from oil should be:
- Enough to feel like "free" byproduct
- Not so much it becomes a waste management problem (or make it one?)

### 7. Ammunition & Explosives Changes (`tweaks/sulfur-explosives.lua`)

**Rationale:** Early sulfur access enables earlier military progression. Historically, sulfur → gunpowder → explosives.

**Tech tree modifications:**

| Technology | Current Prerequisites | New Prerequisites |
|------------|----------------------|-------------------|
| Military science | Automation 2, Stone walls | Automation 2, Stone walls |
| Explosives | Sulfur processing | *Remove or reduce* |
| Cliff explosives | Explosives, ... | Explosives, ... |
| Land mines | Explosives, Military 2 | Explosives, Military 2 |

**Recipe modifications:**

| Recipe | Current | Proposed |
|--------|---------|----------|
| Firearm magazine | iron plates | iron plates + sulfur (gunpowder) |
| Piercing magazine | steel, copper | steel, copper, sulfur |
| Grenade | coal, iron | sulfur, coal, iron (reduced) |
| Explosives | sulfur, coal, water | sulfur, coal (simplified early version?) |

**New recipe ideas:**
- Gunpowder intermediate: sulfur + coal + ??? → gunpowder
- Early explosives: gunpowder-based before plastic explosives

### 8. Integration with Existing Features

**tweaks.ores interaction:**
- If `tweaks.ores` is enabled, sulfur ore becomes infinite like other ores
- Richness expression should respect map settings

**Recipe implications:**
- Sulfuric acid recipe unchanged (sulfur + iron + water)
- Oil→sulfur pathway becomes "free" byproduct rather than dedicated recipe
- Military recipes gain sulfur requirements

## File Structure

```
extras/
├── resources/
│   ├── sulfur-ore.lua           # Main resource prototype
│   ├── sulfur-ore-autoplace.lua # Map generation control
│   └── sulfur-ore-graphics.lua  # Sprite definitions (if custom)
└── resources.lua                # Domain coordinator (new)

tweaks/
├── sulfur-byproduct.lua         # Oil processing sulfur output
├── sulfur-explosives.lua        # Explosives/ammo recipe changes
└── sulfur-military.lua          # Tech tree modifications (or merge above)
```

**Alternative:** Single `tweaks/sulfur.lua` domain handling all sulfur-related changes, with `extras/resources/` only for the ore itself.

## Implementation Phases

### Phase 1: Core Resource
- [ ] Resource prototype with steam requirement
- [ ] Autoplace control for map settings
- [ ] Basic noise expression for spawning
- [ ] Placeholder graphics (recolored stone)
- [ ] Integration with tweaks.ores

### Phase 2: Oil Processing Changes
- [ ] Add sulfur byproduct to oil recipes
- [ ] Balance byproduct amounts
- [ ] Consider waste management implications
- [ ] Remove/modify petroleum→sulfur recipe (redundant?)

### Phase 3: Military/Explosives Rework
- [ ] Decide on gunpowder intermediate (yes/no)
- [ ] Modify explosives recipe
- [ ] Modify ammunition recipes (scope TBD)
- [ ] Adjust tech tree prerequisites
- [ ] New military science requirements?

### Phase 4: Polish
- [ ] Custom sulfur ore sprites
- [ ] Mining particles (yellow/steam effects)
- [ ] Factoriopedia entries
- [ ] Localization
- [ ] Tips and tricks entries

### Phase 5: Balance & Playtesting
- [ ] Spawn rate tuning
- [ ] Steam consumption balance
- [ ] Military progression pacing
- [ ] Oil byproduct quantities
- [ ] Interaction with other mod features

## Open Questions

1. **Should sulfur ore require research to mine?**
   - Option A: Minable immediately with steam (current plan)
   - Option B: Unlocked with sulfur processing tech
   - Option C: New "steam mining" or "deep extraction" tech

2. **Should it spawn on other planets?**
   - Vulcanus already has sulfuric acid geysers
   - Could replace/supplement geysers or be separate

3. **Starting area presence?**
   - Guaranteed small patch near start?
   - Or always requires exploration?

4. **Interaction with other mods?**
   - Angel's/Bob's have their own sulfur sources
   - Consider compatibility or conditional loading

5. **Should oil processing sulfur byproduct be optional?**
   - Could be overwhelming waste mid-game
   - Option: byproduct only with catalyst/upgrade
   - Option: sulfur has more uses (fertilizer for agriculture?)

6. **Gunpowder as intermediate?**
   - Adds historical authenticity
   - Creates new crafting chain: sulfur + coal + ??? → gunpowder
   - Gunpowder → ammunition, explosives
   - Third ingredient: saltpeter? (new resource or from stone?)

7. **Military recipe changes - how aggressive?**
   - Conservative: only grenades/explosives need sulfur
   - Moderate: all explosive ammo needs sulfur
   - Aggressive: all ammunition needs gunpowder (major overhaul)

## Dependencies

- `extras.lua` coordinator (exists)
- New `extras/resources.lua` domain (create)
- Graphics assets (create or source)
- Localization entries (add)
- **Burner mining drill fluid input** (see `slop/burner-fluid-mining.lua` snippet)
  - Required for early-game sulfur extraction before electric drills
  - Adds `input_fluid_box` to burner-mining-drill prototype
  - Pipe connection on south side (opposite output)
  - Enables steam injection for Frasch process mining

**Early game sulfur mining setup:**
```
[Offshore Pump] → [Boiler] → [Steam Pipe] → [Burner Mining Drill]
                     ↑                              ↓
                  [Coal]                      [Sulfur Ore Patch]
```

This creates an interesting bootstrap: coal powers boiler, steam enables sulfur mining, sulfur enables explosives/military.

## References

- `data.raw.resource['iron-ore']` - standard solid resource template
- `data.raw.resource['uranium-ore']` - rare resource with effects
- `data.raw.resource['stone']` - simple solid resource
- `data.raw.item['sulfur']` - target item (already exists)
