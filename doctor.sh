#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OS="$(uname -s)"

# Prefer the directories used by the official AI CLI installers.
ABTOP_NATIVE_BIN="${ABTOP_INSTALL_DIR:-${CARGO_DIST_FORCE_INSTALL_DIR:-${CARGO_HOME:-$HOME/.cargo}}}/bin"
export PATH="${CODEX_INSTALL_DIR:-$HOME/.local/bin}:${GROK_BIN_DIR:-$HOME/.grok/bin}:$HOME/.local/bin:$ABTOP_NATIVE_BIN:$PATH"

# --- Counters ---
PASS=0
WARN=0
FAIL=0

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Output helpers ---
ok() {
    printf "${GREEN}  [OK]${RESET} %s\n" "$*"
    ((++PASS))
}

warn() {
    printf "${YELLOW}  [WARN]${RESET} %s\n" "$*"
    ((++WARN))
}

outdated() {
    printf "${YELLOW}  [OUTDATED]${RESET} %s\n" "$*"
    ((++WARN))
}

missing() {
    printf "${RED}  [MISSING]${RESET} %s\n" "$*"
    ((++FAIL))
}

section() {
    printf "\n${BOLD}=== %s ===${RESET}\n" "$*"
}

MIN_NVIM_VERSION="0.12.0"

version_at_least() {
    local version="${1#v}" required="${2#v}"
    version="${version%%-*}"
    required="${required%%-*}"

    local major minor patch req_major req_minor req_patch
    IFS=. read -r major minor patch <<< "$version"
    IFS=. read -r req_major req_minor req_patch <<< "$required"

    major=${major:-0}
    minor=${minor:-0}
    patch=${patch:-0}
    req_major=${req_major:-0}
    req_minor=${req_minor:-0}
    req_patch=${req_patch:-0}

    (( major > req_major )) && return 0
    (( major < req_major )) && return 1
    (( minor > req_minor )) && return 0
    (( minor < req_minor )) && return 1
    (( patch >= req_patch ))
}

nvim_version() {
    nvim --version 2>/dev/null | sed -n 's/^NVIM v\([0-9][^ ]*\).*/\1/p' | head -1
}

check_nvim() {
    if ! command -v nvim &>/dev/null; then
        missing "nvim — install with: brew install neovim"
        return
    fi

    local version
    version="$(nvim_version)"
    if [[ -n "$version" ]] && version_at_least "$version" "$MIN_NVIM_VERSION"; then
        ok "nvim — NVIM v$version"
    else
        outdated "nvim — NVIM v${version:-unknown} (requires >= $MIN_NVIM_VERSION; upgrade with: brew upgrade neovim)"
    fi
}

# --- Check a CLI tool is installed and show its version ---
# Usage: check_tool <cmd> [install_hint]
check_tool() {
    local cmd="$1"
    local hint="${2:-}"

    if command -v "$cmd" &>/dev/null; then
        local ver
        case "$cmd" in
            nvim)   ver=$(nvim --version 2>/dev/null | head -1) ;;
            git)    ver=$(git --version 2>/dev/null) ;;
            node)   ver=$(node --version 2>/dev/null) ;;
            npm)    ver=$(npm --version 2>/dev/null) ;;
            rg)     ver=$(rg --version 2>/dev/null | head -1) ;;
            fd)     ver=$(fd --version 2>/dev/null | head -1) ;;
            fzf)    ver=$(fzf --version 2>/dev/null | head -1) ;;
            starship) ver=$(starship --version 2>/dev/null | head -1) ;;
            eza)    ver=$(eza --version 2>/dev/null | head -1) ;;
            bat)    ver=$(bat --version 2>/dev/null | head -1) ;;
            zoxide) ver=$(zoxide --version 2>/dev/null) ;;
            uv)     ver=$(uv --version 2>/dev/null) ;;
            rustup) ver=$(rustup --version 2>/dev/null | head -1) ;;
            cargo)  ver=$(cargo --version 2>/dev/null) ;;
            tmux)   ver=$(tmux -V 2>/dev/null) ;;
            *)      ver=$(${cmd} --version 2>/dev/null | head -1 || echo "unknown") ;;
        esac
        ok "$cmd — $ver"
    else
        if [[ -n "$hint" ]]; then
            missing "$cmd — install with: $hint"
        else
            missing "$cmd"
        fi
    fi
}

