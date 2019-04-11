#!/bin/bash
# A simple copy utility
# Lets verify copy worked
echo "Copying $@"

if [[ $# != 2 ]];
then
	echo "The script needs 2 args: <Script Name> <File 1> <File 2>"
else 
	echo "Copying $1 to $2"
	cp -r $1 $2
	echo "Copy complete"
        echo Details for $2
        ls -lh $2
        echo $0 :: var1 : $var1, var2 : $var2
	echo $*
fi
