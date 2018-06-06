#!/usr/bin/env bash

# Description:
# dirp -a bash script for managing dirs, pushd, and popd across terminals and systems.

# Author: [Karl N. Redman](https://karlredman.github.io)
# Project: [dirp: bash script for builtins - dirs, pushd, popd management](https://github.com/karlredman/dirp)
# Copyright Karl N. Redman Nov. 28, 2017
# License: M.I.T.

############################################
################## configuration
# Note: configurables can be overridden by environment so long as they are
## defined before this file is sourced.
############################################

if [ -z ${DIRP_LATEST_FILE+notArealVariable} ];then
	DIRP_LATEST_FILE="/tmp/dirp_latest"
fi

if [ -z ${DIRP_PROJECTS_DIR+notArealVariable} ];then
	DIRP_PROJECTS_DIR="$HOME/dirlists"
fi
#
if [ -z ${DIRP_LIST_COLOR1+notArealVariable} ];then
	DIRP_LIST_COLOR1='\e[0;33m'
fi
if [ -z ${DIRP_LIST_COLOR2+notArealVariable} ];then
	DIRP_LIST_COLOR2='\e[0;36m'
fi
#
if [ -z ${DIRP_EXPERT+notArealVariable} ];then
	DIRP_EXPERT=false
fi
#
if [ -z ${DIRP_USEALIASES_SUIE+notArealVariable} ];then
	DIRP_USEALIASES_SUITE=true
fi
if [ -z ${DIRP_USEALIASES_DIRNUMS+notArealVariable} ];then
	DIRP_USEALIASES_DIRNUMS=true
fi
if [ -z ${DIRP_THIS_PROJECT+notArealVariable} ];then
	DIRP_THIS_PROJECT=''
fi
#-------------------------------------------

############################################
################## Functions
############################################

dirp_check_projectsdir() {
    if [ -d $DIRP_PROJECTS_DIR ]; then
        return 0
    fi
    echo "ERROR: projects directory $DIRP_PROJECTS_DIR  does not exist!"
    return 1
}


dirp_saveProject() {
	# Save a dirs list for a given project
	# arguments:
	## $1: name of project


	# these should be(?) pretty similar
	## dirs -v |cut -d' ' -f4- |sort|uniq
	## dirs -v |sed '1d; s/xxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxx/' | cut -d' ' -f4-
	## dirs -v |sed '1d; s/xxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxx/' | cut -d' ' -f4- |sed "s@\~@$HOME@g" |sort |uniq > $1
	## must be converted to absolute paths

	# TODO: this could be a bit more sophisticated

    if ! dirp_check_projectsdir;
    then
        return;
    fi

	# fail by default
	YES='false'

	# file name
	file_name=$DIRP_PROJECTS_DIR/$1
	command="dirs -v | sed '1d '| cut -d' ' -f4- | sed "s@\~@$HOME@g" | sort -V | uniq | tac > $file_name"

	if [[ $# -ge 1 ]]; then

		# if file exists
		if [ -f $file_name ]; then

			echo "Do you wish to overwrite $file_name?"
			select yn in "Yes" "No"; do
				case $yn in
					Yes )
						YES='true'
						break
						;;
					No )
						break
						;;
				esac
			done

			if [[ $YES == 'true' ]]; then
				# 1. dirs -v
				# 2. remove first line and process fourth colomn on
				# 3. 4th column on
				# 4. substitute $HOME for ~
				# 5. sort version style
				# 6. only keep unique
				# 7. reverse the order for lifo reading
				# 8. output to file
				#dirs -v | sed '1d '| cut -d' ' -f4- | sed "s@\~@$HOME@g" | sort -V | uniq | tac > $file_name
				eval $command
				echo "Overwrote $file_name"

				# reload for sanity
				dirp_appendProject $1 true
			fi
		else
            # TODO: clean this up when less tired
			eval $command
             dirs -c
             DIRP_LATEST='$1'
             DIRP_THIS_PROJECT=''
             rm $DIRP_LATEST_FILE
			dirp_appendProject $1 true
            >$DIRP_PROJECTS_DIR/$1
            #dirp_saveProject "$DIRP_LATEST"
			echo "Created project file $file_name"
		fi
    else
        echo "Error: project name argument is required."
    fi
}