check_tool_min_version() {
    local cmd="$1"
    local min_version="$2"
    local hint="${3:-}"

    if ! command -v "$cmd" &>/dev/null; then
        missing "$cmd — install with: $hint"
        return
    fi

    local ver_output version
    ver_output=$(${cmd} --version 2>/dev/null | head -1 || true)
    version=$(printf "%s\n" "$ver_output" | grep -Eo '[0-9]+(\.[0-9]+)+' | head -1)
    if [[ -n "$version" ]] && version_at_least "$version" "$min_version"; then
        ok "$cmd — $ver_output"
    else
        outdated "$cmd — ${ver_output:-unknown} (need >= $min_version; run: $hint)"
    fi
}

# --- Check the native binary created by website_cli_install in install.sh ---
check_website_cli() {
    local cmd="$1" binary="$2" hint="$3"
    if [[ -x "$binary" ]]; then
        local version
        version=$("$binary" --version 2>/dev/null | sed -n '1p' || true)
        ok "$cmd — ${version:-installed} ($binary)"
    else
        missing "$cmd website installation not found ($binary) — install with: $hint"
    fi
}

check_git_alias() {
    local name="$1" expected="$2" actual
    actual=$(git config --global --get "alias.$name" 2>/dev/null || true)
    if [[ "$actual" == "$expected" ]]; then
        ok "git $name matches install.sh"
    elif [[ -n "$actual" ]]; then
        outdated "git $name differs from install.sh — run: git config --global alias.$name '$expected'"
    else
        missing "git $name — run: git config --global alias.$name '$expected'"
    fi
}

# --- Check one of several equivalent commands is installed ---
# Usage: check_any_tool <label> <install_hint> <cmd> [cmd...]
check_any_tool() {
    local label="$1"
    local hint="$2"
    shift 2

    local cmd
    for cmd in "$@"; do
        if command -v "$cmd" &>/dev/null; then
            ok "$label — found $cmd"
            return 0
        fi
    done

    missing "$label — install with: $hint"
}

# --- Check a Homebrew cask is installed ---
check_brew_cask() {
    local cask="$1"
    local label="$2"

    if ! command -v brew &>/dev/null; then
        warn "$label — cannot check Homebrew cask (brew not found)"
        return
    fi

    if brew list --cask "$cask" &>/dev/null; then
        ok "$label — $cask cask installed"
    else
        missing "$label — install with: brew install --cask $cask"
    fi
}

# --- Check a library package that has no CLI to probe ---
check_brew_formula() {
    local formula="$1"
    if ! command -v brew &>/dev/null; then
        warn "$formula — cannot check Homebrew formula (brew not found)"
    elif brew list --formula "$formula" &>/dev/null; then
        ok "$formula installed"
    else
        missing "$formula — install with: brew install $formula"
    fi
}

# --- Check file exists ---
check_file() {
    local path="$1"
    local label="$2"
    if [[ -e "$path" ]]; then
        ok "$label exists ($path)"
        return 0
    else
        missing "$label not found ($path)"
        return 1
    fi
}

# --- Check config file exists and matches template ---
check_config() {
    local actual="$1"
    local template="$2"
    local label="$3"

    if [[ ! -e "$actual" ]]; then
        missing "$label not found ($actual)"
        return
    fi

    if [[ ! -e "$template" ]]; then
        warn "$label exists but template not found ($template)"
        return
    fi

    if diff -q "$actual" "$template" &>/dev/null; then
        ok "$label matches template"
    else
        outdated "$label differs from template ($actual vs $template)"
    fi
}

# =====================================================================
#  CHECKS START HERE
# =====================================================================

printf "${BOLD}Neovim Development Environment Doctor${RESET}\n"
printf "Running from: %s\n" "$SCRIPT_DIR"

