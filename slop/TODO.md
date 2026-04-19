# FeedsNSpeeds Development TODO

## Short-term Goals

- [ ] Add settings-updates.lua and settings-final-fixes.lua lifecycle implementations
- [ ] Write more test coverage for prelude modules
- [ ] Test wet-drilling technology in-game
- [ ] Test sulfur ore spawning and steam mining requirement
- [ ] Custom graphics for sulfur ore (currently using uranium-ore placeholder)

## In Progress

- [ ] Space Age DLC integration (heating tower already partially handled)

## Long-term Goals

- [ ] Add thumbnail/icon graphics for big-steel-chest and big-steel-hopper (currently using base steel-chest)
- [ ] Expand alt-recipes module (`extras/altrecipes/`)
- [ ] Add per-planet surface condition variants for entities
- [ ] Add migration scripts for settings changes

## Completed

- [x] Namespace system implementation
- [x] Basic tweaks: inserter, chests, electric, nuclear, ores, concrete
- [x] Big steel chest entity family (with filter slots, smart variant merged)
- [x] Big steel hopper entity (proxy container)
- [x] Small radar entity
- [x] Build system with git archive
- [x] Mod identifier namespacing (v0.2.0)
- [x] Settings toggles for all features
- [x] control.lua runtime stage support
- [x] Hopper chest linking behavior (`extras/chests/hopper.lua`)
  - Links to adjacent big-steel-chest on placement
  - Unlinks when chest destroyed, re-links if another adjacent
  - Fails to link if multiple adjacent chests (ambiguous)
  - Event-driven (no tick polling)
  - Dual-indexed storage for O(1) lookups
- [x] Test harness: script stub with event registration (`test/script.lua`)
- [x] Test harness: defines.events for control stage testing
- [x] Wet drilling technology (`extras/drills/wet-drilling-technology.lua`)
  - Triggers on building offshore pump, provides mining-with-fluid effect
  - Unlocks burner mining drill fluid recipe
- [x] Uranium tech restructure
  - Hidden `uranium-mining` technology (redundant with wet-drilling)
  - Converted `uranium-processing` to science-based research
  - Added prerequisites: speed-module, electric-engine, concrete
- [x] Malltech updates (lab recipe, uranium-processing prerequisites)
- [x] Concrete rail technology icon overlay fix
- [x] Sulfur ore resource (`extras/ores/`)
  - Resource requiring steam to mine, yields vanilla sulfur
  - Map generation noise expression and autoplace control

## Design Considerations

**Overhaul creep warning:** The combination of `sulfur-ore` + `earlygame` + `drills` + `malltech` creates an interconnected experience that approaches overhaul territory. These features share dependencies (wet-drilling enables sulfur mining, malltech restructures tech tree, earlygame changes recipes). Consider:
- Should these be bundled under a single "extended early game" toggle?
- Should enabling one auto-enable dependencies with a warning?
- Should documentation clearly mark which features are standalone vs. interconnected?
- Keep sulfur-ore as purely additive (new resource) vs. integrated (changes to existing sulfur recipes)?

## Ideas / Maybe

- [ ] Default-off toggles: Consider shipping with most features disabled by default, letting users discover and enable combinations; reduces initial complexity while preserving modularity
- [ ] Feature profiles: Predefined toggle combinations (e.g., "minimal", "balanced", "kitchen sink") as a single setting
- [ ] Electrical boiler: identical to baseline boiler but with electrical energy source; provides steam for altered recipes or coal liquefaction; serves as accumulator alternative for solar setups
- [ ] Debug mode setting for verbose logging
- [ ] In-game changelog display
- [ ] In-game documentation (tips and tricks, custom GUI, or factoriopedia integration)
