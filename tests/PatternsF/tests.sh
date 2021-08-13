#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

cd ../../compiler/Unixv2/
make
cd -
cd ../../vm
make
cd -

for i in $(ls *.obn) 
do 
    echo "\"$i\"" | ../../compiler/Unixv2/Oberon 1 > /dev/null 2>/dev/null
    name=$(echo $i | sed 's/\.obn$//g')
    ../../vm/VM -f $name 1>/dev/null 2>/dev/null
    res=$?
    if [[ $res == 1 ]]
    then
        echo "[+]" $i
    else
        echo -e ${RED}[-] $i ${NC}
    fi
done

rm *.trace *.rsc *.smb
exit 0
