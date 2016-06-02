#!/bin/sh

# Some examples
# http://www.linuxjournal.com/content/more-using-bash-complete-command
# https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html
# http://unix.stackexchange.com/questions/11376/what-does-double-dash-mean-also-known-as-bare-double-dash
# https://github.com/scop/bash-completion/tree/master/completions

function _bt_module_opts () {

	local modules_list=($(ls $BASHTOOLS_HOME/installed/))
	local option_list="${modules_list[@]}"
	COMPREPLY=($( compgen -W "${option_list}" -- "${cur}" )  )
}


function _bt_all_opts () {

	COMPREPLY=( $( compgen -W "-h -l -m" -- "${cur}" ) )
}


function _bashtools () {

	local cur prev

	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"


	case "${prev}" in
        -m)
			_bt_module_opts
			return
            ;;
        *)
			if [[ "${COMP_CWORD}" == 1 ]]
			then
				_bt_all_opts
				return
			fi
            ;;
    esac

}


complete -F _bashtools bashtools