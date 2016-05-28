#!/bin/sh
################################################################
#
#   cdalias -  cd using aliases
#
################################################################

export CDA_STORE="$BASHTOOLS_HOME/cdalias/alias.store"
export CDA_HASH=$(uuidgen)
chmod 755 "$BASHTOOLS_HOME/cdalias/cdautil"
export PATH="$BASHTOOLS_HOME/cdalias:$PATH"

function __cdanav(){
    cdautil --cdalias=$CDA_HASH -n ${@}
}

function __cdamgr(){
    cdautil --cdalias=$CDA_HASH ${@}
}

function __cdadest(){
    unset __cdanav
    unset __cdamgr
    unset __cdadest
    unset CDA_HASH
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
    		__cdadest
    		return
    elif [[ ${path_provided} == "" ]]
    	then
    		builtin cd $path_provided
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

	# Check for alias and overwrite if path for alias is found
	path_from_alias=$(__cdanav $path_provided)
	show_err_msg=false
	if [ "${path_from_alias}" = "-1" ]
		then
			# CODE_STORE_NOT_FOUND
			show_err_msg=true
	elif [ "${path_from_alias}" = "-2" ]
		then
			# CODE_ALIAS_NOT_FOUND
			show_err_msg=true
	elif [ "${path_from_alias}" = "-3" ]
		then
			# CODE_PATH_NOT_VALID
			show_err_msg=true
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

	builtin cd $path_provided > /dev/null 2>&1

	# If builtin cd threw an error, show that path wasn't an alias either
	if [ "$?" != "0" ]
		then
			alias_error_msg=" ✗ cd $path_provided: No such file, directory or alias"
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