dirp_appendProject() {
	# append dirs list from file (one absolute path per line)

	# arguments
	## $1: project name
	## $2: clear dirs [true|false]
    ### note: if $2 is true, set current project variable `$DIRP_THIS_PROJECT`
	### note: if $2==true, update DIRP_LATEST_FILE

    if ! dirp_check_projectsdir;
    then
        return;
    fi


	# save our cwd
    wd=`pwd`

	#TODO: validate $1

	if [ $2 = true ]; then
		# replace instad of append

		# clear dirs
		dirs -c

		#this is a replacement so save the project name as latest
        echo $1> $DIRP_LATEST_FILE
        DIRP_LATEST=$1
        DIRP_THIS_PROJECT=$1
	fi

	# specify a list delimiter
    old_IFS="$IFS"
    IFS=$'\n'

    while read p
	# loop through file contents
    do
		# go to directory
        # verify directory or link exists
        if [ -d "${p}" ]; then
            # check if it's a link that points to a valid directory
            if [ -L "${p}" ];then
                # readlink is not a posix call....
                local source="$(readlink -e "${p}")"
                # check status of readlink
                if [ $? -gt 0 ]; then
                    continue;
                fi
            fi

        # it exists
        cd "${p}"

		# push the dir onto dirs stack
        pushd . >/dev/null 2>&1

        else
            continue;
        fi

    done <$DIRP_PROJECTS_DIR/$1

	# return to original dir
    cd "$wd"

	# reset delimiter
    IFS="$old_IFS"
}

dirp_deleteProject() {
	# delete project from selection
	# fail by default
	YES='false'

	# file name
	file_name=$DIRP_PROJECTS_DIR/$1

	if [[ $# -ge 1 ]]; then

		# if file exists
		if [ -f $file_name ]; then

			echo "Do you wish to DELETE $file_name?"
			select yn in "Yes" "No"; do
				case $yn in
					Yes )
						YES='true'
						break
						;;
					No )
						break
						;;
				esac
			done

			if [[ $YES == 'true' ]]; then
				#rm -i "$DIRP_PROJECTS_DIR/$p"
				rm -i "$file_name"
				echo "Deleted $file_name"

                # reset this project and wipe tmp file
                dirs -c
                DIRP_LATEST=''
                DIRP_THIS_PROJECT=''
                rm $DIRP_LATEST_FILE
			fi
		else
			echo "Project file $file_name not found"
		fi
    else
        echo "Error: project name argument is required."
    fi
}


