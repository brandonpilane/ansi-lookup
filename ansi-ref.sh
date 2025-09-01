#!/bin/bash
# ansi-lookup.sh
# A CLI reference for ANSI escape sequences (colors & text attributes)

RESET="\033[0m"

# --- Functions ---
show_help() {
  cat <<EOF
Usage: ansi-lookup.sh [options]

Options:
  -a    Show all (attributes, foreground, background, 256-colors)
  -t    Show text attributes (bold, underline, etc.)
  -f    Show foreground colors (16-color set)
  -b    Show background colors (16-color set)
  -x    Show 256-color foreground table
  -h    Show this help

Examples:
  ansi-lookup.sh -t
  ansi-lookup.sh -f -b
  ansi-lookup.sh -x
EOF
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
    printf "  %-15s: \\033[%sm → " "${ATTRS[$code]}" "$code"
    echo -e "\033[${code}mExample${RESET}"
  done
}

show_fg() {
  echo -e "\nBasic 16 Foreground Colors:"
  for i in {30..37} {90..97}; do
    printf "  FG %-3s: \\033[%sm → " "$i" "$i"
    echo -e "\033[${i}mSample${RESET}"
  done
}

show_bg() {
  echo -e "\nBasic 16 Background Colors:"
  for i in {40..47} {100..107}; do
    printf "  BG %-3s: \\033[%sm → " "$i" "$i"
    echo -e "\033[${i}mSample${RESET}"
  done
}

show_256() {
  echo -e "\n256 Colors (foreground only):"
  for i in {0..255}; do
    printf "%3s: \\033[38;5;%sm → \033[38;5;${i}mSample${RESET}\t" "$i" "$i"
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
