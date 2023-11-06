#!/bin/bash
#|---/ /+----------------------------------+---/ /|#
#|--/ /-| Script to extract fonts & themes |--/ /-|#
#|-/ /--| Prasanth Rangan                  |-/ /--|#
#|/ /---+----------------------------------+/ /---|#

#!/bin/bash

# Source the global functions file
source global_fn.sh

if [ $? -ne 0 ]; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

# Loop through the entries in restore_fnt.lst
cat restore_fnt.lst | while read lst; do
    fnt=$(echo $lst | awk -F '|' '{print $1}')
    tgt=$(echo $lst | awk -F '|' '{print $2}')
    tgt=$(eval "echo $tgt")

    if [ ! -d "${tgt}" ]; then
        mkdir -p ${tgt} || { echo "Error: Unable to create directory ${tgt}"; exit 1; }
        echo "${tgt} directory created..."
    fi

    # Check for tar.gz file and extract
    if sudo tar -xf ${CloneDir}/Source/arcs/${fnt}.tar.gz -C ${tgt}/; then
        echo "Uncompressing ${fnt}.tar.gz --> ${tgt}... Success"
    # If tar.gz extraction fails, check for tar.xz file and extract
    elif sudo tar -xf ${CloneDir}/Source/arcs/${fnt}.tar.xz -C ${tgt}/; then
        echo "Uncompressing ${fnt}.tar.xz --> ${tgt}... Success"
    else
        echo "Error: Unable to extract ${fnt}.tar.gz or ${fnt}.tar.xz into ${tgt}"
        exit 1
    fi

done

# Rebuild font cache
echo "Rebuilding font cache..."
fc-cache -f


