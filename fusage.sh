#!/bin/bash

dirp_fusage() {
    # Description: print a usage message for a function
    # Use: dirp_fusage "beggining message goes here" function_name (print all:[true|false])

    if [[ ( $# -lt 2 ) ]]; then
        echo "Error: dirp_fusage() call failed"
        return;
    fi

    msg=$1

    dirp_all_functions=('dirpo=("dirpo" "pop directory at dirpl index" "dirpo <dirpl index>")')

	i=0
	for func in "${dirp_all_functions[@]}"
	do
		funcname=$(echo $dirp_all_functions.$func[i] |awk -F = '{print $1}')
		echo $funcname

		declare -a "$func"

		declare -a "$funcname"

		echo "xxxxx: $func.$funcname[1]"
		echo "yyyyy: ${funcname[0]}"

		case $2 in
			"dirpo")
				echo "got here"
				echo "${dirpo[0]} ${dirpo[1]} ${dirpo[2]}"
				break
				;;
			"thing")
				echo "got here: thing"
				break
				;;
			*)
				echo "Error: Bad input."
				;;
		esac
	done

    #dirp_msg $message
}

dirp_fusageX() {

	msg=$1

    dirp_all_functions=(
		dirpo="dirpo/pop directory at dirpl index/dirpo <dirpl index>"
		)

}

dirp_fusage "Some message" dirpo
