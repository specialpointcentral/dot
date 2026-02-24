#!/usr/bin/env bash
set -euo pipefail

DOT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dot-backup/$(date +%Y%m%d_%H%M%S)"
DRY_RUN=false

usage() {
    echo "Usage: $0 [--dry-run]"
    echo "  --dry-run  Show what would be done without making changes"
    exit 0
}

[[ "${1:-}" == "--help" || "${1:-}" == "-h" ]] && usage
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

log()  { echo "[dot] $*"; }
warn() { echo "[dot] WARN: $*"; }
skip() { echo "[dot] SKIP: $*"; }

link_file() {
    local src="$1" dst="$2"

    if [[ "$DRY_RUN" == true ]]; then
        echo "  LINK $src -> $dst"
        return
    fi

    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ "$(readlink "$dst" 2>/dev/null)" == "$src" ]]; then
            skip "$dst already linked"
            return
        fi
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
        log "Backed up $dst -> $BACKUP_DIR/$(basename "$dst")"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    log "Linked $src -> $dst"
}

link_dir() {
    local src="$1" dst="$2"

    if [[ "$DRY_RUN" == true ]]; then
        echo "  LINK_DIR $src -> $dst"
        return
    fi

    if [[ -L "$dst" ]]; then
        if [[ "$(readlink "$dst")" == "$src" ]]; then
            skip "$dst already linked"
            return
        fi
        rm "$dst"
    elif [[ -d "$dst" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
        log "Backed up $dst -> $BACKUP_DIR/$(basename "$dst")"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    log "Linked $src -> $dst"
}

log "Dotfiles directory: $DOT_DIR"
$DRY_RUN && log "=== DRY RUN ==="

# --- Shell ---
log "--- Shell ---"
link_file "$DOT_DIR/shell/zshrc"    "$HOME/.zshrc"
link_file "$DOT_DIR/shell/zshenv"   "$HOME/.zshenv"
link_file "$DOT_DIR/shell/zprofile" "$HOME/.zprofile"
link_file "$DOT_DIR/shell/p10k.zsh" "$HOME/.p10k.zsh"

if [[ ! -f "$HOME/.secrets.zsh" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  COPY secrets.zsh.example -> ~/.secrets.zsh"
    else
        cp "$DOT_DIR/shell/secrets.zsh.example" "$HOME/.secrets.zsh"
        chmod 600 "$HOME/.secrets.zsh"
        log "Created ~/.secrets.zsh from template (edit it with your real keys)"
    fi
else
    skip "~/.secrets.zsh already exists"
fi

# --- Tmux ---
log "--- Tmux ---"
link_file "$DOT_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# --- Claude ---
log "--- Claude ---"
mkdir -p "$HOME/.claude"
link_file "$DOT_DIR/claude/settings.json"       "$HOME/.claude/settings.json"
link_file "$DOT_DIR/claude/settings.local.json"  "$HOME/.claude/settings.local.json"

# --- Codex ---
log "--- Codex ---"
mkdir -p "$HOME/.codex"
link_file "$DOT_DIR/codex/config.toml" "$HOME/.codex/config.toml"

if [[ ! -f "$HOME/.codex/auth.json" ]]; then
    if [[ "$DRY_RUN" == true ]]; then
        echo "  COPY auth.json.example -> ~/.codex/auth.json"
    else
        cp "$DOT_DIR/codex/auth.json.example" "$HOME/.codex/auth.json"
        chmod 600 "$HOME/.codex/auth.json"
        log "Created ~/.codex/auth.json from template (edit it with your real key)"
    fi
else
    skip "~/.codex/auth.json already exists"
fi

# --- OpenCode ---
log "--- OpenCode ---"
mkdir -p "$HOME/.config/opencode"
link_file "$DOT_DIR/opencode/opencode.json"              "$HOME/.config/opencode/opencode.json"
link_file "$DOT_DIR/opencode/oh-my-opencode-slim.json"   "$HOME/.config/opencode/oh-my-opencode-slim.json"
log "Install oh-my-opencode-slim: bunx oh-my-opencode-slim@latest install"

# --- Done ---
echo ""
log "Done! Backup location: $BACKUP_DIR"
if [[ ! -f "$HOME/.secrets.zsh" ]] || $DRY_RUN; then
    warn "Remember to edit ~/.secrets.zsh with your API keys"
fi
if [[ ! -f "$HOME/.codex/auth.json" ]] || $DRY_RUN; then
    warn "Remember to edit ~/.codex/auth.json with your API key"
fi
