#!/bin/bash
# ansi-lookup.sh
# A CLI reference for ANSI escape sequences (colors & text attributes)

RESET=$'\033[0m'
BOLD=$'\033[1m'
UNDER=$'\033[4m'
DIM=$'\033[2m'
ITALIC=$'\033[3m'
GREEN=$'\033[32m'
GREEN_BG=$'\033[42m'
RED=$'\033[31m'
RED_BG=$'\033[41m'
YELLOW=$'\033[33m'
BLUE=$'\033[34m'
MAGENTA=$'\033[35m'
CYAN=$'\033[36m'

show_help() {
  echo -e "
Usage: ansi-lookup.sh [options]

Options:
  -a    Show all (${BOLD}text attributes${RESET}, ${GREEN}foreground${RESET}, ${GREEN_BG}background${RESET}, ${RED}2${YELLOW}5${GREEN}6${CYAN}-${BLUE}c${MAGENTA}o${RED}l${YELLOW}o${GREEN}r${CYAN}s${RESET}${RESET})
  -t    Show text attributes (${BOLD}bold${RESET}, ${UNDER}underline${RESET}, ${ITALIC}italic${RESET}, etc.)
  -f    Show ${GREEN}foreground colors${RESET} (16-color set)
  -b    Show ${GREEN_BG}background colors${RESET} (16-color set)
  -x    Show $(echo -e "${RED}2${YELLOW}5${GREEN}6${CYAN}-${BLUE}c${MAGENTA}o${RED}l${YELLOW}o${GREEN}r${CYAN}s${RESET}") foreground table
  -h    Show this ${BOLD}help${RESET}

Examples:
  ansi-lookup.sh -t
  ansi-lookup.sh -f -b
  ansi-lookup.sh -x
"
}

show_attrs() {
  declare -A ATTRS=(
    ["0"]="Reset/Normal"
    ["1"]="Bold"
    ["2"]="Dim"
    ["3"]="Italic"
    ["4"]="Underline"
    ["5"]="Blink"
    ["7"]="Reverse"
    ["8"]="Hidden"
    ["9"]="Strikethrough"
  )
  echo -e "\nText attributes:"
  for code in "${!ATTRS[@]}"; do
    printf "  %-15s: \\\033[%sm → " "${ATTRS[$code]}" "$code"
    echo -e "\033[${code}mExample${RESET}"
  done
} 

show_fg() {
  echo -e "\nBasic 16 Foreground Colors:"
  for i in {30..37} {90..97}; do
    printf "  FG %-3s: \\\033[%sm → " "$i" "$i"
    echo -e "\033[${i}mSample${RESET}"
  done
}

show_bg() {
  echo -e "\nBasic 16 Background Colors:"
  for i in {40..47} {100..107}; do
    printf "  BG %-3s: \\\033[%sm → " "$i" "$i"
    echo -e "\033[${i}mSample${RESET}"
  done
}

show_256() {
  echo -e "\n256 Colors (foreground only):"
  for i in {0..255}; do
    printf "%3s: \\\033[38;5;%sm → \033[38;5;%smSample${RESET}\t" "$i" "$i" "$i"
    if (( (i + 1) % 4 == 0 )); then
      echo ""
    fi
  done
}

# --- Parse options ---
if [[ $# -eq 0 ]]; then
  show_help
  exit 0
fi

while getopts "atfbxh" opt; do
  case $opt in
    a) show_attrs; show_fg; show_bg; show_256 ;;
    t) show_attrs ;;
    f) show_fg ;;
    b) show_bg ;;
    x) show_256 ;;
    h) show_help ;;
    *) show_help; exit 1 ;;
  esac
done
