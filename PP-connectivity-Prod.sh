#!/bin/bash
BLUE='\033[0;34m'
GREEN='\033[0;32m'  
RED='\033[0;31m' 
NC='\033[0m'
TIMEOUT=5
HOSTNAME=(# url port
         # IP port
        )

for REMOTEHOSTandPORT in "${HOSTNAME[@]}"
do
if nc -w $TIMEOUT -vz $REMOTEHOSTandPORT; then
    echo $BLUE nc -w $TIMEOUT -vz $REMOTEHOSTandPORT;
    echo "${GREEN}Connection succeeded to $REMOTEHOSTandPORT! $NC"
else
    echo $BLUE nc -w $TIMEOUT -vz $REMOTEHOSTandPORT;
    echo "${RED}Connection to $REMOTEHOSTandPORT failed. Exit code from Netcat was ($?). $NC"
fi
done