# GEMINI.md - Neovim Configuration Context

This project is a highly customized, cross-platform Neovim configuration written in Lua, designed to work seamlessly on both macOS and Windows. It features a modular architecture, centralized keybindings, and automated tool management.

## Project Overview

*   **Main Technologies:** Neovim (Lua), `lazy.nvim` (plugin management), `Mason` (LSP/DAP/Linter/Formatter management).
*   **Architecture:**
    *   `init.lua`: Entry point; bootstraps `lazy.nvim` and loads core modules.
    *   `lua/options.lua`: Standard Vim options and settings.
    *   `lua/keymaps.lua`: **Centralized repository for all keybindings.**
    *   `lua/plugins.lua`: Plugin declarations and lazy-loading logic.
    *   `lua/plugin_config/`: Individual configuration files for each plugin.
    *   `lua/util/`: Utility modules for cross-platform path resolution and keymap safety.
*   **Cross-Platform Support:** Uses `lua/util/paths.lua` to resolve platform-specific paths (e.g., Dropbox, Python virtualenvs). Includes shell templates for `zsh` (macOS) and `PowerShell` (Windows).

## Building and Running

Neovim configurations don't "build" in the traditional sense, but they require environment setup and plugin synchronization.

### Bootstrap Scripts
*   **macOS/Linux:** Run `./install.sh` to install system dependencies, link configs, and set up Python/Node/Rust environments. Use `./doctor.sh` to check environment health.
*   **Windows:** Run `install.bat` (via `cmd.exe`) for automated setup using `winget`. Use `doctor.bat` for health checks.

### Neovim Commands
*   `:Lazy`: Open the plugin manager UI to sync, update, or clean plugins.
*   `:Mason`: Open the tool manager UI for LSP, DAP, linters, and formatters.
*   `:MasonToolsInstall`: Manually trigger installation of tools defined in the config.
*   `:checkhealth`: Standard Neovim command to verify the health of the editor and its providers.

## Development Conventions

### Keybindings (Leader: `,`)
*   **Centralization:** All keymaps MUST be defined in `lua/keymaps.lua`. Do not scatter `vim.keymap.set` calls within plugin configuration files.
*   **Safety:** Use the `util.keymap` wrapper to detect and prevent duplicate keybindings.
*   **Navigation:**
    *   `hjkl` is enforced; **arrow keys are disabled** in Normal, Visual, and Operator modes.
    *   `jk` is mapped to `<ESC>` in Insert and Terminal modes.
    *   Seamless pane navigation between Neovim and terminal multiplexers (`tmux`/`psmux`) via `smart-splits`.
*   **LSP/DAP:** Standardized prefix `<leader>l` for Language/LSP actions and `<leader>d` for Debugging.

### Coding Style & Practices
*   **Python Provider:** Neovim uses a dedicated virtualenv (`~/.local/share/nvim-venv` on Mac, `%LOCALAPPDATA%/python-global` on Windows) managed by `uv`. This prevents dependency conflicts with system Python.
*   **Formatting:** Handled by `conform.nvim`. Format-on-save is enabled globally, except for files within the Obsidian vault (detected via Dropbox path).
*   **Linting:** Handled by `nvim-lint` for various languages (Python, Shell, JSON, etc.).
*   **Cross-Platform Paths:** Always use `require("util.paths")` for resolving paths to ensure compatibility across Windows and macOS.

## Key Files
*   `init.lua`: The heart of the configuration.
*   `lua/plugins.lua`: Defines the 40+ plugins used in this setup.
*   `lua/keymaps.lua`: The single source of truth for all shortcuts.
*   `lua/util/paths.lua`: Essential for maintaining cross-platform parity.
*   `CLAUDE.md`: Contains specific guidance for AI agents working on this codebase.
