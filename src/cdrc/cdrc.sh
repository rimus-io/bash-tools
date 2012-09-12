#!/bin/sh
################################################################
#
#   cdrc -  executes '.cdrc' script on 'cd' command
#               if '.cdrc' file is found in that directory.
#
################################################################


# TDOD support for '.cdoutrc' - commands on going level up, but not deeper in
# rc - run command


CDRC_FILE=".cdrc"


function cd () {

    path_provided="${@}"

    # Strip out the slashes at the end of path if present
    while [ "${path_provided:$(( ${#path_provided} - 1 )):${#path_provided}}" = "/" ]
    do
        # Remove slash
        path_provided="${path_provided:0:$(( ${#path_provided} - 1 ))}"
    done

    # Run system 'cd'
    builtin cd "$path_provided";

    # Execute '.cdrc' file if found
    if [ -f "$path_provided/$CDRC_FILE" ]
    then
        source "$path_provided/$CDRC_FILE"
    fi

    #return $result
}