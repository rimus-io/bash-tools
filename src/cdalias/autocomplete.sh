#!/bin/sh


function _cd_autocomp_all_opts () {

	COMPREPLY=( $( compgen -W "-h -q" -- "${cur}" ) )
}

function _cd_autocomp_default_opts () {

	COMPREPLY=( $( compgen -o default -- "${cur}" ) )
}


function _cd_autocomp () {

	if [[ ${CDA_ACTIVE} == false ]]
	then
		_cd_autocomp_default_opts
		return
	fi

	local cur prev

	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	case "${cur}" in
        -*)
			if [[ "${COMP_CWORD}" == 1 ]]
			then
				_cd_autocomp_all_opts
				return
			fi
            ;;
        *)
			if [[ "${COMP_CWORD}" == 1 ]]
			then
				_cd_autocomp_default_opts
				return
			fi
            ;;
    esac

}


complete -F _cd_autocomp cd