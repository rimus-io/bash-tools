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
    #return $result
}