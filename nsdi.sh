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
  wget -q https://raw.githubusercontent.com/Noculi/nsd-repo/master/packages/$1/package
  sleep 1
  if [ -f "package" ];
  then
     echo "Found it!"
     cd ..
     if grep -Fxq "$1" packages.txt
	 then
		 echo "It's already installed!"
	 else
	 cd "$1"
     echo "Downloading $1. Please wait!"
     echo
     wget -q https://raw.githubusercontent.com/Noculi/nsd-repo/master/packages/$1/docs
     echo "Below is $1's short documentation"
     echo
     cat "package"
     echo
     cat "docs"
     echo
     echo "Is this the package you want? [Y/N]"
     read yn
     if [ "$yn" == "y" ]; then
		echo
		echo "Downloading $1!"
		echo
		wget -q https://raw.githubusercontent.com/Noculi/nsd-repo/master/packages/$1/deps
		wget -q https://raw.githubusercontent.com/Noculi/nsd-repo/master/packages/$1/release.tar.gz
		tar -xzvf "release.tar.gz"
		echo
		if [ -f "deps" ]; then
			echo "$1 has dependencies"
			echo "Checking..."
			count=$(<deps)
			cd ..
			if grep -Fxq "$count" packages.txt
			then
				if [ -f "$1.sh" ]; then
					echo "Finshed downloading $1"
					echo
					echo "$1" > packages.txt
				else
					echo "Error"
					echo
				fi
			else
				echo "Looking for $count!" 
				mkdir "$count" 
				cd "$count"
				wget -q https://raw.githubusercontent.com/Noculi/nsd-repo/master/packages/$count/package
				sleep 1
				if [ -f "package" ];
				then
					wget -q https://raw.githubusercontent.com/Noculi/nsd-repo/master/packages/$count/release.tar.gz
					tar -xzvf "release.tar.gz"
					if [ -f "$count.sh" ]; then
						echo "Finshed downloading $1 & $count"
						cd ..
						echo "$1" " " "$count" > packages.txt
					else
						echo "Error" 
					fi
				else
					echo "Error" 
				fi
			fi
		else
			if [ -f "$1.sh" ]; then
				echo "Finshed downloading $1"
				echo "$1" > packages.txt
				echo
			else
				echo "Error"
				echo
			fi
		fi
     fi
	 fi

  else
     echo 'Error: Package does not exist'
     echo 'Check the package name, did you misspell it?'
     echo
     cd ..
     rm -r "$1"
  fi
fi  


