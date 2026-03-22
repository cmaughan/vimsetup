#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------------------------
# Bootstrap development environment (macOS / Linux)
# Idempotent -- safe to re-run at any time.
# ---------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ── Colours & helpers ─────────────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
BOLD='\033[1m'
NC='\033[0m' # No Colour

ok()      { printf "${GREEN}  [OK]${NC} %s\n" "$*"; }
skip()    { printf "${YELLOW}  [SKIP]${NC} %s\n" "$*"; }
info()    { printf "${BLUE}  [INFO]${NC} %s\n" "$*"; }
err()     { printf "${RED}  [ERROR]${NC} %s\n" "$*" >&2; }
section() { printf "\n${BOLD}── %s ──${NC}\n" "$*"; }

# ── 1. Detect OS ──────────────────────────────────────────────────────────

section "Detecting operating system"

OS="$(uname -s)"
case "$OS" in
    Darwin) ok "macOS detected" ;;
    Linux)  ok "Linux detected"  ;;
    *)      err "Unsupported OS: $OS"; exit 1 ;;
esac

# ── 2. Install Homebrew ───────────────────────────────────────────────────

section "Checking Homebrew"

if command -v brew &>/dev/null; then
    ok "Homebrew already installed ($(brew --prefix))"
else
    info "Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Make brew available in this session
    if [[ "$OS" == "Linux" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || true)"
    fi
    if [[ "$OS" == "Darwin" && -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    ok "Homebrew installed"
fi

# ── 3. Xcode (macOS only) ─────────────────────────────────────────────────

if [[ "$OS" == "Darwin" ]]; then
    section "Xcode Command Line Tools"

    if xcode-select -p &>/dev/null; then
        skip "Xcode CLI tools already installed ($(xcode-select -p))"
    else
        info "Installing Xcode Command Line Tools ..."
        xcode-select --install
        # Wait for installation to complete
        until xcode-select -p &>/dev/null; do sleep 5; done
        ok "Xcode Command Line Tools installed"
    fi

    section "Xcode developer directory"

    XCODE_APP="/Applications/Xcode.app/Contents/Developer"
    CURRENT_DEV="$(xcode-select -p 2>/dev/null)"

    if [[ "$CURRENT_DEV" == "$XCODE_APP" ]]; then
        skip "Developer directory already set to Xcode.app"
    elif [[ -d "$XCODE_APP" ]]; then
        info "Switching developer directory to Xcode.app (required for Metal compiler) ..."
        sudo xcode-select -s "$XCODE_APP"
        ok "Developer directory set to $XCODE_APP"
    else
        info "Xcode.app not found -- Metal compiler (xcrun metal) will not be available"
        info "Install Xcode from the App Store, then run: sudo xcode-select -s $XCODE_APP"
    fi

    section "Metal Toolchain"

    if xcrun metal --version &>/dev/null; then
        skip "Metal toolchain already available"
    elif [[ -d "$XCODE_APP" ]]; then
        info "Downloading Metal toolchain ..."
        if xcodebuild -downloadComponent MetalToolchain 2>/dev/null; then
            ok "Metal toolchain installed"
        else
            err "Metal toolchain download failed (non-fatal) -- try: xcodebuild -runFirstLaunch"
        fi
    else
        info "Skipping Metal toolchain (Xcode.app not installed)"
    fi
fi

# ── 4. Install core CLI tools via brew ────────────────────────────────────

section "Installing CLI tools via Homebrew"

BREW_PACKAGES=(neovim git node ripgrep fd fzf starship eza bat zoxide uv tmux graphviz clang-uml plantuml cmake pre-commit clang-format ninja doxygen)

for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list --formula "$pkg" &>/dev/null; then
        skip "$pkg (already installed)"
    else
        info "Installing $pkg ..."
        brew install "$pkg"
        ok "$pkg installed"
    fi
done

# ── 5. Install Rust toolchain ─────────────────────────────────────────────

section "Rust toolchain"

if command -v rustup &>/dev/null; then
    skip "rustup already installed ($(rustup --version 2>/dev/null | head -1))"
else
    info "Installing rustup ..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # shellcheck disable=SC1091
    source "$HOME/.cargo/env" 2>/dev/null || true
    ok "Rust toolchain installed"
fi

# ── 6. Set up Python environment ──────────────────────────────────────────

section "Python environment (via uv)"

info "Ensuring Python 3.12 is available ..."
uv python install 3.12
ok "Python 3.12 ready"

NVIM_VENV="$HOME/.local/share/nvim-venv"

if [[ -d "$NVIM_VENV" ]]; then
    skip "nvim-venv already exists at $NVIM_VENV"
else
    info "Creating global nvim venv ..."
    uv venv "$NVIM_VENV" --python 3.12
    ok "nvim-venv created"
fi

info "Installing pynvim into nvim-venv ..."
uv pip install --python "$NVIM_VENV/bin/python" pynvim
ok "pynvim installed"

# ── 7. Node neovim provider ──────────────────────────────────────────────

section "Node neovim provider"

if npm list -g neovim &>/dev/null; then
    skip "neovim npm package already installed globally"
else
    info "Installing neovim npm package globally ..."
    npm install -g neovim
    ok "neovim npm package installed"
fi

# ── 7. AI CLI tools ──────────────────────────────────────────────────────

section "AI CLI tools (npm)"

npm_global_install() {
    local cmd="$1" pkg="$2"
    if command -v "$cmd" &>/dev/null; then
        skip "$cmd (already installed)"
    else
        info "Installing $pkg ..."
        npm install -g "$pkg"
        ok "$cmd installed"
    fi
}

npm_global_install "claude" "@anthropic-ai/claude-code"
npm_global_install "codex"  "@openai/codex"
npm_global_install "gemini" "@google/gemini-cli"


# ── 8. Nerd Font ─────────────────────────────────────────────────────────

section "Nerd Font"

if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    skip "JetBrainsMono Nerd Font already installed"
else
    info "Installing JetBrainsMono Nerd Font ..."
    brew install --cask font-jetbrains-mono-nerd-font
    ok "JetBrainsMono Nerd Font installed"
fi

# ── 9. Symlink nvim config ───────────────────────────────────────────────

section "Neovim configuration"

NVIM_CONFIG_DIR="$HOME/.config/nvim"

if [[ "$(realpath "$SCRIPT_DIR" 2>/dev/null || echo "$SCRIPT_DIR")" == "$(realpath "$NVIM_CONFIG_DIR" 2>/dev/null || echo "$NVIM_CONFIG_DIR")" ]]; then
    skip "Script is already running from $NVIM_CONFIG_DIR"
else
    mkdir -p "$HOME/.config"
    if [[ -e "$NVIM_CONFIG_DIR" && ! -L "$NVIM_CONFIG_DIR" ]]; then
        info "Backing up existing $NVIM_CONFIG_DIR to ${NVIM_CONFIG_DIR}.bak"
        mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak"
    fi
    ln -sfn "$SCRIPT_DIR" "$NVIM_CONFIG_DIR"
    ok "Symlinked $SCRIPT_DIR -> $NVIM_CONFIG_DIR"
fi

# ── 10. Symlink dotfiles ─────────────────────────────────────────────────

section "Dotfile symlinks"

# link_dotfile <source> <target>
link_dotfile() {
    local src="$1" dst="$2"

    if [[ ! -f "$src" ]]; then
        err "Template not found: $src"
        return
    fi

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
        skip "$dst (already linked)"
        return
    fi

    # Back up existing file if it differs
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        info "Backing up $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -sfn "$src" "$dst"
    ok "$dst -> $src"
}

link_dotfile "$SCRIPT_DIR/zshrc.template"         "$HOME/.zshrc"
link_dotfile "$SCRIPT_DIR/starship.toml.template"  "$HOME/.config/starship.toml"
link_dotfile "$SCRIPT_DIR/tmux.conf.template"      "$HOME/.tmux.conf"

# ── 11. fzf shell integration ────────────────────────────────────────────

section "fzf shell integration"

FZF_INSTALL="$(brew --prefix)/opt/fzf/install"

if [[ -f "$HOME/.fzf.zsh" ]]; then
    skip "fzf shell integration already configured (~/.fzf.zsh exists)"
elif [[ -x "$FZF_INSTALL" ]]; then
    info "Running fzf install script ..."
    "$FZF_INSTALL" --all --no-bash --no-fish
    ok "fzf shell integration configured"
else
    skip "fzf install script not found (fzf may have been installed differently)"
fi

# ── 12. Git aliases ─────────────────────────────────────────────────────

section "Git aliases"

git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit"
ok "git lol"

git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
ok "git lola"

# ── 13. Tmux Plugin Manager (TPM) ────────────────────────────────────────

section "Tmux Plugin Manager"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    skip "TPM already installed at $TPM_DIR"
else
    info "Cloning TPM ..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
fi

# ── 14. Summary ───────────────────────────────────────────────────────────

section "All done!"

printf "\n"
info "A few things to do manually:"
printf "\n"
printf "  ${YELLOW}1.${NC} Set your terminal font to ${BOLD}JetBrainsMono Nerd Font Mono${NC}\n"
printf "  ${YELLOW}2.${NC} Open Neovim and run ${BOLD}:Copilot auth${NC} to authenticate GitHub Copilot\n"
printf "  ${YELLOW}3.${NC} Open tmux and press ${BOLD}prefix + I${NC} to install tmux plugins\n"
printf "  ${YELLOW}4.${NC} Neovim will auto-install plugins on first launch -- just let it finish\n"
printf "  ${YELLOW}5.${NC} In each git repo with a ${BOLD}.pre-commit-config.yaml${NC}, run: ${BOLD}pre-commit install${NC}\n"
printf "\n"
ok "Environment bootstrap complete."