# ----- Bootstrap prerequisites -----
section "Bootstrap prerequisites"
check_tool brew "https://brew.sh"

if [[ "$OS" == "Darwin" ]]; then
    section "Xcode and Metal"
    if DEV_DIR=$(xcode-select -p 2>/dev/null); then
        ok "Xcode Command Line Tools — $DEV_DIR"
    else
        missing "Xcode Command Line Tools — run: xcode-select --install"
        DEV_DIR=""
    fi
    XCODE_APP="/Applications/Xcode.app/Contents/Developer"
    if [[ -d "$XCODE_APP" ]]; then
        if [[ "$DEV_DIR" == "$XCODE_APP" ]]; then
            ok "Xcode developer directory selected"
        else
            warn "Xcode developer directory — run: sudo xcode-select -s $XCODE_APP"
        fi
        if xcrun metal --version &>/dev/null; then
            ok "Metal toolchain available"
        else
            warn "Metal toolchain — run: xcodebuild -downloadComponent MetalToolchain"
        fi
    else
        warn "Optional Xcode.app/Metal toolchain not installed (install.sh skips Metal without Xcode.app)"
    fi
fi

# ----- Core Tools -----
section "Core Tools"
check_nvim
check_tool git       "brew install git"
check_tool gh        "brew install gh"
if [[ "$OS" == "Linux" ]]; then
    check_tool pwsh  "sudo snap install powershell --classic"
fi
if [[ "$OS" == "Darwin" ]]; then
    check_tool code      "brew install --cask visual-studio-code"
    check_tool cursor    "brew install --cask cursor"
else
    check_tool code      "sudo snap install code --classic"
    warn "Cursor desktop is not installed by this Linux bootstrap; install it manually from https://cursor.com/download if needed."
fi
check_tool node      "brew install node"
check_tool npm       "(comes with node)"
check_any_tool "7-Zip" "brew install sevenzip" 7zz 7z
check_tool rg        "brew install ripgrep"
check_tool fd        "brew install fd"
check_tool fzf       "brew install fzf"
check_tool starship  "brew install starship"
check_tool eza       "brew install eza"
check_tool bat       "brew install bat"
check_tool btop      "brew install btop"
check_tool hexyl     "brew install hexyl"
check_tool zoxide    "brew install zoxide"
check_tool uv        "brew install uv"
check_tool rustup    "https://rustup.rs"
check_tool cargo     "(comes with rustup)"
check_tool tmux      "brew install tmux"
check_tool_min_version cmake "4.0.0" "brew upgrade cmake"
check_tool ninja     "brew install ninja"
check_tool doxygen   "brew install doxygen"
check_tool dot       "brew install graphviz"
check_tool clang-uml "brew install clang-uml"
if [[ "$OS" == "Darwin" ]]; then
    check_any_tool "OpenSCAD snapshot/nightly" "brew install --cask openscad@snapshot" openscad-nightly openscad
else
    check_any_tool "OpenSCAD snapshot/nightly" "sudo snap install openscad-nightly" openscad-nightly openscad
fi
check_tool plantuml  "brew install plantuml"
check_tool pre-commit "brew install pre-commit"
check_tool clang-format "brew install clang-format"
check_tool quarto    "brew install quarto"
check_tool ccache    "brew install ccache"
check_tool vulkaninfo "brew install vulkan-tools"
check_tool glslc     "brew install shaderc"
check_any_tool "glslang" "brew install glslang" glslang glslangValidator
check_brew_formula "vulkan-validationlayers"

if [[ -n "${VULKAN_SDK:-}" && -d "$VULKAN_SDK" && -x "$VULKAN_SDK/bin/glslc" ]]; then
    ok "VULKAN_SDK — $VULKAN_SDK"
else
    missing "VULKAN_SDK — run install.sh, then start a new shell or source ~/.zshrc"
fi

