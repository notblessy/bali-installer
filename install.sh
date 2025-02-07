#!/bin/bash

set -e

BALI_VERSION="v0.0.3"
INSTALL_DIR="$HOME/.local/bin"
BALI_BINARY="$INSTALL_DIR/bali"
BALI_BASE_URL="https://github.com/notblessy/basa-pemrograman-bali/releases/download/$BALI_VERSION"

function check_requirements() {
  if ! command -v curl &>/dev/null; then
    echo "Error: curl is required but not installed."
    exit 1
  fi
}

function detect_architecture() {
  local uname_os arch_name
  uname_os=$(uname -s)
  arch_name=$(arch)

  if [[ "$uname_os" == "Darwin" && "$arch_name" == "arm64" ]]; then
    echo "$BALI_BASE_URL/bali-language-$BALI_VERSION-aarm"
  elif [[ "$uname_os" == "Darwin" || "$uname_os" == "Linux" ]]; then
    echo "$BALI_BASE_URL/bali-language-$BALI_VERSION-amd64"
  else
    echo "Error: Unsupported platform ($uname_os $arch_name)." >&2
    exit 1
  fi
}

function install_bali() {
  mkdir -p "$INSTALL_DIR" || {
    echo "Error: Unable to create directory $INSTALL_DIR"
    exit 1
  }

  BALI_BINARY_URL=$(detect_architecture)

  echo "Downloading Bali binary to $BALI_BINARY..."
  curl -L "$BALI_BINARY_URL" -o "$BALI_BINARY" || {
    echo "Error: Failed to download Bali binary."
    exit 1
  }

  chmod +x "$BALI_BINARY" || {
    echo "Error: Failed to make Bali binary executable."
    exit 1
  }
}

function configure_shell_path() {
  local shell_rc

  if [ -n "$ZSH_VERSION" ]; then
    shell_rc="$HOME/.zshrc"
  elif [ -n "$BASH_VERSION" ]; then
    shell_rc="$HOME/.bashrc"
  else
    shell_rc="$HOME/.profile"
  fi

  if ! grep -q 'export PATH="\$HOME/.local/bin:\$PATH"' "$shell_rc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_rc"
    echo "Added $INSTALL_DIR to your PATH in $shell_rc"
  fi

  echo "Reloading shell configuration..."
  source "$shell_rc" || {
    echo "Warning: Unable to reload shell configuration. Please restart your terminal."
  }
}

function main() {
  echo "Starting Bali Language Installation..."
  check_requirements
  install_bali
  configure_shell_path
  echo "Bali language successfully installed!"
  echo "Run 'bali --version' to verify the installation."
}

main
