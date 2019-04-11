#!/bin/bash

LOG=var/log
ROOT_UID=0
LINES=50
E_XCD=86
E_NONROOT=87

# Run as root
if [ "$UID" -ne "$ROOT_ID" ];
then
	echo "Non-root user";
	exit $E_NONROOT
fi

 
