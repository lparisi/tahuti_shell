# tahuti_shell
random Thoth tarot quotes' based on chatgpt summaries :3 93!

## Features

- Fetches random tarot cards from book-of-thoth.net (Major & Minor Arcana)
- Uses Claude CLI for Thelemic/93 current interpretation of actual card content
- Displays card names in bold white, quotes in Catppuccin Mocha green
- Triggers after each command via ZSH precmd hook
- Includes debug mode for verification of content fetching and API usage

## Installation

### One-line installation:
```bash
curl -fsSL https://raw.githubusercontent.com/lparisi/tahuti_shell/main/install.sh | bash
```

### Manual installation:
```bash
git clone https://github.com/lparisi/tahuti_shell.git
cd tahuti_shell
./setup_tarot.sh
```

## Usage

After installation, the function automatically displays a tarot card and mystical quote after each command you run in your terminal.

### Debug Mode
Enable debug mode to see verification that card content is being fetched and processed:
```bash
export TAROT_DEBUG=1
```

This will show:
- The card name and URL being fetched
- Amount of content retrieved from the Book of Thoth
- Confirmation of Thelemic interpretation
- Unique prompt hash for verification

## Authentication

The function uses Claude CLI which handles authentication through your existing Claude login, so no API keys are needed in the environment or repository.