check_tool ffmpeg    "brew install ffmpeg"
check_website_cli "claude" "$HOME/.local/bin/claude" "curl -fsSL https://claude.ai/install.sh | bash"
check_website_cli "codex" "${CODEX_INSTALL_DIR:-$HOME/.local/bin}/codex" "curl -fsSL https://chatgpt.com/codex/install.sh | sh"
check_website_cli "agy" "$HOME/.local/bin/agy" "curl -fsSL https://antigravity.google/cli/install.sh | bash"
check_website_cli "grok" "${GROK_BIN_DIR:-$HOME/.grok/bin}/grok" "curl -fsSL https://x.ai/cli/install.sh | bash"
check_website_cli "abtop" "$ABTOP_NATIVE_BIN/abtop" "curl -fsSL https://github.com/graykode/abtop/releases/latest/download/abtop-installer.sh | sh"
check_tool gemini    "npm install -g @google/gemini-cli"

if [[ "$OS" == "Darwin" ]]; then
    check_brew_cask "db-browser-for-sqlite" "DB Browser for SQLite"
    check_brew_cask "blackhole-2ch" "BlackHole 2ch"
    check_brew_cask "chatgpt" "ChatGPT"
    check_brew_cask "claude" "Claude Desktop"
    check_brew_cask "antigravity" "Google Antigravity"
    check_brew_cask "openscad@snapshot" "OpenSCAD snapshot"
else
    warn "ChatGPT and Claude Desktop are not officially available on Linux; CLI checks cover Linux."
fi

# ----- Python Environment -----
section "Python Environment"

if command -v uv &>/dev/null; then
    ok "uv is installed"

    if uv python list --only-installed 2>/dev/null | grep -E '^cpython-3\.12\.' >/dev/null; then
        ok "Python 3.12 available via uv"
    else
        missing "Python 3.12 not available via uv — install with: uv python install 3.12"
    fi
else
    missing "uv not installed — brew install uv"
fi

NVIM_VENV_PYTHON="$HOME/.local/share/nvim-venv/bin/python"
if [[ -x "$NVIM_VENV_PYTHON" ]]; then
    if "$NVIM_VENV_PYTHON" -c 'import sys; sys.exit(sys.version_info[:2] != (3, 12))' 2>/dev/null; then
        ok "nvim-venv uses Python 3.12 ($NVIM_VENV_PYTHON)"
    else
        outdated "nvim-venv is not using Python 3.12 ($NVIM_VENV_PYTHON)"
    fi

    if PYNVIM_VER=$("$NVIM_VENV_PYTHON" -c "import pynvim; print(pynvim.__version__)" 2>/dev/null); then
        ok "pynvim installed — $PYNVIM_VER"
    else
        missing "pynvim not installed in nvim-venv — uv pip install --python \"$NVIM_VENV_PYTHON\" pynvim"
    fi

    if PYYAML_VER=$("$NVIM_VENV_PYTHON" -c "import yaml; print(yaml.__version__)" 2>/dev/null); then
        ok "PyYAML installed — $PYYAML_VER"
    else
        missing "PyYAML not installed in nvim-venv — uv pip install --python \"$NVIM_VENV_PYTHON\" PyYAML"
    fi
else
    missing "nvim-venv Python not found ($NVIM_VENV_PYTHON)"
fi

if command -v npm &>/dev/null; then
    if npm list -g neovim &>/dev/null; then
        NEOVIM_NODE_VER=$(npm list -g neovim 2>/dev/null | grep neovim || echo "unknown")
        ok "neovim node provider installed — $NEOVIM_NODE_VER"
    else
        missing "neovim node provider — install with: npm install -g neovim"
    fi
else
    warn "npm not found, cannot check neovim node provider"
fi

# ----- Config Files -----
section "Config Files"
check_config "$HOME/.zshrc"              "$SCRIPT_DIR/zshrc.template"          "zshrc"
check_config "$HOME/.config/starship.toml" "$SCRIPT_DIR/starship.toml.template"  "Starship config"
check_config "$HOME/.tmux.conf"          "$SCRIPT_DIR/tmux.conf.template"      "Tmux config"

# ----- Git aliases -----
section "Git aliases"
check_git_alias "lol" "log --graph --decorate --pretty=oneline --abbrev-commit"
check_git_alias "lola" "log --graph --decorate --pretty=oneline --abbrev-commit --all"

