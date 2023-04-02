#!/bin/bash

# Check that an input file was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Get the 7th column and remove quotes and the first line
column=$(cut -f2,7 "$1" | tr -d '"' | tr '\^' 'i' | tr '\-' 'd' | sed '1d' | sort -k1,1n | cut -f2 | tac)

# Define color codes
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
purple='\033[0;35m'
cyan='\033[0;36m'
reset='\033[0m'

# Print each character in a different color
paste -d'\t' <(for (( i=0; i<${#column}; i++ )); do
    case "${column:$i:1}" in
        "A"|"a")
            printf "${red}A${reset}"
            ;;
        "C"|"c")
            printf "${green}C${reset}"
            ;;
        "G"|"g")
            printf "${yellow}G${reset}"
            ;;
        "T"|"t")
            printf "${blue}T${reset}"
            ;;
        "-")
            printf "${purple}-${reset}"
            ;;
        "^")
            printf "${cyan}^${reset}"
            ;;
        *)
            printf "${column:$i:1}"
            ;;
    esac
done) <(cut -f2,7 "$1" | tr -d '"' | tr '\^' 'i' | tr '\-' 'd' | sed '1d' | sort -k1,1n | cut -f1 | tac) 
echo ""
