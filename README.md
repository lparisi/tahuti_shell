# tahuti_shell
random Thoth tarot quotes' based on chatgpt summaries :3 93!

## Features

- Fetches random tarot cards from book-of-thoth.net (Major & Minor Arcana)
- Uses Claude CLI for Thelemic/93 current interpretation of actual card content
- Displays card names in bold white, quotes in Catppuccin Mocha green
- Triggers after each command via ZSH precmd hook
- Includes debug mode for verification of content fetching and API usage

## Installation

Run the setup script:
```bash
./setup_tarot.sh
```

## Authentication

The function uses Claude CLI which handles authentication through your existing Claude login, so no API keys are needed in the environment or repository.