# ----- Neovim Config Link -----
section "Neovim Config Link"

NVIM_CONFIG="$HOME/.config/nvim"
if [[ -L "$NVIM_CONFIG" ]]; then
    TARGET=$(readlink -f "$NVIM_CONFIG" 2>/dev/null || readlink "$NVIM_CONFIG")
    EXPECTED=$(cd "$SCRIPT_DIR" && pwd -P)
    if [[ "$TARGET" == "$EXPECTED" ]]; then
        ok "~/.config/nvim symlinks to $TARGET"
    else
        warn "~/.config/nvim symlinks to $TARGET (expected $EXPECTED)"
    fi
elif [[ -d "$NVIM_CONFIG" ]]; then
    ACTUAL=$(cd "$NVIM_CONFIG" && pwd -P)
    EXPECTED=$(cd "$SCRIPT_DIR" && pwd -P)
    if [[ "$ACTUAL" == "$EXPECTED" ]]; then
        ok "~/.config/nvim IS the config directory ($ACTUAL)"
    else
        warn "~/.config/nvim exists ($ACTUAL) but is not $EXPECTED"
    fi
else
    missing "~/.config/nvim does not exist"
fi

# ----- Neovim Health -----
section "Neovim Health"

LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [[ -d "$LAZY_DIR" ]]; then
    ok "lazy.nvim installed ($LAZY_DIR)"
else
    missing "lazy.nvim not found ($LAZY_DIR) — open nvim to bootstrap"
fi

MASON_BIN="$HOME/.local/share/nvim/mason/bin"
if [[ -d "$MASON_BIN" ]]; then
    ok "Mason bin directory exists ($MASON_BIN)"
    TOOLS=$(ls "$MASON_BIN" 2>/dev/null || true)
    if [[ -n "$TOOLS" ]]; then
        printf "       Installed Mason tools:\n"
        for tool in $TOOLS; do
            printf "         - %s\n" "$tool"
        done
    else
        warn "Mason bin directory is empty — open nvim and run :Mason"
    fi
else
    missing "Mason bin directory not found ($MASON_BIN) — open nvim and run :Mason"
fi

# ----- Tmux -----
section "Tmux"

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ -d "$TPM_DIR" ]]; then
    ok "TPM installed ($TPM_DIR)"
else
    missing "TPM not found — git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
fi

FZF_ZSH="$HOME/.fzf.zsh"
if [[ -e "$FZF_ZSH" ]]; then
    ok "fzf shell integration exists ($FZF_ZSH)"
else
    warn "fzf shell integration not found ($FZF_ZSH) — run: \$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish"
fi

# ----- Font -----
section "Font"

FONT_FOUND=false
for dir in "$HOME/Library/Fonts" "/Library/Fonts" "$HOME/.local/share/fonts" "$HOME/.fonts" "/usr/share/fonts" "/usr/local/share/fonts"; do
    if [[ -d "$dir" ]]; then
        if find "$dir" -type f -iname '*JetBrainsMono*Nerd*' -print 2>/dev/null | grep . >/dev/null; then
            FONT_FOUND=true
            ok "JetBrainsMono Nerd Font found in $dir"
            break
        fi
    fi
done

if [[ "$FONT_FOUND" == false ]]; then
    if [[ "$OS" == "Darwin" ]]; then
        warn "JetBrainsMono Nerd Font not found — install with: brew install --cask font-jetbrains-mono-nerd-font"
    else
        warn "JetBrainsMono Nerd Font not found — install from https://www.nerdfonts.com"
    fi
fi

# =====================================================================
#  SUMMARY
# =====================================================================

printf "\n${BOLD}--- Summary ---${RESET}\n"
printf "${GREEN}%d passed${RESET}, ${YELLOW}%d warnings${RESET}, ${RED}%d errors${RESET}\n" "$PASS" "$WARN" "$FAIL"

if [[ "$FAIL" -gt 0 ]]; then
    exit 1
elif [[ "$WARN" -gt 0 ]]; then
    exit 0
else
    printf "\n${GREEN}Everything looks good!${RESET}\n"
    exit 0
fi
