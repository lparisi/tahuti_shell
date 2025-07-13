#!/bin/zsh

# Tarot quote function for ZSH
# Fetches a random tarot card from book-of-thoth.net and generates a quote

tarot_quote() {
  local BOOK_ROOT="https://book-of-thoth.net"
  
  # List of Major Arcana
  local major_arcana=(
    "Atu-O-The-Fool" "Atu-I-The-Magus" "Atu-II-The-Priestess" "Atu-III-The-Empress"
    "Atu-IV-The-Emperor" "Atu-V-The-Hierophant" "Atu-VI-The-Lovers" "Atu-VII-The-Chariot"
    "Atu-VIII-Adjustment" "Atu-IX-The-Hermit" "Atu-X-Fortune" "Atu-XI-Lust"
    "Atu-XII-The-Hanged-Man" "Atu-XIII-Death" "Atu-XIV-Art" "Atu-XV-The-Devil"
    "Atu-XVI-The-Tower" "Atu-XVII-The-Star" "Atu-XVIII-The-Moon" "Atu-XIX-The-Sun"
    "Atu-XX-The-Aeon" "Atu-XXI-The-Universe"
  )
  
  # List of Minor Arcana prefixes
  local ranks=("Ace" "Two" "Three" "Four" "Five" "Six" "Seven" "Eight" "Nine" "Ten" "Prince" "Princess" "Knight" "Queen" "King")
  local suits=("Wands" "Cups" "Swords" "Disks")
  
  # Build Minor Arcana array
  local minor_arcana=()
  for rank in "${ranks[@]}"; do
    for suit in "${suits[@]}"; do
      minor_arcana+=("${rank}-of-${suit}")
    done
  done
  
  # Combine all cards
  local all_cards=("${major_arcana[@]}" "${minor_arcana[@]}")
  
  # Pick a random card (use gshuf on macOS, shuf on Linux)
  local shuf_cmd="shuf"
  if command -v gshuf > /dev/null; then
    shuf_cmd="gshuf"
  fi
  
  # Get random card
  local card_path=$(printf '%s\n' "${all_cards[@]}" | $shuf_cmd -n 1)
  local card_url="${BOOK_ROOT}/${card_path}"
  
  # Extract readable card name from URL
  local card_name=$(echo "$card_path" | sed 's/-/ /g' | sed 's/^Atu [IVXLO]* //')
  
  # Convert Disks to Pentacles for traditional naming
  card_name=$(echo "$card_name" | sed 's/Disks/Pentacles/')
  
  # Fetch the card page and extract text content
  local card_content=$(curl -sL "$card_url" | sed 's/<[^>]*>//g' | tr -s '[:space:]' ' ' | grep -A 5 -B 5 -i "${card_name}" | head -200)
  
  # Generate quote using Claude API with Thelemic interpretation
  local prompt="You are interpreting the Thoth tarot card '$card_name' through the lens of Thelema and the 93 current. Based on this card's meaning from the Book of Thoth: '$card_content'... Generate a brief poetic interpretation (under 20 words) that captures the card's essence in alignment with Thelemic philosophy. Reply with only the quote, no other text."
  
  # Use claude command to generate the quote
  local quote=""
  local debug_info=""
  
  if [[ -n "$TAROT_DEBUG" ]]; then
    # In debug mode, use verbose flag and capture all output
    local temp_file=$(mktemp)
    quote=$(/usr/local/bin/claude -p "$prompt" --verbose 2>"$temp_file")
    debug_info=$(cat "$temp_file" | grep -E "(Request ID|Response:|API|request_id)" | head -5)
    rm -f "$temp_file"
  else
    # Normal mode
    quote=$(/usr/local/bin/claude -p "$prompt" 2>/dev/null)
  fi
  
  # Colors - Catppuccin Mocha theme
  local WHITE_BOLD='\033[1;97m'      # Bold bright white
  local GREEN='\033[38;2;166;227;161m'  # Catppuccin green (#a6e3a1)
  local RESET='\033[0m'
  
  # Output with colors
  echo -e "\n${WHITE_BOLD}${card_name}${RESET}"
  echo -e "${GREEN}${quote}${RESET}"
  
  # Debug mode - show verification that card content was fetched and sent to Claude
  if [[ -n "$TAROT_DEBUG" ]]; then
    echo -e "${RESET}[Debug] Card: ${card_name} from ${card_url}"
    echo -e "${RESET}[Debug] Content fetched: ${#card_content} characters"
    echo -e "${RESET}[Debug] Prompt includes Thelemic interpretation request: Yes"
    if [[ -n "$debug_info" ]]; then
      echo -e "${RESET}[Debug] API Response Info:"
      echo -e "${RESET}${debug_info}"
    fi
    # Show a hash of the prompt to verify unique content per card
    local prompt_hash=$(echo -n "$prompt" | shasum -a 256 | cut -c1-16)
    echo -e "${RESET}[Debug] Prompt hash (verification): ${prompt_hash}"
  fi
}

# Hook function into precmd
autoload -Uz add-zsh-hook
add-zsh-hook precmd tarot_quote