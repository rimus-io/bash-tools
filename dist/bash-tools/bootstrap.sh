#!/bin/sh
################################################################
#
#   This script is used to "bootstrap" all packages
#
################################################################


# Set 'BASHTOOLS_HOME' value
export BASHTOOLS_HOME=$(dirname $BASH_SOURCE)


# Read and set parameters from 'context.ctx'
declare bashtools_develop=false # Declaring 'bashtools_develop' here to prevent undeclared var error messages
declare -a module_list=()
params_index=0
while read param
do
    # Ignore blank lines
    if [ ${#param} -ne 0 ]
    then
        # Ignore comments
        first_char=${param:0:1}
        if [ "$first_char" != "#" ]
        then
            if [ $params_index -eq 0 ]
            then
                # First parameter in 'context.ctx' file must be 'develop'
                if [ ${param:0:7} = "develop" ]
                then
                    # Set 'bashtools_develop' flag value
                    # Prefix 'bashtools_' is used to avoid name conflicts
                    declare "bashtools_$param"
                    params_index=$(( params_index + 1 ))
                else
                    echo "There seems to have been a problem parsing 'context.ctx' file"
                    exit 1
                fi
            else
                module_list[$params_index]=$param
                params_index=$(( params_index + 1 ))
            fi
        fi
        unset first_char
    fi
done < "$BASHTOOLS_HOME/context.ctx"
unset param
unset params_index


# Check if installation has been performed before proceeding, but allow execution if in development mode
if [ ! -f "$BASHTOOLS_HOME/st" ]
then
    if $bashtools_develop
    then
        echo "INFO: 'bash-tools' - Running in development mode."
    else
        echo "Sorry, you have to install 'bash-tools' first."
        exit 1 # Exit with error
    fi
fi


# Register modules
for module in ${module_list[@]}
do
    # Only register aliases if the module can be found
    if [ -f $BASHTOOLS_HOME/$module/$module.sh ]
    then
        alias $module="source $BASHTOOLS_HOME/$module/$module.sh"
    fi
done
unset module
unset module_list