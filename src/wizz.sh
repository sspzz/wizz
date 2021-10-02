#!/bin/sh

# This script is intended as a tool for downloading artwork for 
# wizards from Forgotten Runes Wizard Cult, see
# <http://forgottenrunes.com>.
#
# Copyright 2021 spz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# For details on the GNU General Public License, 
# see <http://www.gnu.org/licenses/>.

setup_colors() {
    NC='\033[0m'
    BLCK='\033[0;30m'
    RED='\033[0;31m'
    YLLW='\033[0;33m'
    PURP='\033[0;35m'
    LPRP='\033[1;35m'
}

display_header() {
    echo "
               ${PURP}............                         
         ...******${LPRP}#########${PURP}......                   
       ..******///////////////${LPRP}###${PURP}...                
    ...*****/////////////////////${LPRP}###${PURP}...             
    ...*****/////////////////////${LPRP}###${PURP}...             
    ...**///***///////////////***///${LPRP}###${PURP}             
    ...**//////***************//////***             
    ...//***///${LPRP}########################${PURP}             
    ...***********${BLCK}..................${PURP}***             
    .../////${LPRP}###${BLCK}......${YLLW}@@@${BLCK}......${YLLW}@@@${BLCK}...${PURP}***             
    ...**///${LPRP}###${BLCK}......${YLLW}@@@${BLCK}......${YLLW}@@@${BLCK}...${PURP}///             
    ...**///${LPRP}###${BLCK}......${YLLW}@@@${BLCK}......${YLLW}@@@${BLCK}...${PURP}///             
    ...**//////${LPRP}###${BLCK}..................${PURP}///             
    ...**...///${LPRP}###############${PURP}///${LPRP}######${PURP}             
    ...**...${LPRP}###${PURP}***///***${LPRP}###${PURP}/////////***             
    ...**...${LPRP}###${PURP}***///***${LPRP}###${PURP}//////******             
       .....${LPRP}###${PURP}***///***${LPRP}###${PURP}//////***...             
         ...******///***${LPRP}${LPRP}###${PURP}//////...                
         ...******///***${LPRP}${LPRP}###${PURP}//////...                
         .........///***${LPRP}${LPRP}###${PURP}///...                   
               ...............${NC}
    "
}

summon_wizard() {
    echo "Summoning $1... \c"
    if [[ $1 =~ ^[0-9]+$ ]] && (($1 > 0 && $1 < 10001)); then
        curl -f -s "https://www.forgottenrunes.com/api/art/wizards/$1.zip" -o "$1.zip"
        if [ $? -eq 0 ]; then
            unzip -o -qq "$1.zip" -d "$1"
            rm "$1.zip"
            echo "${YLLW}success ✨${NC}"
        else
            echo "${RED}download failed 💥${NC}"
        fi  
    else 
        echo "${RED}non-existent wizard 💥${NC}"
    fi
}

summon_wizards() {
    for wiz in "$@"
    do
        summon_wizard "$wiz"
    done
}

summon_wizards_interactive() {
    while true
    do
        echo "\n${LPRP}Whom shall I summon${NC} > \c"
        read wizz
        if [ "$wizz" = "exit" ]; then
            break
        else
            summon_wizard "$wizz"
        fi
    done
}

main() {
    setup_colors
    display_header
    if [ "$#" -gt 0 ]; then
        echo "${LPRP}Preparing summoning circle for $# wizards 🔮${NC}"
        summon_wizards "$@"
    else
        echo "${PURP}Summoning circle is active, to dismiss use 'exit'.${NC}"
        summon_wizards_interactive
    fi
}

main "$@"
