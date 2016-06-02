#!/bin/sh

module="${1}"
auto_src="${2}"

alias $module="source $BASHTOOLS_HOME/installed/$module/$module.sh"

# Auto activate
if [[ ${auto_src} == true ]]
	then
		source $BASHTOOLS_HOME/installed/$module/$module.sh
fi