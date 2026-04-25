# FeedsNSpeeds Development TODO

## In Progress

- [ ] Space Age DLC integration

## Long-term Goals

- [ ] Expand alt-recipes module (`extras/altrecipes/`)
- [ ] Expand malltech module
- [ ] Add per-planet surface condition variants for entities
- [ ] Add migration scripts for settings changes

## Ideas / Maybe

- [ ] Rail automation as triggered tech: Consider converting rail-automation from a researched technology to a triggered tech based on crafting 1000 rails. Trains are nearly useless without automation signals. Unclear which module this would belong to.
- [ ] Item/recipe ordering cleanup: With all features researched, the in-game crafting menu is cluttered. Review and improve ordering strings across all items and recipes for better organization.
- [ ] Default-off toggles: Consider shipping with most features disabled by default, letting users discover and enable combinations; reduces initial complexity while preserving modularity
- [ ] Feature profiles: Predefined toggle combinations (e.g., "minimal", "balanced", "kitchen sink") as a single setting
- [ ] Electrical boiler: identical to baseline boiler but with electrical energy source; provides steam for altered recipes or coal liquefaction; serves as accumulator alternative for solar setups
- [ ] Debug mode setting for verbose logging
- [ ] In-game changelog display
- [ ] In-game documentation (tips and tricks, custom GUI, or factoriopedia integration)
