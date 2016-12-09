#!/bin/bash

MINPARAMS=1

if [ $# -lt "$MINPARAMS" ]
then
  echo
  echo "This script needs at least $MINPARAMS command-line argument!"
  echo "Or in other words... put a package name!"
  echo "Usage: $0 <packagename>"
fi  

if [ $# = "$MINPARAMS" ]
then
  echo
  echo "Looking for $1!" 
  mkdir "$1" 
  cd "$1"
  wget -q https://raw.githubusercontent.com/Merryfurr/nsd-repo/master/packages/$1/$1Exists
  sleep 1
  if [ -f "$1Exists" ];
  then
     echo "Found it!"
     cd ..
     if grep -Fxq "$1" packages.txt
	 then
		 echo "It's already installed!"
	 else
	 echo "$1" > packages.txt
	 cd "$1"
     echo "Downloading $1. Please wait!"
     echo
     wget -q https://raw.githubusercontent.com/Merryfurr/nsd-repo/master/packages/$1/$1Docs
     echo "Below is $1's short documentation"
     echo
     cat "$1Docs"
     echo
     echo "Is this the package you want? [Y/N]"
     read yn
     if [ "$yn" == "y" ]; then
		echo
		echo "Downloading $1!"
		echo
		wget -q https://raw.githubusercontent.com/Merryfurr/nsd-repo/master/packages/$1/$1Release.tar.gz
		tar -xzvf "$1Release.tar.gz"
		echo
		if [ -f "$1.sh" ]; then
			echo "Finshed downloading $1"
			echo
		else
			echo "Error"
			echo
		fi
     fi
	 fi

  else
     echo 'Error: Package does not exist'
     echo 'Check over the package name, did you misspell it?'
     echo
     cd ..
     rm -r "$1"
  fi
fi  


