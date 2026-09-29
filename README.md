# My Config, Mac & PC

Cross-platform development environment — Neovim, shell, terminal multiplexer, formatters, linters, and LSP — that stays in sync across Windows and macOS. Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Quick Start

Clone the repo and run the bootstrap script for your platform. It installs development tools, sets up Python/Node/Rust, and configures your shell and terminal. Re-running it skips existing installations where supported.

**Windows** (run in an elevated `cmd.exe`):
```bat
git clone <repo-url> "%LOCALAPPDATA%\nvim"
cd "%LOCALAPPDATA%\nvim"
install.bat
```

**Mac / Linux:**
```sh
git clone <repo-url> ~/.config/nvim
cd ~/.config/nvim
./install.sh
```

### What `install` does

1. **Installs development tools** — Neovim, Git/GitHub CLI, Node, shell utilities, Rust, CMake/Ninja, Doxygen, Quarto, ccache, Graphviz/clang-uml/PlantUML, pre-commit, clang-format, FFmpeg, and Vulkan/shader tools. Uses Homebrew for macOS/Linux CLI packages and WinGet/Chocolatey on Windows; Windows uses `cargo install psmux` for its terminal multiplexer.
2. **Sets up Python** — installs Python 3.12 via `uv`, creates `~/.local/share/nvim-venv` on macOS/Linux or `%LOCALAPPDATA%\python-global` on Windows, and installs `pynvim` and `PyYAML` there.
3. **Sets up Node / AI tools** — installs the `neovim` npm provider, uses the official website installers for Claude Code (`claude`), Codex (`codex`), Antigravity CLI (`agy`), and Grok (`grok`), and uses npm for Gemini CLI. See [AI CLI installers](#ai-cli-installers-all-platforms).
4. **Installs desktop apps** — macOS includes VS Code, Cursor, DB Browser for SQLite, BlackHole 2ch, OpenSCAD snapshot, ChatGPT, Claude, and Antigravity. Windows includes VS Code, Cursor, OpenSCAD Nightly, Codex App, Claude, and Antigravity.
5. **Sets up configuration** — symlinks `.zshrc`, `starship.toml`, and `.tmux.conf` on macOS/Linux; copies the PowerShell profile, Starship, and psmux templates on Windows. Also configures the `git lol` and `git lola` aliases.
6. **Sets up fonts and terminal integration** — installs JetBrainsMono Nerd Font, configures fzf and TPM on macOS/Linux, and installs PSFzf and creates the psmux plugin directory on Windows. Terminal plugin installation still requires the manual steps printed by the installer.
7. **Checks macOS developer tools** — installs Xcode Command Line Tools; selects Xcode.app and downloads the Metal toolchain when Xcode.app is present.

Linux uses Homebrew for CLI packages and snap for PowerShell, VS Code, and OpenSCAD when snap is available. The current font step still invokes a macOS Homebrew cask, so the Linux bootstrap needs that step adapted before it can complete.

On Windows, the current installer skips the Gemini npm step if the Neovim npm provider is already installed. If doctor reports Gemini missing, run `npm install -g @google/gemini-cli`.

After install, open Neovim — lazy.nvim bootstraps itself, installs all plugins, and Mason auto-installs LSP servers, formatters, and linters on first launch.

### Validating your setup

Run `doctor` to check environment health without changing anything:

**Windows:**
```bat
doctor.bat
```

**Mac / Linux:**
```sh
./doctor.sh
```

Doctor covers the tools, apps, and configuration listed by the installer, plus Neovim's first-launch setup. It checks CLI availability, desktop packages, installed Python 3.12 and the dedicated venv, Python/Node providers, config templates, Git alias values, the Vulkan environment, fonts, and terminal integration. macOS also checks Xcode/Metal, glslang, and Vulkan validation layers; Windows checks PSFzf and the psmux plugin directory.

The four AI CLI checks require binaries in the website installers' native locations. An older Homebrew, npm, or WinGet copy elsewhere on PATH does not satisfy these checks. `CODEX_INSTALL_DIR` and `GROK_BIN_DIR` overrides are respected by both install and doctor.

Results show `[OK]`, `[WARN]`, `[OUTDATED]`, or `[MISSING]`, with repair hints where applicable. Doctor exits with status 1 when errors are found; warnings alone return status 0.

---

## Screenshots

### PC

[<img src="./Screenshot-pc.png" alt="PC setup screenshot" width="100%" />](./Screenshot-pc.png)

### Mac

[<img src="./Screenshot-mac.png" alt="Mac setup screenshot" width="100%" />](./Screenshot-mac.png)

---

## Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── ginit.vim                   # GUI-specific Neovim settings
├── vsinit.vim                  # Minimal Vim-style fallback config
├── karabiner.json              # Mac keyboard remap snippet
├── lua/
│   ├── options.lua             # Vim options
│   ├── keymaps.lua             # Key mappings
│   ├── plugins.lua             # Plugin declarations (lazy.nvim)
│   ├── session.lua             # Project session persistence
│   ├── util/
│   │   ├── keymap.lua          # Shared keymap helper / duplicate guard
│   │   └── paths.lua           # Shared path helpers / Python provider resolution
│   └── plugin_config/          # Per-plugin configuration
│       ├── init.lua            # (intentionally empty — configs loaded via lazy.nvim)
│       ├── dap.lua             # DAP debugger (nvim-dap, codelldb for C/C++/Rust)
│       ├── lsp.lua             # LSP + mason-lspconfig
│       ├── formatting.lua      # Formatting via conform.nvim
│       ├── linting.lua         # Linting via nvim-lint
│       ├── treesitter.lua      # Treesitter
│       ├── telescope.lua       # Fuzzy finder
│       ├── completions.lua     # blink.cmp
│       ├── mason.lua           # Mason + tool installer
│       ├── colorscheme.lua     # Colorscheme
│       ├── aerial.lua          # Code outline
│       ├── gitsigns.lua        # Git signs
│       ├── harpoon.lua         # Harpoon
│       ├── flash.lua           # Flash motion
│       ├── lualine.lua         # Status line
│       ├── mini-files.lua      # Mini file explorer
│       ├── neotest.lua         # Test runner integration
│       ├── obsidian.lua        # Obsidian integration
│       ├── pre-init.lua        # Pre-init hooks
│       ├── quickfix.lua        # Quickfix
│       ├── rustaceanvim.lua    # Rust tools
│       ├── scratch.lua         # Scratch buffer
│       ├── twilight.lua        # Twilight (focus mode)
│       ├── ufo.lua             # Folding
│       ├── which_key.lua       # Which-key
│       └── zen_mode.lua        # Zen mode
├── Screenshot-mac.png          # Mac reference screenshot
├── Screenshot-pc.png           # Windows reference screenshot
├── zshrc.template              # Mac shell config template (zsh)
├── profile.ps1.template        # Windows shell config template (PowerShell)
├── starship.toml.template      # Starship prompt config (all platforms)
├── tmux.conf.template          # tmux config template (Mac)
└── tmux.windows.conf.template  # tmux/psmux config template (Windows)
```

---

## Prerequisites

### Mac

Install packages via [Homebrew](https://brew.sh):

```sh
brew install neovim
brew install git
brew install gh             # GitHub CLI
brew install ripgrep       # telescope live_grep
brew install fd            # telescope file search
brew install fzf           # fzf.zsh shell integration
brew install node          # LSP servers
brew install starship      # shell prompt
brew install eza           # ls replacement (aliased in .zshrc)
brew install bat           # cat replacement (aliased in .zshrc)
brew install tmux          # terminal multiplexer
brew install uv            # Python version manager + package installer
brew install zoxide        # smart directory jumping (z command)
brew install btop          # system monitor (CPU, RAM, disk, network)
brew install hexyl         # hex viewer
brew install sevenzip      # 7-Zip command-line tools
brew install ffmpeg        # video capture / encoding support
brew install graphviz      # dot / dependency graph rendering
brew install clang-uml     # UML diagram generation from C++ source
brew install plantuml      # PlantUML renderer (used by gen_uml.py)
brew install cmake         # build system
brew install ninja doxygen quarto ccache
brew install pre-commit clang-format
brew install vulkan-tools vulkan-validationlayers shaderc glslang
```

#### Desktop apps (Mac)

These desktop packages are installed by `install.sh`. AI CLIs use the separate [website installers](#ai-cli-installers-all-platforms).

```sh
brew install --cask openscad@snapshot
brew install --cask visual-studio-code cursor db-browser-for-sqlite blackhole-2ch
brew install --cask chatgpt claude antigravity
```

#### Optional (Mac)

```sh
brew install mactex        # for vimtex / LaTeX support
```

---

### Windows

Install [Chocolatey](https://chocolatey.org/install) (run in an elevated PowerShell):

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Install packages via [winget](https://learn.microsoft.com/en-us/windows/package-manager/winget/) (built into Windows 11):

```powershell
winget install Neovim.Neovim
winget install Git.Git
winget install GitHub.cli
winget install Microsoft.PowerShell
winget install Microsoft.VisualStudioCode
winget install Anysphere.Cursor
winget install 7zip.7zip
winget install BurntSushi.ripgrep.MSVC   # telescope live_grep
winget install sharkdp.fd                # telescope file search
winget install junegunn.fzf              # fzf integration
winget install OpenJS.NodeJS.LTS         # LSP servers
winget install Starship.Starship         # shell prompt
winget install eza-community.eza         # ls replacement
winget install sharkdp.bat              # cat replacement
winget install astral-sh.uv              # Python version manager + package installer
winget install ajeetdsouza.zoxide        # smart directory jumping (z command)
winget install aristocratos.btop4win     # system monitor (CPU, RAM, disk, network)
winget install sharkdp.hexyl             # hex viewer
winget install Gyan.FFmpeg               # video capture / encoding support
winget install Graphviz.Graphviz         # dot / dependency graph rendering
winget install bkryza.clang-uml         # UML diagram generation from C++ source
winget install OpenSCAD.OpenSCAD.Nightly # latest OpenSCAD beta/nightly
winget install --source msstore --id 9PLM9XGG6VKS # Codex App
winget install Anthropic.Claude          # Claude App
winget install Google.Antigravity        # Google Antigravity App
choco install plantuml                   # PlantUML renderer (used by gen_uml.py)
winget install Kitware.CMake             # build system
winget install Ninja-build.Ninja
winget install DimitriVanHeesch.Doxygen
winget install Posit.Quarto
winget install Ccache.Ccache
winget install KhronosGroup.VulkanSDK
winget install LLVM.LLVM
uv tool install pre-commit
```

Install [psmux](https://github.com/marlocarlo/psmux) for terminal multiplexing (tmux-compatible, written in Rust):

```powershell
cargo install psmux
```

Install the PSFzf PowerShell module for fzf shell integration:

```powershell
Install-Module PSFzf -Scope CurrentUser -Force -AllowClobber
```

#### Optional (Windows)

```powershell
winget install MiKTeX.MiKTeX     # for vimtex / LaTeX support
```

---

### Python (all platforms)

Python is managed by [uv](https://github.com/astral-sh/uv) — a fast Rust-based tool that replaces pyenv, pip, and virtualenv.

Install Python 3.12, matching the bootstrap scripts:

```sh
uv python install 3.12
```

Create the dedicated Neovim virtualenv and install its Python packages:

**Windows:**
```powershell
uv venv --python 3.12 "$env:LOCALAPPDATA\python-global"
uv pip install --python "$env:LOCALAPPDATA\python-global\Scripts\python.exe" pynvim PyYAML
# Add to PATH (run once):
$p = [System.Environment]::GetEnvironmentVariable("PATH","User") -split ";"
[System.Environment]::SetEnvironmentVariable("PATH", ("$env:LOCALAPPDATA\python-global\Scripts;" + ($p -join ";")), "User")
```

**Mac / Linux:**
```sh
uv venv --python 3.12 ~/.local/share/nvim-venv
uv pip install --python ~/.local/share/nvim-venv/bin/python pynvim PyYAML
```

The venv bin is already on PATH via the `zshrc.template` (`~/.local/share/nvim-venv/bin`).

On macOS/Linux, add a `py` alias to your shell config so `py` works like on Windows:

```sh
alias py=python3
```

### AI CLI installers (all platforms)

The bootstrap scripts use these official website installers and skip a CLI when its native binary already exists.

**Mac / Linux:**

```sh
curl -fsSL https://claude.ai/install.sh | bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
curl -fsSL https://antigravity.google/cli/install.sh | bash
curl -fsSL https://x.ai/cli/install.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://claude.ai/install.ps1 | iex
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://chatgpt.com/codex/install.ps1 | iex"
irm https://antigravity.google/cli/install.ps1 | iex
irm https://x.ai/cli/install.ps1 | iex
```

Default binary locations checked by doctor:

| CLI | macOS / Linux | Windows |
| --- | --- | --- |
| `claude` | `~/.local/bin/claude` | `%USERPROFILE%\.local\bin\claude.exe` |
| `codex` | `~/.local/bin/codex` | `%LOCALAPPDATA%\Programs\OpenAI\Codex\bin\codex.exe` |
| `agy` | `~/.local/bin/agy` | `%LOCALAPPDATA%\agy\bin\agy.exe` |
| `grok` | `~/.grok/bin/grok` | `%USERPROFILE%\.grok\bin\grok.exe` |

### npm packages (all platforms)

```sh
npm install -g neovim             # Neovim Node.js provider
npm install -g @google/gemini-cli  # Gemini CLI
```

---

## Neovim Setup

### Mac

1. Clone this repo to `~/.config/nvim`
2. Open Neovim — lazy.nvim will bootstrap itself and install all plugins automatically
3. Mason will install LSP servers and formatter/linter tools on first start, or run `:MasonToolsInstall` manually

### Windows

1. Clone this repo to `~\AppData\Local\nvim`

```powershell
git clone <repo-url> "$env:LOCALAPPDATA\nvim"
```

2. Open Neovim — lazy.nvim will bootstrap and install all plugins automatically
3. Mason will install LSP servers and formatter/linter tools on first start, or run `:MasonToolsInstall` manually

### LSP servers (via Mason)

Automatically installed via `mason-lspconfig`:
- `lua_ls` — Lua
- `rust_analyzer` — Rust
- `clangd` — C/C++
- `neocmake` — CMake

Configured, but not auto-installed:
- `openscad_lsp` — OpenSCAD (install manually via Mason if needed)

### Debug adapters (via Mason)

Automatically installed via `mason-nvim-dap`:
- `codelldb` — C, C++, and Rust (via `nvim-dap` + `nvim-dap-ui`)

Debugger keybindings (all under `<leader>d`):

| Key          | Action                        |
|--------------|-------------------------------|
| `<leader>db` | Toggle breakpoint             |
| `<leader>dB` | Conditional breakpoint        |
| `<leader>dc` | Continue                      |
| `<leader>di` | Step into                     |
| `<leader>do` | Step over                     |
| `<leader>dO` | Step out                      |
| `<leader>dq` | Terminate session             |
| `<leader>dr` | Restart session               |
| `<leader>dl` | Run last config               |
| `<leader>du` | Toggle DAP UI                 |
| `<leader>de` | Eval expression (normal/visual)|
| `<leader>dh` | Hover value under cursor      |

The UI opens automatically when a debug session starts and closes when it ends.

### Rust

**Mac / Linux:**

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

**Windows:**

```powershell
winget install Rustlang.Rustup
```

`rust_analyzer` will be handled by Mason, but the Rust toolchain itself must be present.

### Formatting and linting

Formatting is handled by `conform.nvim`; linting is handled by `nvim-lint`.

- `:Format` or `<leader>lf` — format the current buffer
- `:Lint` or `<leader>ll` — lint the current buffer

Configured formatters:
- Lua: `stylua`
- Python: `ruff format`
- Rust: `rustfmt`
- C/C++: `clang-format`
- JSON / YAML: `prettierd` (with `prettier` fallback)
- Markdown: `prettierd` — format on save for all markdown **except** files inside the Obsidian vault path
- TOML: `taplo`
- Shell: `shfmt`

Configured linters:
- JSON: `jsonlint`
- YAML: `yamllint`
- Markdown: `markdownlint`
- Python: `ruff`
- Shell: `shellcheck`

### Project sessions

Project sessions are stored under `stdpath('state')/sessions` and keyed by git root when available, otherwise by the current working directory.

- Auto-restore runs only when Neovim starts with no file arguments
- Auto-save runs on exit
- `:SessionSave` or `<leader>ps` saves the current project session
- `:SessionRestore` or `<leader>pr` restores the current project session
- `:SessionRestore!` forces a restore even if you have modified buffers
- `:SessionDelete` or `<leader>px` deletes the current project session file

---

## Shell Setup

### Mac (zsh)

Copy `zshrc.template` to `~/.zshrc`. Dropbox path is auto-detected from `~/.dropbox/info.json`.

After installing `fzf` via brew, run the shell integration installer:

```sh
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish
```

This creates `~/.fzf.zsh` which is sourced by the `.zshrc` template.

### Windows (PowerShell)

Copy `profile.ps1.template` to your PS7 (`pwsh`) profile:

```powershell
Copy-Item profile.ps1.template "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
```

If execution policy blocks the profile, enable it once:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

The template also imports the Chocolatey profile module and `PSFzf`, so both need to be installed before the profile will load cleanly.

### Starship prompt (all platforms)

Copy `starship.toml.template` to `~/.config/starship.toml`:

**Mac / Linux:**
```sh
cp starship.toml.template ~/.config/starship.toml
```

**Windows:**
```powershell
cp starship.toml.template "$HOME\.config\starship.toml"
```

The config uses the **catppuccin-powerline** preset. It requires **JetBrainsMono Nerd Font Mono**.

Install on Mac via Homebrew:
```sh
brew install --cask font-jetbrains-mono-nerd-font
```

Set the font in your terminal emulator:
- **Mac (iTerm2):** Preferences → Profiles → Text → Font → select `JetBrainsMono Nerd Font Mono`
- **Mac (Warp):** Settings → Appearance → Terminal Font
- **Windows Terminal:** Settings → your profile → Appearance → Font face
> **Windows note:** the PowerShell template adds the WinGet-installed `uv` path dynamically, and `command_timeout = 5000` keeps Starship tolerant of slower version probes.

### Windows Terminal color scheme

Set the color scheme to **Dimidium** (Settings → your profile → Appearance → Color scheme) for well-balanced ANSI colors that work well with eza, starship, and Neovim.

### zoxide (all platforms)

`zoxide` is already configured in both shell templates. It learns your most-used directories over time.

```sh
z foo        # jump to most frecent directory matching "foo"
z foo bar    # match multiple terms
zi foo       # interactive fuzzy search (requires fzf)
```

Just use `cd` normally at first — zoxide builds its database from your navigation history.

---

## Neovim Terminal

A persistent terminal is provided by `toggleterm.nvim`:

- `<C-\>` — toggle a horizontal terminal split (state is preserved between toggles)
- `<Esc>` in terminal mode — return to normal mode
- `<C-h/j/k/l>` in terminal mode — navigate to adjacent splits (via smart-splits)

## Optional Platform Files

- `ginit.vim` is used by Neovim GUIs such as Neovide and sets the GUI font, mouse behavior, and font-size keybindings.
- `vsinit.vim` is a small Vim-style fallback config with basic movement and search mappings.
- `karabiner.json` is a Karabiner-Elements profile snippet for Mac keyboard remaps.

---

## Terminal Multiplexer

### Mac (tmux)

Copy `tmux.conf.template` to `~/.tmux.conf`.

Install [TPM](https://github.com/tmux-plugins/tpm) (tmux plugin manager):

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then open tmux and press `prefix + I` (Ctrl-s + I) to install plugins:
- `vim-tmux-navigator` — seamless pane navigation between tmux and Neovim
- `catppuccin/tmux` — Catppuccin Mocha status bar theme with rounded separators (v2.x API)
- `tmux-cpu` — provides `#{cpu_percentage}` and `#{ram_percentage}` for the status bar
- `tmux-weather` — weather in the status bar (location: York, °C) via `xamut/tmux-weather`
- `tmux-resurrect` — save/restore sessions manually (`prefix + Ctrl-s` to save, `prefix + Ctrl-r` to restore)
- `tmux-continuum` — auto-saves session every 15 min; restores automatically on tmux start
- `tmux-prefix-highlight` — highlights status bar when prefix key is active

> **Catppuccin v2.x note:** The plugin must be loaded with `run` *before* setting `status-left`/`status-right`, and TPM must `run` *after*. Use `set -gF`/`set -agF` with `#{E:@catppuccin_status_<module>}` for status modules. Use `#{l:#{var}}` in any custom module text to prevent early expansion of tmux-cpu variables.

Prefix is bound to `Ctrl-s`. Key highlights:
- `prefix + |` / `prefix + -` — split pane horizontally / vertically
- `prefix + h/j/k/l` — navigate panes (vim-style)
- `prefix + Enter` — enter copy mode; `v` to select, `y` to copy to clipboard
- `prefix + Ctrl-s` / `prefix + Ctrl-r` — save / restore session (tmux-resurrect)

### Windows (psmux)

[psmux](https://github.com/marlocarlo/psmux) is a native Windows terminal multiplexer written in Rust. It is tmux-compatible (76 tmux commands supported), reads your existing `.tmux.conf`, and ships `tmux`/`pmux` aliases so muscle memory transfers directly from Mac.

```powershell
cargo install psmux
```

Install [PPM](https://github.com/marlocarlo/psmux-plugins) and plugins:

```powershell
git clone --depth 1 https://github.com/marlocarlo/psmux-plugins.git "$env:TEMP\psmux-plugins"
Copy-Item "$env:TEMP\psmux-plugins\ppm" "$HOME\.psmux\plugins\ppm" -Recurse
Copy-Item "$env:TEMP\psmux-plugins\psmux-theme-catppuccin" "$HOME\.psmux\plugins\psmux-theme-catppuccin" -Recurse
Copy-Item "$env:TEMP\psmux-plugins\psmux-cpu" "$HOME\.psmux\plugins\psmux-cpu" -Recurse
Copy-Item "$env:TEMP\psmux-plugins\psmux-resurrect" "$HOME\.psmux\plugins\psmux-resurrect" -Recurse
Copy-Item "$env:TEMP\psmux-plugins\psmux-continuum" "$HOME\.psmux\plugins\psmux-continuum" -Recurse
Copy-Item "$env:TEMP\psmux-plugins\psmux-prefix-highlight" "$HOME\.psmux\plugins\psmux-prefix-highlight" -Recurse
Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force
```

Remove `~\.psmux.conf` if it exists — psmux checks for it before `~\.tmux.conf` and will ignore your tmux config if both are present:

```powershell
Remove-Item "$HOME\.psmux.conf" -ErrorAction SilentlyContinue
```

Copy `tmux.windows.conf.template` to `~\.tmux.conf`:

```powershell
cp tmux.windows.conf.template "$HOME\.tmux.conf"
```

Plugins:
- `psmux-theme-catppuccin` — Catppuccin Mocha status bar theme (powerline, rounded separators); status modules configured via `@catppuccin-status-modules-right`
- `psmux-cpu` — CPU% and RAM usage in the status bar (`cpu` and `ram` modules)
- `psmux-resurrect` — save/restore sessions manually (`prefix + Ctrl-s` to save, `prefix + Ctrl-r` to restore)
- `psmux-continuum` — auto-saves session every 15 min; restores automatically on psmux start
- `psmux-prefix-highlight` — highlights status bar when prefix key is active
Prefix is bound to `Ctrl-s`. Key highlights:
- `prefix + |` / `prefix + -` — split pane horizontally / vertically
- `prefix + h/j/k/l` — navigate panes (vim-style)
- `prefix + Enter` — enter copy mode; `v` to select, `y` to copy to clipboard
- `prefix + Ctrl-s` / `prefix + Ctrl-r` — save / restore session (psmux-resurrect)
