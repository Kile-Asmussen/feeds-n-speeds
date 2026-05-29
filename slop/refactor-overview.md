# Refactor Overview: gadgets.icons / gadgets.throughputs / table.merge

All files below are under `modules/`. No files currently use `gadgets.icons` or `gadgets.icon`.

---

## Icons refactor (gadgets.icons / gadgets.icon)

All 21 files with raw `icons = { ... }` blocks. Grouped by how much work is involved.

### Mechanical (pure bg+fg, no unusual fields)

These have a straightforward background + foreground overlay with a hardcoded shift — ideal first targets.

- `production/recipes/sulfur-processing.lua` — 3 recipes, all identical pattern: bg=oil-process icon, fg=sulfur.png, shift `{-8,-8}`, `scale=0.25`. All can become `gadgets.icons{ bg=..., fg=..., dir='tl', size='tiny' }`.
- `bootstrap/recipes/stone-furnace-alt.lua` — 3 icons blocks with same `{-8,-8}` shift pattern. Also has one technology icon with non-standard `icon_size=146` bg (entity sprite, not icon).
- `production/recipes/concrete.lua` — likely same mechanical pattern (not read, assumed from grep).
- `military/misc/concrete-walling.lua` — 2 icons blocks (not read in detail).
- `production/fluids/boil-water.lua` — 1 icons block.
- `production/fluids/barrel-tapper.lua` — 1 icons block.
- `military/guns/plastics.lua` — 1 icons block.

### Moderate (tint, float=true misspelling, or technology icon_size=256)

- `military/turrets/shotgun.lua` — item icons (bg=gun-turret, fg=shotgun-shell, shift `{-8,8}`), technology icons (`icon_size=256`, fg with `tint` and shift). Uses `float=true` (wrong field name — should be `floating`).
- `military/turrets/cannon.lua` — item icons with `tint` on bg, technology icons (`icon_size=256`). Uses `float=true` (wrong field name).
- `bootstrap/tech/tree.lua` — technology icons, `icon_size=256`.
- `bootstrap/tech/wet-drilling.lua` — technology icon.
- `bootstrap/entities/miners.lua` — entity/item icons.
- `production/energy/electroboiler.lua` — entity icons.
- `logistics/railway/concrete-rails.lua` — icons block.
- `military/ammo/uranium-buckshot.lua` — ammo item icons.
- `military/ammo/napalm.lua` — ammo item icons.
- `military/ammo/mass-production.lua` — recipe icons.

### Needs care (unusual icon_size, entity sprites as bg, or icons reused across entity+item)

- `production/recipes/casting.lua` — uses `float=true` (wrong), two-layer icon pattern repeated ~5 times including inside a helper function `melt_down`. Icons reference mod-internal PNGs (`iron-casting-icon.png`, `copper-casting-icon.png`). Good candidate for a local helper using `gadgets.icons`.
- `logistics/robotics/robotics.lua` — icons defined on entity then `table.clone`d onto item. Already uses `throughputs` (aliased as `inputs`). Shift values are `{-8,8}`, `{8,-8}`, `{8,8}` — maps directly to `dir` parameter.
- `logistics/robotics/battery.lua` — not read in detail.
- `logistics/entities/electric-link.lua` — complex; entity icons reference `switch.icon` (a runtime value) and a virtual signal icon. Also has `floating=true` and `tint`. Needs manual attention.

---

## throughputs refactor (gadgets.throughputs)

Files still using raw `ingredients`/`results` arrays instead of `gadgets.throughputs`:

- `production/recipes/sulfur-processing.lua` — all ingredients/results are raw. Fluid-heavy, good fit.
- `military/turrets/cannon.lua` — raw ingredients array.
- `military/turrets/shotgun.lua` — raw ingredients array.
- `construction/recipes/malltech.lua` — not read; likely raw (no throughputs import seen).
- `military/tech/tree.lua` — raw science pack ingredient arrays.
- `production/science/packs.lua` — raw arrays.
- `production/energy/mini-reactor.lua` — raw arrays.
- `production/energy/electroboiler.lua` — raw arrays.
- `logistics/entities/electric-poles.lua` — raw arrays.
- `military/guns/tweak-recipes.lua` — raw arrays.
- `military/turrets/tweak-recipes.lua` — raw arrays.
- `military/ammo/napalm.lua` — raw arrays.
- `military/projectiles/cliffsplosives.lua` — raw arrays.

Already using `gadgets.throughputs` (aliased as `inputs` or `puts`):
- `logistics/robotics/robotics.lua` ✓
- `bootstrap/recipes/stone-furnace-alt.lua` ✓ (partial — results use it, some raw remain)

---

## Bugs to fix while touching these files

- `float=true` is the wrong field name — should be `floating=true`. Appears in: `casting.lua`, `shotgun.lua`, `cannon.lua`, `stone-furnace-alt.lua` (as `float=true`). The new `gadgets.icon` helper avoids this entirely.
- `production/recipes/casting.lua` — `scale=0.5, shift={-4,4}` on the bg layer: bg should not have an explicit scale (defaults to 1.0 i.e. full-size). These look like copy-paste from old icon patterns.

---

## Suggested order

1. `sulfur-processing.lua` — mechanical, no surprises, 3 identical blocks good for validating the new helper.
2. `bootstrap/recipes/stone-furnace-alt.lua` — same pattern, catches the non-standard `icon_size=146` edge case.
3. `casting.lua` — repeated pattern inside a helper function; refactor the helper to use `gadgets.icons`.
4. `robotics.lua` — icons reused across entity/item, dir-mapped shifts; throughputs already done.
5. Turrets (`shotgun`, `cannon`) — technology icons with `type='technology'` needed.
6. Remaining files — mostly mechanical once the above are validated.
