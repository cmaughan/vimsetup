# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Cross-platform (Windows/macOS) Neovim configuration with shell templates and bootstrap scripts. Lives at `%LOCALAPPDATA%\nvim` (Windows) or `~/.config/nvim` (Mac).

## Bootstrap & Validation

```bash
# Mac/Linux
./install.sh        # Install tools, symlink configs, set up Python/Node/Rust
./doctor.sh         # Validate environment health (read-only, installs nothing)

# Windows (run in cmd.exe, not bash)
install.bat         # Install tools via winget, copy configs, set up Python/Node/Rust
doctor.bat          # Validate environment health
```

Key Windows batch pitfalls already handled in these scripts:
- External `.cmd` tools (npm, uv) require `call` prefix in batch files
- Use `!errorlevel!` (delayed expansion), never `%errorlevel%` inside blocks
- Avoid nested `if/else` with ANSI codes; flatten with `goto` labels
- Use `fc` (text mode) not `fc /b` for config comparison (ignores line endings)
- PowerShell `$PROFILE` path may be OneDrive-redirected; query `pwsh` for real path

## File Structure

```
init.lua                    # Entry point: lazy.nvim bootstrap, Python host resolution
lua/options.lua             # Vim settings (4-space indent, relative numbers, no swap)
lua/keymaps.lua             # ALL keybindings (200+ lines, centralized, not scattered)
lua/plugins.lua             # lazy.nvim plugin declarations (40+ plugins)
lua/session.lua             # Git-root-aware session persistence
lua/util/keymap.lua         # Duplicate keymap guard with caller tracking
lua/util/paths.lua          # Cross-platform path helpers (Dropbox, Python venv)
lua/plugin_config/          # One file per plugin (31 configs)
```

## Key Conventions

- **Leader:** `,` (comma). **Local leader:** `\`
- **All keymaps** live in `lua/keymaps.lua` -- never scatter bindings in plugin configs
- **Duplicate keymap detection:** `util/keymap.lua` errors on duplicate bindings unless `override = true`
- **Plugin config pattern:** `config = function() require("plugin_config.xxx") end` in plugins.lua
- **Cross-platform paths:** Always use `util/paths.lua` for Dropbox, Python venv, undo dir resolution
- **Preserve line endings:** Keep CRLF/LF as-is when editing files (see AGENTS.md)

## Plugin Manager (lazy.nvim)

Lazy-loading strategies used:
- `event = 'VeryLazy'` or `event = { 'BufReadPre', 'BufNewFile' }` -- load on file open
- `cmd = 'Mason'` -- load on command
- `keys = { ... }` -- load on keypress
- `ft = 'rust'` -- load on filetype
- `lazy = false, priority = 1000` -- always load (colorscheme only)

## Format & Lint

Format-on-save is enabled globally via conform.nvim. **Exception:** Markdown inside the Obsidian vault is skipped (detected via Dropbox path in `paths.lua`).

Formatters: stylua (Lua), ruff (Python), rustfmt (Rust), clang-format (C/C++), prettierd/prettier (JSON/YAML/Markdown), shfmt (Shell), taplo (TOML).

Linters: shellcheck, jsonlint, markdownlint, ruff, yamllint.

Mason auto-installs all formatters, linters, and LSP servers on first launch.

## LSP

Auto-installed: `lua_ls`, `rust_analyzer`, `clangd`. Manual: `openscad_lsp`.

## Template Files and Targets

| Template | Windows Target | Mac Target |
|---|---|---|
| `profile.ps1.template` | `$PROFILE` (query pwsh) | N/A |
| `zshrc.template` | N/A | `~/.zshrc` |
| `starship.toml.template` | `~\.config\starship.toml` | `~/.config/starship.toml` |
| `tmux.windows.conf.template` | `~\.tmux.conf` (psmux) | N/A |
| `tmux.conf.template` | N/A | `~/.tmux.conf` (tmux+TPM) |

## Session Management

Sessions auto-save on exit and restore on startup (when no file args). Keyed by git root when available, otherwise cwd. Transient buffers (help, terminal, mason, quickfix, lazy) are filtered out.

## Non-Obvious Behaviors

- **Python provider:** Resolved in `init.lua` to a dedicated nvim venv (`python-global` on Windows, `nvim-venv` on Mac), not system Python
- **Obsidian vault** auto-detected from Dropbox `info.json` -- affects format-on-save and undo directory
- **Arrow keys disabled** in normal/visual/operator modes (enforces hjkl)
- **`jk` mapped to Escape** in insert and terminal modes