dirp_listColorized() {
	# list items in `dirs -v` with alternating colors
    # current $DIRP_THIS_PROJECT overrides DIRP_LATEST_FILE

    if [[ ( $DIRP_THIS_PROJECT == '' ) ]];then
        DIRP_LATEST=$(cat $DIRP_LATEST_FILE 2>/dev/null)
        if [[ ( $DIRP_LATEST == '' ) ]]; then
            echo "Error: File $DIRP_LATEST_FILE not found and project argument was not provided."
            # show a menu -list projects
            dirp_menu_projects_cb "Load Project File:" dirp_appendProject true
        else
            echo "Loaded most recent project: $DIRP_LATEST"
            # reread the file -so.... inefficient...
            dirp_appendProject $DIRP_LATEST true
        fi
    else
        DIRP_LATEST=$DIRP_THIS_PROJECT

        # reread the file
        dirp_appendProject $DIRP_LATEST true
    fi

    echo "Current project: $DIRP_THIS_PROJECT"

	# specify a list delimiter
    old_IFS="$IFS"
    IFS=$'\n'

	# get list
    list=($(dirs -v))

    for (( i=0; i < ${#list[@]}; i++ ));
   do
        if [ $i -eq 0 ]; then
            continue
        fi
        if [ $(( $i%2 )) != 0 ]; then
            echo -e "$DIRP_LIST_COLOR1""${list[i]}"
        else
            echo -e "$DIRP_LIST_COLOR2""${list[i]}"
        fi
    done

    # reset terminal color
    # tput sgr0
	echo -n -e "\e[0m"

	# restore old delimiter
    IFS="$old_IFS"
}

dirp_menu_projects_cb(){
	# display message, list projects, and call callback

	# echo message
	echo $1

	# name of function to call
	callback=$2

	# optional argument
	option=$3

    projects=($(ls $DIRP_PROJECTS_DIR))
    projects+=('Quit')

    select p in "${projects[@]}"
    do
        case $p in
            "Quit")
                break
                ;;
            *)
				# if the file exists
                if [ -e "$DIRP_PROJECTS_DIR/$p" ];then
                    #$callback "$DIRP_PROJECTS_DIR/$p" $option
					# call function with project name
                    $callback "$p" $option
                else
                    echo "Error: Bad input."
                fi
                break
                ;;
        esac
    done
}

dirp_showConfig(){
	# show configuration settings
    echo "DIRP_THIS_PROJECT: $DIRP_THIS_PROJECT"
	echo "DIRP_PROJECTS_DIR: $DIRP_PROJECTS_DIR"
	echo "DIRP_LATEST_FILE: $DIRP_LATEST_FILE"
	#
	echo -n -e "$DIRP_LIST_COLOR1""DIRP_LIST_COLOR1: "
	echo $(echo $DIRP_LIST_COLOR1 | sed /\\/\\\\/g)
	##
	echo -n -e "$DIRP_LIST_COLOR2""DIRP_LIST_COLOR2: "
	echo $(echo $DIRP_LIST_COLOR2 | sed /\\/\\\\/g)
	##
	echo -n -e "\e[0m"
	#
	echo "DIRP_EXPERT: $DIRP_EXPERT"
	#
	echo "DIRP_USEALIASES_SUITE: $DIRP_USEALIASES_SUITE"
	echo "DIRP_USEALIASES_DIRNUMS: $DIRP_USEALIASES_DIRNUMS"
}

#dirp_auto() {
#    # !!!! undocumented -posible removal (causes problems with some window managers)

#	# entry point for suite -
#	# argument (optional, overrides DIRP_LATEST_FILE):  project name
#	# behavior:

#    if [[ ($DIRP_LATEST_FILE == 'NONE') ]]; then
#        return
#    fi

#	# present menu if cache file not found or project name not provided
#    DIRP_LATEST=$(cat $DIRP_LATEST_FILE 2>/dev/null)
#    if [[ ( $DIRP_LATEST == '' )
#        && ( $# -ne 1 ) ]]; then
#        echo "Error: File $DIRP_LATEST_FILE not found and project argument was not provided."
#		# show a menu -list projects
#		dirp_menu_projects_cb "Load Project File:" dirp_appendProject true

#	else
#		# seed
#        project_name=$DIRP_LATEST

#		# override DIRP_LATEST if an argument was specified
#        if [[ $# -ge 1 ]]; then
#			# user provided a project name
#            project_name=$1;
#        fi

#		# append contents of project file to `dirs`
#		# TODO: test if project file exists and is not empty
#        dirp_appendProject $project_name true

#        #export DIRP_LATEST=$dir
#	fi
#}

dirp_msg() {
	if [[ ( $# -lt 1 ) ]]; then
		echo "Error: dirp_msg() call failed"
		return;
	fi

	msg=$1

	if [ $DIRP_EXPERT = false ];then
		echo $msg
	fi
}

typeset -A dirp_all_commands
dirp_all_commands=(
[dirp]=0
[dirpp]=1
[dirpl]=2
[dirpu]=3
[dirpo]=4
#[dirpos]=5
[dirps]=5
# [dirpc]=7
# [dirpmf]=8
# [dirpmt]=9
)
dirp_cmd_names=(
"dirp"
"dirpp"
"dirpl"
"dirpu"
"dirpo"
#"dirpos"
"dirps"
# "dirpc"
# "dirpmf"
# "dirpmt"
)
dirp_cmd_desc=(
"main menu interface / help with option \'help\'"
"choose dirp project"
"list directories in current project"
"pushd current directory and save to project"
"popd the index from dirpl"
#"popd the index from selection"
"create new project"
"save current list to selected project"
# "merge current list from selected project"
# "merge current list to selected project"
)
dirp_cmd_use=(
"dirp [help]"
"dirpp"
"dirpl"
"dirpu"
"dirpo <index 1-n>"
#"dirpos"
"dirps"
# "dirpc [name]"
# "dirpmf"
# "dirpmt"
)

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
    echo "dirp: A bash script for managing dirs, pushd, and popd across terminals and systems."
    echo "Project Page: https://github.com/karlredman/dirp"
    echo "Requires: Bash >=v4"
    echo "Author: Karl N. Redman"
    echo "License: MIT"
	echo "Command Usage:"
    for i in $(seq 0 $(( ${#dirp_all_commands[@]} -1)) )
	do
		#elem=${dirp_all_commands[$name]}
        echo -n "   "
		dirp_cusage "" ${dirp_cmd_names[$i]}
	done
}


dirp_menu_main() {
	# Description: Entrypoint for dirp menu

    # DIRP_LATEST=$(cat /tmp/dirp_latest 2>/dev/null)
    # if [[ ( $DIRP_LATEST == '' )
    #     && ( $# -ne 1 ) ]]; then
    #     echo "Error: \$DIRP_LATEST isn't set or no file argument provided."
		# return;
	# fi

	# displays in order of array entry
	menu_items_main=(
	'load project'
	'create project'
	'save to project'
	'delete project'
	'list directories'
	'add directory'
	'remove directory'
	# 'append from project'
    # 'clear project'
	# 'clear dirs'
	'show configuration'
    'Help'
	)
	menu_items_main+=('Quit')

	select i in "${menu_items_main[@]}"
	do
		case $i in
			"Quit")
				break
				;;
			"list directories")
				dirp_listColorized
				#dirp_msg "done. Note: this is the same as 'dirs -v' (without color)| dirp_listColorized"
				break
				;;
			'load project')
				dirp_menu_projects_cb "Load Project File:" dirp_appendProject true
				dirp_listColorized
				#dirp_msg "done. Note: this is the same as 'dirp_appendProject <project name> true; dirp_listColorized'"
				break
				;;
			'add directory')
				fail=true
				select j in 'cwd' 'input' 'Quit'
				do
					case $j in
						"Quit")
							break
							;;
						'cwd')
							pushd . >/dev/null 2<&1
							fail=false
							break
							;;
						'input')
							read -p "Directory Name to add([C-c|Enter] to quit): " input
							if [ ! -z $input ]; then
								wd=`pwd`
								cd $input
								if [ $? -eq 0 ]; then
									pushd . >/dev/null 2<&1
									fail=false
								fi
								cd "$wd"
							fi
							break
							;;
						*)
							echo "Error: Bad input."
							break
							;;
					esac
				done
				if [ $fail = false ]; then
					dirp_saveProject "$DIRP_LATEST"
					#dirp_msg "done. Note: this is similar to 'cd <dir>; pushd .;cd -; dirp_saveProject <project name>'"
				fi
				break
				;;
			'remove directory')
				dirp_listColorized
				echo ""
				read -p "Delete a directory from the list ([C-c|Enter|q] to quit): " input
				case "$input" in
					q|quit)
						break
						;;
					*)
						popd +$input
						if [ $? -gt 0 ]; then
							echo "Error: invalid input."
						else
							dirp_saveProject "$DIRP_LATEST" true
							#dirp_msg "done. Note: this is the same as '<dirs -v|dirp|dirp_listColorized>; popd +<dirs index>; dirp_saveProject <project name> true'"
						fi
						break
						;;
				esac
				break
				;;
			'save to project')
				dirp_menu_projects_cb "Save dirs list to Project File:" dirp_saveProject true
				#dirp_msg "done. Note: this is the same as 'dirp_saveProject <project name> true'"
				break
				;;
			'create project')
				read -p "New Project Name ([C-c|Enter] to quit): " input
				if [ ! -z $input ]; then
					# TODO: check if project exists already
					dirp_saveProject $input
				fi
				break
				;;
			'delete project')
				dirp_menu_projects_cb "Delete Project File:" dirp_deleteProject
				dirp_msg "done. Note this is the same as 'rm -i <project file path>'"
				break
				;;
			# 'clear project')
			# 	dirs -c
			# 	> ${DIRP_PROJECTS_DIR}/${DIRP_THIS_PROJECT}
            #   dirp_msg "done. Note: this is the same as 'dirs -c && >\${DIRP_PROJECTS_DIR}/\${DIRP_THIS_PROJECT}'"
			# 	break
			# 	;;
			# 'clear dirs')
			# 	dirs -c
			# 	dirp_msg "done. Note: this is the same as 'dirs -c'"
			# 	break
			# 	break
			# 	;;
			# 'append from project')
                # if [[ ( $DIRP_THIS_PROJECT == '' ) ]];then
                    # dirp_msg "Error: No active project."
                    # dirp_msg "Use \`dirpp\` to select a project OR"
                    # dirp_msg "Use \`dirpl\` to enable most recent project."
                    # return
                # fi
			# 	dirp_menu_projects_cb "Append to Current project List $DIRP_THIS_PROJECT:" dirp_appendProject false
			# 	break
			# 	;;

			'show configuration')
				dirp_showConfig
				break
				;;
            'Help')
                dirp_cusage_all
                break
                ;;
			*)
				echo "Error: Bad input."
				break
				;;
		esac
	done
}

