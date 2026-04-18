## Factorio Source Data Access

Direct read access is available to the Factorio installation's data directories via Read, Grep, and Glob tools:

| Path | Contents |
|------|----------|
| `~/.steam/.../Factorio/data/base` | Base game prototypes, graphics, locale |
| `~/.steam/.../Factorio/data/quality` | Quality mod |
| `~/.steam/.../Factorio/data/space-age` | Space Age expansion |
| `~/.steam/.../Factorio/data/elevated-rail` | Elevated rails |

Full path: `/home/qeela/.steam/steam/steamapps/common/Factorio/data/`

### Use Cases

- **Locale strings**: Find vanilla descriptions to override or reference
  ```bash
  Grep: pattern="nuclear-reactor" path=".../data/base/locale/en"
  ```
- **Graphics paths**: Discover sprite filenames for reuse
  ```bash
  Glob: pattern="**/nuclear-reactor*.png" path=".../data/base/graphics"
  ```
- **Prototype definitions**: Read actual Lua source for complex entities
  ```bash
  Read: .../data/base/prototypes/entity/reactor.lua
  ```

### Notes

- These paths are configured in `.claude/read-grep-glob-paths.json`
- Read-only access; cannot modify base game files
- Useful for finding exact field names, graphic dimensions, and locale keys
