#!/bin/bash

echo "Starting Bali Language Installation..."

# Check if curl is installed
if ! command -v curl &>/dev/null; then
  echo "Error: curl is required but not installed."
  exit 1
fi

# Set installation directory
INSTALL_DIR="$HOME/.local/bin"
BALI_BINARY_URL="https://github.com/notblessy/basa-pemrograman-bali/releases/download/v0.0.2/bali-language-v0.0.2"
BALI_BINARY="$INSTALL_DIR/bali"

# Create target directory if it doesn't exist
mkdir -p "$INSTALL_DIR" || {
  echo "Error: Unable to create directory $INSTALL_DIR"
  exit 1
}

# Download the Bali binary
echo "Downloading Bali binary to $BALI_BINARY..."
curl -L "$BALI_BINARY_URL" -o "$BALI_BINARY" || {
  echo "Error: Failed to download Bali binary."
  exit 1
}

# Verify binary download
if [ ! -f "$BALI_BINARY" ]; then
  echo "Error: Download failed or binary not found."
  exit 1
fi

# Make binary executable
chmod +x "$BALI_BINARY" || {
  echo "Error: Failed to make Bali binary executable."
  exit 1
}

# Detect shell and set environment
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
else
  SHELL_RC="$HOME/.profile"
fi

# Add binary path to shell configuration if not already present
if ! grep -q 'export PATH="$HOME/.local/bin"' "$SHELL_RC"; then
  echo 'export PATH="$HOME/.local/bin"' >> "$SHELL_RC"
  echo "Added $INSTALL_DIR to your PATH in $SHELL_RC"
fi

# Apply environment changes
echo "Reloading shell configuration..."
source "$SHELL_RC" || {
  echo "Warning: Unable to reload shell configuration. Please restart your terminal."
}

# Final message
echo "Bali language successfully installed!"
echo "Run 'bali --version' to verify the installation."
