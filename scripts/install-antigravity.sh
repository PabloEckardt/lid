#!/usr/bin/env bash
set -e

echo "=> Installing Linked-Intent Development (LID) for Antigravity (Gemini IDE)..."

# Determine OS-specific install directory for the LID repo
if [ "$(uname)" = "Darwin" ]; then
  # macOS common path
  INSTALL_DIR="${XDG_DATA_HOME:-$HOME/Library/Application Support}/lid"
  GEMINI_PLUGINS_DIR="$HOME/.gemini/config/plugins"
else
  # Linux common path
  INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/lid"
  # Fallback logic for Linux configuration directory
  if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/gemini/config/plugins" ]; then
    GEMINI_PLUGINS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gemini/config/plugins"
  else
    GEMINI_PLUGINS_DIR="$HOME/.gemini/config/plugins"
  fi
fi

# 1. Clone or update the repository
if [ -d "$INSTALL_DIR" ]; then
  echo "=> LID repository already exists at $INSTALL_DIR. Pulling latest changes..."
  cd "$INSTALL_DIR"
  git pull origin main --quiet
else
  echo "=> Cloning LID repository to $INSTALL_DIR..."
  git clone https://github.com/PabloEckardt/lid "$INSTALL_DIR" --quiet
fi

# 2. Ensure Gemini plugins directory exists
mkdir -p "$GEMINI_PLUGINS_DIR"

# 3. Create symlinks
echo "=> Setting up Antigravity plugin symlinks..."
for plugin in linked-intent-dev arrow-maintenance lid-experimental; do
  TARGET="$GEMINI_PLUGINS_DIR/$plugin"
  if [ -L "$TARGET" ] || [ -e "$TARGET" ]; then
    rm -rf "$TARGET"
  fi
  ln -s "$INSTALL_DIR/plugins/$plugin" "$TARGET"
  echo "   - Linked $plugin"
done

echo ""
echo "=> Success! The LID plugins have been installed."
echo "=> Please restart Antigravity (Gemini IDE) to load the new skills."
