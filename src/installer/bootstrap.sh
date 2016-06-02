#!/bin/sh
################################################################
#
#   This script is used to "bootstrap" all packages
#
################################################################


# Set 'BASHTOOLS_HOME' value
export BASHTOOLS_HOME=$(dirname $BASH_SOURCE)

# Activate doc generator
source "${BASHTOOLS_HOME}/etc/docgen.sh"


# Read and set parameters from 'main.cfg'
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
                # First parameter in 'main.cfg' file must be 'develop'
                if [ ${param:0:7} = "develop" ]
                then
                    # Set 'bashtools_develop' flag value
                    # Prefix 'bashtools_' is used to avoid name conflicts
                    declare "bashtools_$param"
                    params_index=$(( params_index + 1 ))
                else
                    echo "There seems to have been a problem parsing 'main.cfg' file"
                    exit 1
                fi
            else
                module_list[$params_index]="${param}"
                params_index=$(( params_index + 1 ))
            fi
        fi
        unset first_char
    fi
done < "$BASHTOOLS_HOME/etc/main.cfg"
unset param
unset params_index


# Check if installation has been performed before proceeding, but allow execution if in development mode
if [ ! -f "$BASHTOOLS_HOME/etc/st" ]
then
    if $bashtools_develop
    then
        echo "INFO: 'bash-tools' - Running in development mode."
    else
        unset btr
        echo "Sorry, you have to install 'bash-tools' first."
        exit 1 # Exit with error
    fi
fi

# Register modules
for module in ${module_list[@]}
do
    module_name=${module/"_0"/""}
    module_name=${module_name/"_1"/""}
    auto_source=false
    # Only register aliases if the module can be found
    if [[ -d "$BASHTOOLS_HOME/installed/$module_name" && -f "$BASHTOOLS_HOME/etc/hook.sh" ]]
    then
        if [ "${module:$(( ${#module} - 1 )):${#module}}" = "1" ]
            then
                auto_source=true
        fi
        source "$BASHTOOLS_HOME/etc/hook.sh" $module_name $auto_source
        echo "INFO: 'bash-tools' bootstrapping module: $module_name, auto source: $auto_source"
        # Enable autocompletion script if provided
        if [ -f "$BASHTOOLS_HOME/installed/$module_name/autocomplete.sh" ]
        then
            source "$BASHTOOLS_HOME/installed/$module_name/autocomplete.sh"
        fi
        # Generate documentation if not generated yet
        if [ ! -f "$BASHTOOLS_HOME/docs/$module_name.info" ]
        then
            generate_docs "$BASHTOOLS_HOME/installed/$module_name/$module_name.sh" "$module_name"
        fi
    fi
done
docgen_shutdown
unset module
unset module_list


function btr() {
    sh dev_clean_build.sh -fc
}

function _bt_help_menu(){

    local help_item_fmt="\033[1m%6s\033[0m    %s\n          Usage:\n                %12s\n\n"

    printf "===============================================================\n"
    printf "  bash-tools: Help\n"
    printf " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n\n"
    printf "${help_item_fmt}" "-h" "Shows this help page" "bashtools -h"
    printf "${help_item_fmt}" "-l" "Shows list of installed modules" "bashtools -l"
    printf "${help_item_fmt}" "-m" "Shows details of specified module" "bashtools -m <module>"
    printf "===============================================================\n\n"

}

function _bt_list_modules(){

    local list_info_fmt="\033[1m%14s\033[0m\n                   %s\n\n"

    printf "===============================================================\n"
    printf "  bash-tools: Installed modules\n"
    printf " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n\n"
    local modules_list=($(ls $BASHTOOLS_HOME/installed/))
    for module in "${modules_list[@]}"
    do
        printf "${list_info_fmt}" "${module}" "More info: bashtools -m ${module}"
    done
    printf "===============================================================\n\n"
}

function _bt_modules_info(){

    local module_name="${@}"

    local modules_list=($(ls $BASHTOOLS_HOME/installed/))
    for module in "${modules_list[@]}"
    do
        if [[ ${module} == ${module_name} ]]
        then
            cat "$BASHTOOLS_HOME/docs/${module}.info"
            return
        fi
    done
    printf "===============================================================\n"
    printf "  bash-tools: Module info '${module_name}'\n\n"
    printf "  Sorry, No such module installed!\n\n"
    printf "===============================================================\n\n"
}

function _bt_show_warn(){

    echo "${@}"
}


function bashtools(){

    if [[ -z "${@}" ]]
        then
            _bt_help_menu
            return
    fi

    OPTIND=1 # Absolutely vital to reset this to 1
    while getopts ":hlm:" opt
    do
        case "${opt}" in
            h)
                _bt_help_menu
                return
                ;;
            l)
                _bt_list_modules
                return
                ;;
            m)
                _bt_modules_info "${OPTARG}"
                return
                ;;
            \?)
                _bt_show_warn "Unrecognised option: -${OPTARG}"
                _bt_help_menu
                return
                ;;
        esac
    done

    # Enable autocompletion
    if [[ "${@}" == "boot" ]]
        then
            source "$BASHTOOLS_HOME/etc/rootautocomplete.sh"
    fi

    return

}

bashtools "boot"
