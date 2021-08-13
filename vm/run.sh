#!/bin/bash

if [ -n "$1" ]
then
    cd ../compiler/Unixv2/
    make
    cd -
    echo "----- Compilation --------"
    echo "\"$1\"" | ../compiler/Unixv2/Oberon
    res=$?
    make

    name=$(basename $1)
    name=$(echo $name | sed 's/\.obn$//g')

    if [ $res == 0 ]
    then
        echo "------ Execution by the virtual machine ------"
        make
        ./VM -f $name -d
    fi
else
    echo Please Enter an Oberon File
fi
