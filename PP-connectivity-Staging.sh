#!/bin/bash
# BLUE='\033[0;34m'
# GREEN='\033[0;32m'  
# RED='\033[0;31m' 
# NC='\033[0m'
TIMEOUT=5
HOSTNAME=(#"URL PORT
        # IP PORT"
        )

for REMOTEHOSTandPORT in "${HOSTNAME[@]}"
do
if nc -w $TIMEOUT -vz $REMOTEHOSTandPORT; then
    echo nc -w $TIMEOUT -vz $REMOTEHOSTandPORT;
    echo "Connection succeeded to $REMOTEHOSTandPORT!"
else
    echo nc -w $TIMEOUT -vz $REMOTEHOSTandPORT;
    echo "Connection to $REMOTEHOSTandPORT failed. Exit code from Netcat was ($?)."
fi
done