dirpu() {
    # * Description: pushd replacement
    # * Arguments:
    #   * $1:
    #       * [directory]: adds directory if provided
    #       * default: `CWD`
    ## Notes:
    # * pushd -N/+N not honored (use pushd for that)

    if [[ ( $DIRP_THIS_PROJECT == '' ) ]];then
      dirp_msg "Error: No active project."
      dirp_msg "Use \`dirpp\` to select a project OR"
      dirp_msg "Use \`dirpl\` to enable most recent project."
      return
    fi

    if [ ! -z ${1+notArealVariable} ];then
		if ! pushd $1 >/dev/null 2>&1;
        then
            dirp_msg "Error: Directory does not exist"
            return
        fi

        # TODO: why am i calling this twice?....
		pushd $1 >/dev/null
    else
        # pushd `cwd`
        pushd . >/dev/null
    fi

    # update the project file
	dirp_saveProject "$DIRP_THIS_PROJECT" true
}

dirpo() {
    # Description: popd replacement
    if [[ ( $DIRP_THIS_PROJECT == '' ) ]];then
      dirp_msg "Error: No active project."
      dirp_msg "Use \`dirpp\` to select a project OR"
      dirp_msg "Use \`dirpl\` to enable most recent project."
      return
    fi

    if [ -z ${1+notArealVariable} ];then
		dirp_cusage "Argument Error" "dirpo"
        return
    fi

    # check index range
    let tot=($(dirs -v |wc -l)-1)
    if [ $tot -eq 0 -o $1 -eq 0 -o $tot -lt $1 ]; then
		dirp_cusage "Index out of range" "dirpo"
        return
    fi

	# pushd `cwd`
    popd '+'$1 >/dev/null # TODO: ?? should be conditional based on +/- prefix ??

    # update the project file
	dirp_saveProject "$DIRP_THIS_PROJECT" true
}
#-------------------------------------------

