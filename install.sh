#!/bin/bash

# Tahuti Shell - One-line installer
# Clones repo and sets up ZSH tarot quote function

set -e

echo "🔮 Installing Tahuti Shell..."

# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone the repository
echo "📦 Cloning repository..."
git clone https://github.com/lparisi/tahuti_shell.git
cd tahuti_shell

# Check if running on macOS and install dependencies
echo "🔧 Installing dependencies..."
if [[ "$(uname)" == "Darwin" ]]; then
    if ! command -v gshuf &> /dev/null; then
        echo "Installing coreutils for gshuf command..."
        if command -v brew &> /dev/null; then
            brew install coreutils
        else
            echo "❌ Homebrew not found. Please install Homebrew first: https://brew.sh"
            exit 1
        fi
    fi
    
    if ! command -v jq &> /dev/null; then
        echo "Installing jq for JSON parsing..."
        brew install jq
    fi
else
    # Linux
    if ! command -v jq &> /dev/null; then
        echo "Installing jq for JSON parsing..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y jq
        elif command -v yum &> /dev/null; then
            sudo yum install -y jq
        elif command -v pacman &> /dev/null; then
            sudo pacman -S jq
        else
            echo "❌ Please install jq manually for your distribution"
            exit 1
        fi
    fi
fi

# Check for Claude CLI
if ! command -v claude &> /dev/null; then
    echo "❌ Claude CLI not found. Please install it first:"
    echo "   Visit: https://docs.anthropic.com/en/docs/claude-code/quickstart"
    exit 1
fi

# Copy files to user's home directory
echo "📋 Setting up tarot function..."
TARGET_DIR="$HOME/.tahuti_shell"
mkdir -p "$TARGET_DIR"
cp tarot_quote.zsh "$TARGET_DIR/"

# Add function to .zshrc if not already present
if ! grep -q "tahuti_shell/tarot_quote.zsh" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Tahuti Shell - Tarot Quote Function" >> ~/.zshrc
    echo "source ~/.tahuti_shell/tarot_quote.zsh" >> ~/.zshrc
    echo "✅ Function added to ~/.zshrc"
else
    echo "✅ Function already in ~/.zshrc"
fi

# Cleanup
cd "$HOME"
rm -rf "$TEMP_DIR"

echo ""
echo "🎉 Installation complete!"
echo ""
echo "📖 The tarot quote function will display after each command."
echo "🔍 Enable debug mode: export TAROT_DEBUG=1"
echo "🔄 Restart your terminal or run: source ~/.zshrc"
echo ""
echo "93! ✨"