#!/bin/sh
################################################################
#
#   cdalias -  cd using aliases
#
################################################################

export CDA_STORE="$BASHTOOLS_HOME/cdalias/alias.store"

_CDAUTIL_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function __cdanav(){
    runnable="$_CDAUTIL_DIR/cdautil/cda/run.py"
    python $runnable -n ${@}
}

function __cdamgr(){

    runnable="$_CDAUTIL_DIR/cdautil/cda/run.py"
    python $runnable ${@}
}

function __cdadest(){

    unset _CDAUTIL_DIR
    unset __cdanav
    unset __cdamgr
    unset __cdadest
}

function cd () {

	path_provided="${@}"
	 if [ "${path_provided}" = "-q" ]
    	then
			echo ""
			echo "====================================="
    		echo "INFO: Switching back to 'cd' mode."
			echo "====================================="
			echo ""
    		unset cd
    		unset cdm
    		__cdadest
    		return
    elif [[ ${path_provided:0:1} == "-" ]]
    	then
    		__cdamgr ${@}
#			echo ""
#			echo "====================================="
#    		echo "                HELP                 "
#			echo "- - - - - - - - - - - - - - - - - - -"
#			echo ""
#			echo "Module:"
#			echo "    cdalias"
#			echo ""
#			echo "Description:"
#			echo "    Enables easy navigation by"
#			echo "    allowing you assign aliases to"
#			echo "    directories and using those"
#			echo "    aliases instead of typing the"
#			echo "    full location."
#			echo ""
#			echo "Usage:"
#			echo "    cd <alias>"
#			echo "        Will jump to the directory"
#			echo "        linked to the alias specified"
#			echo "        if a directory has been"
#			echo "        linked to the given alias."
#			echo "    cd -q"
#			echo "        Will exit this mode and 'cd'"
#			echo "        command will function as"
#			echo "        normal."
#			echo "    cd -h"
#			echo "        Will display this help page."
#			echo "====================================="
#			echo ""
    		return
    fi

	alias_error_msg=""
	# Check for alias and overwrite if path for alias is found
	path_from_alias=$(__cdanav $path_provided)
	if [ "${path_from_alias}" = "-1" ]
		then
			alias_error_msg=" ✗ cd <alias>: $path_provided: Not an alias"
	elif [ "${path_from_alias}" = "-2" ]
		then
			alias_error_msg=" ✗ cd <alias>: $path_provided: Not an alias"
	elif [ "${path_from_alias}" = "-3" ]
		then
			alias_error_msg=" ✗ cd <alias>: $path_provided: Not an alias"
	elif [ "${path_from_alias}" != "" ]
		then
			path_provided=$path_from_alias
			echo " ✔ Alias detected: '${@}'  -->  $path_provided"
	fi

	# Strip out the slashes at the end of path if present
    while [ "${path_provided:$(( ${#path_provided} - 1 )):${#path_provided}}" = "/" ]
    do
        # Remove slash
        path_provided="${path_provided:0:$(( ${#path_provided} - 1 ))}"
    done



	builtin cd $path_provided

	# If builtin cd threw an error, show that path wasn't an alias either
	if [ "$?" != "0" ]
		then
			echo $alias_error_msg
	fi
}


echo ""
echo "====================================="
echo "INFO: Entering 'cd <alias>' mode! "
echo "    cd -q (will exit this mode)    "
echo "    cd -h (for help)               "
echo "====================================="
echo ""