############################################
################## Helpers
############################################
dirpl() {
	# load project from project selection
	dirp_listColorized
}
dirpp() {
	# load project from project selection
	dirp_menu_projects_cb "Load Project File:" dirp_appendProject true
}

dirps() {
    if [[ ( $DIRP_THIS_PROJECT == '' ) ]];then
      dirp_msg "Error: No active project."
      dirp_msg "Use \`dirpp\` to select a project OR"
      dirp_msg "Use \`dirpl\` to enable most recent project."
      return
    fi
    # save dirs list to project selection (overwrites project file)
	dirp_menu_projects_cb "Save dirs list to Project File:" dirp_saveProject true
}

dirp() {

    if [ ! -z ${1+notArealVariable} ];then
        # show help
        dirp_cusage_all
        return
    fi

	dirp_menu_main
}
#-------------------------------------------


############################################
################## Aliases
############################################

if [ $DIRP_USEALIASES_SUITE = true ]; then
	# list current project colorized
	alias d=dirp_listColorized
fi

if [ $DIRP_USEALIASES_DIRNUMS = true ]; then
	# use numbers as directory indexes from `dirs -v`
	alias 1='cd ~1'
	alias 2='cd ~2'
	alias 3='cd ~3'
	alias 4='cd ~4'
	alias 5='cd ~5'
	alias 6='cd ~6'
	alias 7='cd ~7'
	alias 8='cd ~8'
	alias 9='cd ~9'
	alias 10='cd ~10'
	alias 11='cd ~11'
	alias 12='cd ~12'
	alias 13='cd ~13'
	alias 14='cd ~14'
	alias 15='cd ~15'
	alias 16='cd ~16'
	alias 17='cd ~17'
	alias 18='cd ~18'
	alias 19='cd ~19'
	alias 20='cd ~20'
	alias 21='cd ~21'
	alias 22='cd ~22'
	alias 23='cd ~23'
	alias 24='cd ~24'
	alias 25='cd ~25'
	alias 26='cd ~26'
	alias 27='cd ~27'
	alias 28='cd ~28'
	alias 29='cd ~29'
	alias 30='cd ~30'
	# if you have more than 30 jump points in a dirs list... ::shakes head::
fi

############################################
################## testing
############################################
# source dirp_menu_main
