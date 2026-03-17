#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# ----- Core Tools -----
section "Core Tools"
check_tool nvim      "https://neovim.io or brew install neovim"
check_tool git       "brew install git"
check_tool node      "brew install node"
check_tool npm       "(comes with node)"
check_tool rg        "brew install ripgrep"
check_tool fd        "brew install fd"
check_tool fzf       "brew install fzf"
check_tool starship  "brew install starship"
check_tool eza       "brew install eza"
check_tool bat       "brew install bat"
check_tool zoxide    "brew install zoxide"
check_tool uv        "brew install uv"
check_tool rustup    "https://rustup.rs"
check_tool cargo     "(comes with rustup)"
check_tool tmux      "brew install tmux"
check_tool cmake     "brew install cmake"

# ----- Python Environment -----
section "Python Environment"

if command -v uv &>/dev/null; then
    ok "uv is installed"

    if uv python list 2>/dev/null | grep -q "3\.12"; then
        ok "Python 3.12 available via uv"
    else
        missing "Python 3.12 not available via uv — install with: uv python install 3.12"
    fi
else
    missing "uv not installed — brew install uv"
fi

NVIM_VENV_PYTHON="$HOME/.local/share/nvim-venv/bin/python"
if [[ -x "$NVIM_VENV_PYTHON" ]]; then
    ok "nvim-venv Python exists ($NVIM_VENV_PYTHON)"

    if PYNVIM_VER=$("$NVIM_VENV_PYTHON" -c "import pynvim; print(pynvim.__version__)" 2>/dev/null); then
        ok "pynvim installed — $PYNVIM_VER"
    else
        missing "pynvim not installed in nvim-venv — $NVIM_VENV_PYTHON -m pip install pynvim"
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
    warn "fzf shell integration not found ($FZF_ZSH) — run: \$(brew --prefix)/opt/fzf/install"
fi

# ----- Font -----
section "Font"

FONT_FOUND=false
for dir in "$HOME/Library/Fonts" "/Library/Fonts" "/usr/share/fonts" "/usr/local/share/fonts"; do
    if [[ -d "$dir" ]]; then
        if ls "$dir" 2>/dev/null | grep -qi "JetBrainsMono.*Nerd"; then
            FONT_FOUND=true
            ok "JetBrainsMono Nerd Font found in $dir"
            break
        fi
    fi
done

if [[ "$FONT_FOUND" == false ]]; then
    warn "JetBrainsMono Nerd Font not found — install from https://www.nerdfonts.com"
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
