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

# ── 3. Install core CLI tools via brew ────────────────────────────────────

section "Installing CLI tools via Homebrew"

BREW_PACKAGES=(neovim git node ripgrep fd fzf starship eza bat zoxide uv tmux)

for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list --formula "$pkg" &>/dev/null; then
        skip "$pkg (already installed)"
    else
        info "Installing $pkg ..."
        brew install "$pkg"
        ok "$pkg installed"
    fi
done

# ── 4. Install Rust toolchain ─────────────────────────────────────────────

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

# ── 5. Set up Python environment ──────────────────────────────────────────

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

# ── 6. Node neovim provider ──────────────────────────────────────────────

section "Node neovim provider"

if npm list -g neovim &>/dev/null; then
    skip "neovim npm package already installed globally"
else
    info "Installing neovim npm package globally ..."
    npm install -g neovim
    ok "neovim npm package installed"
fi

# ── 7. Nerd Font ─────────────────────────────────────────────────────────

section "Nerd Font"

if brew list --cask font-jetbrains-mono-nerd-font &>/dev/null; then
    skip "JetBrainsMono Nerd Font already installed"
else
    info "Installing JetBrainsMono Nerd Font ..."
    brew install --cask font-jetbrains-mono-nerd-font
    ok "JetBrainsMono Nerd Font installed"
fi

# ── 8. Symlink nvim config ───────────────────────────────────────────────

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

# ── 9. Symlink dotfiles ──────────────────────────────────────────────────

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

# ── 10. fzf shell integration ────────────────────────────────────────────

section "fzf shell integration"

FZF_INSTALL="$(brew --prefix)/opt/fzf/install"

if [[ -x "$FZF_INSTALL" ]]; then
    info "Running fzf install script ..."
    "$FZF_INSTALL" --all --no-bash --no-fish
    ok "fzf shell integration configured"
else
    skip "fzf install script not found (fzf may have been installed differently)"
fi

# ── 11. Tmux Plugin Manager (TPM) ────────────────────────────────────────

section "Tmux Plugin Manager"

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    skip "TPM already installed at $TPM_DIR"
else
    info "Cloning TPM ..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
fi

# ── 12. Summary ───────────────────────────────────────────────────────────

section "All done!"

printf "\n"
info "A few things to do manually:"
printf "\n"
printf "  ${YELLOW}1.${NC} Set your terminal font to ${BOLD}JetBrainsMono Nerd Font Mono${NC}\n"
printf "  ${YELLOW}2.${NC} Open Neovim and run ${BOLD}:Copilot auth${NC} to authenticate GitHub Copilot\n"
printf "  ${YELLOW}3.${NC} Open tmux and press ${BOLD}prefix + I${NC} to install tmux plugins\n"
printf "  ${YELLOW}4.${NC} Neovim will auto-install plugins on first launch -- just let it finish\n"
printf "\n"
ok "Environment bootstrap complete."
