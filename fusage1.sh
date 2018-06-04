#!/usr/bin/env bash

typeset -A dirp_all_commands
dirp_all_commands=(
[dirpo]=0 
[dirpl]=1
)
dirp_cmd_names=(
"dirpo" 
"dirpl"
)
dirp_cmd_desc=(
"Perform popd on the index from dirpl"
"List directories in current project"
)
dirp_cmd_use=("dirpo <index>" "dirpl")

dirp_cusage() {
	# Description: print a usage message for a command
	# Use: dirp_fusage <""|"beggining message goes here"> <command_name> [true]
	#
	# Note: There are miriad ways to do this. I'm going for simple maintenence here..

	# validate number of parameters
	if [[ $# -ge 1 ]]; then

		for name in "${!dirp_all_commands[@]}"
		do
			elem=${dirp_all_commands[$name]}
			if [ "$2" == "$name" ];
			then
				if [ ! "$1" == "" ];
				then
					# print the message if it's not empty
					echo "$1:"
				fi
				echo "\`${dirp_cmd_use[$elem]}\`: ${dirp_cmd_desc[$elem]}"
			fi
		done
	else
		echo "Error: dirp_cusage() not enough parameters."
	fi
}

dirp_cusage_all() {
	# print all commands
	echo "dirp command usage:"
	for i in $(seq 0 ${#dirp_all_commands[@]})
	do
		#elem=${dirp_all_commands[$name]}
		dirp_cusage "" ${dirp_cmd_names[$i]}
	done
}

dirp_cusage "$1" "$2"
echo "-----------------"
dirp_cusage_all
