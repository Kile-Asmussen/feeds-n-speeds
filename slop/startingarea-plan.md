# Tweak: Oil & Uranium in Starting Area

## Goal

Allow crude oil and uranium ore to spawn in the starting area, matching the pattern used by `extras.ores` for sulfur.

## Approach

Text substitution on the vanilla noise expressions `default-crude-oil-patches` and `default-uranium-ore-patches` in `data_updates`:

1. Replace `has_starting_area_placement = 0` → `has_starting_area_placement = 1`
2. Replace `starting_patch_set_index = 0` → `starting_patch_set_index = <claimed index>`
   - Claim the index by reading `default_starting_resource_patch_set_count.expression` and post-incrementing it, same as sulfur does for the regular index.

## Module

New file `tweaks/startingarea.lua` (Operator to create blank file).
Registered in `tweaks.lua`. Toggle via `module.enabled`.
Lifecycle: `data_updates()` only.

## Pinned question

The vanilla `starting_rq_factor` values look like simple fractions:
- crude-oil: `0.14285714285714` ≈ 1/7
- uranium-ore: same value (also 1/7)
- iron-ore (starting): `0.21428571428571` ≈ 3/14 or 1.5/7

Worth verifying whether these map to exact fractions and whether we need to tune them for balance.
Also worth checking: do we need separate starting indices for oil vs uranium, or can they share one?
