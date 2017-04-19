#!/bin/sh

function _qa_help_opts () {

	COMPREPLY=( $( compgen -W "-h" -- "${cur}" ) )
}


function _qa_all_opts () {

	COMPREPLY=( $( compgen -W "-h" -- "${cur}" ) )
}


function _dockradmin () {

	local cur prev

	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"


	case "${prev}" in
        -m)
			_qa_help_opts
			return
            ;;
        *)
			if [[ "${COMP_CWORD}" == 1 ]]
			then
				_qa_all_opts
				return
			fi
            ;;
    esac

}


complete -F _dockradmin dockradmin