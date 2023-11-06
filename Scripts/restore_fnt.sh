#!/bin/bash
#|---/ /+----------------------------------+---/ /|#
#|--/ /-| Script to extract fonts & themes |--/ /-|#
#|-/ /--| Prasanth Rangan                  |-/ /--|#
#|/ /---+----------------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi

cat restore_fnt.lst | while read lst
do

    fnt=`echo $lst | awk -F '|' '{print $1}'`
    tgt=`echo $lst | awk -F '|' '{print $2}'`
    tgt=`eval "echo $tgt"`

    if [ ! -d "${tgt}" ]
    then
        mkdir -p ${tgt} || echo "creating the directory as root instead..." && sudo mkdir -p ${tgt}
        echo "${tgt} directory created..."
    fi

  sudo tar -xf ${CloneDir}/Source/arcs/${fnt}.tar.{gz,xz} -C ${tgt}/
  echo "uncompressing ${fnt}.tar.gz or ${fnt}.tar.xz --> ${tgt}..."

done

echo "rebuilding font cache..."
fc-cache -f

