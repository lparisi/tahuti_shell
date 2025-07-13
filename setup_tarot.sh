#!/bin/bash

# Setup script for Tarot Quote ZSH function

echo "Setting up Tarot Quote function for ZSH..."

# Check if running on macOS and install coreutils if needed
if [[ "$(uname)" == "Darwin" ]]; then
    if ! command -v gshuf &> /dev/null; then
        echo "Installing coreutils for gshuf command..."
        brew install coreutils
    fi
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq for JSON parsing..."
    if [[ "$(uname)" == "Darwin" ]]; then
        brew install jq
    else
        sudo apt-get update && sudo apt-get install -y jq
    fi
fi

# Add function to .zshrc if not already present
if ! grep -q "tarot_quote" ~/.zshrc; then
    echo "" >> ~/.zshrc
    echo "# Tarot Quote Function" >> ~/.zshrc
    echo "source ~/dev/tahuti_shell/tarot_quote.zsh" >> ~/.zshrc
    echo "Function added to ~/.zshrc"
else
    echo "Function already in ~/.zshrc"
fi

echo ""
echo "Setup complete! The tarot quote function will display after each command."
echo ""
echo "To use Claude API for quotes, set your API key:"
echo "  export ANTHROPIC_API_KEY='your-api-key-here'"
echo ""
echo "Restart your terminal or run: source ~/.zshrc"