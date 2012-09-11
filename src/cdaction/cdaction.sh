#!/bin/sh
################################################################
#
#   cdaction -  executes '.cdrc' script on 'cd' command
#               if '.cdrc' file is found in that directory.
#
################################################################


function cd ()
{
    echo "Entering: ${@}"
    builtin cd "$@";
    return $result
}


# Constructor
function main() {
    echo "cdaction"
}


# Destructor
function destructor() {
    # Unset constructor and destructor
    unset main
    unset destructor

    # Unset variables

    # Unset methods
}


# Run, then clean up
main ${@}
destructor