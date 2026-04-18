# FeedsNSpeeds Development TODO

## Short-term Goals

- [ ] Test hopper entity in-game (placement linking, chest destruction, re-linking)
- [ ] Add missing localization for big-steel-hopper
- [ ] Add settings-updates.lua and settings-final-fixes.lua lifecycle implementations
- [ ] Write more test coverage for prelude modules

## Long-term Goals

- [ ] Add thumbnail/icon graphics for big-steel-chest and big-steel-hopper (currently using base steel-chest)
- [ ] Expand alt-recipes module (`extras/altrecipes/`)
- [ ] Add per-planet surface condition variants for entities
- [ ] Consider Space Age DLC integration (heating tower already partially handled)
- [ ] Add migration scripts for settings changes
- [ ] Localization for additional languages

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

## Ideas / Maybe

- [ ] Ditch toggles entirely: transition from optional tweaks to a full overhaul mod with cohesive vision; removes settings complexity and allows bolder, interconnected changes
- [ ] Electrical boiler: identical to baseline boiler but with electrical energy source; provides steam for altered recipes or coal liquefaction; serves as accumulator alternative for solar setups
- [ ] Debug mode setting for verbose logging
- [ ] In-game changelog display
- [ ] In-game documentation (tips and tricks, custom GUI, or factoriopedia integration)
