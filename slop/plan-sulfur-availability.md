# Design Document: Sulfur Availability Across Planets

## Current State (Vanilla + Space Age)

| Planet | Native Sulfur Source | Notes |
|--------|---------------------|-------|
| Nauvis | petroleum gas + water → sulfur | Requires oil processing |
| Vulcanus | ❌ None | Has sulfuric acid geysers, but acid-neutralisation only produces steam |
| Gleba | biosulfur (spoilage + bioflux) | Organic farming route |
| Fulgora | ❌ None | Has heavy oil from scrap, but no sulfur extraction |
| Aquilo | ❌ None | Import-focused planet design |

## Key Finding: Vulcanus Sulfur Gap

The acid-neutralisation recipe consumes sulfuric acid without recovering elemental sulfur:
- Input: 1000 sulfuric acid + 1 calcite
- Output: 10000 steam (500°C)

Players on Vulcanus must import sulfur from Nauvis or Gleba for any recipes requiring elemental sulfur.

## Mod Additions

### Implemented: Sulfur Ore (extras/ores)

- Minable resource requiring steam (Frasch process)
- Spawns on Nauvis only (currently)
- Starting area placement conditional on `tweaks.earlygame` toggle

### Potential: Oil Purification (tweaks/sulfur-processing?)

Real-world context: Hydrodesulfurization (HDS) removes sulfur from crude oil as an environmental requirement. The extracted sulfur is a valuable byproduct.

**Recipe concepts for Fulgora:**

| Recipe | Input | Output |
|--------|-------|--------|
| Heavy oil purification | heavy oil | purified heavy oil + sulfur |
| Light oil purification | light oil | purified light oil + sulfur |
| Purified cracking | purified heavy → purified light | (no additional sulfur) |

**Balance considerations:**
- Should purified oils be required for certain recipes, or optional upgrades?
- Sulfur yield rate vs. oil processing throughput
- Does this trivialize sulfur logistics or create interesting choices?

### Potential: Vulcanus Sulfur Source

**Option A: Sulfur ore on Vulcanus**
- Thematically appropriate (volcanic = sulfur)
- Changes intended logistics challenge
- Would need Vulcanus-specific autoplace expression

**Option B: Acid electrolysis recipe**
- sulfuric acid → sulfur + oxygen (or water)
- Requires power investment to recover sulfur
- Maintains "acid is abundant, sulfur requires work" design

**Option C: Leave as-is**
- Vulcanus sulfur remains import-dependent
- Preserves Space Age logistics design intent

## Feature Interaction Matrix

| Feature Combination | Effect |
|--------------------|--------|
| sulfur-ore alone | New Nauvis resource, distant spawn |
| sulfur-ore + earlygame | Starting area sulfur deposit |
| sulfur-ore + drills | Steam mining available early (wet-drilling) |
| sulfur-ore + earlygame + drills | Full early sulfur access (overhaul territory) |
| sulfur-processing + fulgora | Native sulfur on Fulgora via oil |
| sulfur-ore + vulcanus | Native sulfur on Vulcanus (if added) |

## Open Questions

1. Should sulfur ore spawn on Vulcanus? (thematic vs. balance)
2. Should oil purification be Fulgora-specific or universal?
3. How does sulfur availability affect military/explosives progression?
4. Should biosulfur on Gleba be buffed/nerfed to compensate?
5. Integration with existing `plan-sulfur-ore.md` oil byproduct ideas?

## Dependencies

- `extras/ores` - sulfur ore resource (implemented)
- `extras/drills` - wet drilling technology (implemented)
- `tweaks/earlygame` - starting area toggle (implemented)
- `tweaks/sulfur-processing` - oil purification (not yet created)
