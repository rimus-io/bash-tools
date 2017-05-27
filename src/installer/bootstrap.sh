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

# Activate utils
source "${BASHTOOLS_HOME}/etc/utils.sh"


# Banner and info
version=$(grep -iE -e "version=" "$BASHTOOLS_HOME/etc/main.cfg" | sed "s/version=//")
banner=$(grep -iE -e "banner=" "$BASHTOOLS_HOME/etc/main.cfg" | sed "s/banner=//")
banner_tmpl="\n \033[90m _ \033[0m\033[1m%s\033[0m \033[90m%"$((80 - (${#banner}+${#version}-2)))"s\033[0m\n"
printf "${banner_tmpl}" "${banner}" "v. ${version}"
printf "\033[34m_________________________________________________________________________\033[0m\n"
printf "\033[90m                                                            bashtools -h \033[0m\n"
printf "\033[90m‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾\033[0m\n"
unset version
unset banner
unset banner_tmpl


# Read and set parameters from 'main.cfg'
declare bashtools_develop=false # Declaring 'bashtools_develop' here to prevent undeclared var error messages
declare -a module_list=()
bashtools_develop=$(grep -iE -e "develop=" "$BASHTOOLS_HOME/etc/main.cfg" | sed "s/develop=//")


# Check if installation has been performed before proceeding, but allow execution if in development mode
bashtools_installed=false
bashtools_installed=$(grep -iE -e "installed=" "$BASHTOOLS_HOME/etc/main.cfg" | sed "s/installed=//")
if [[ ${bashtools_installed} == false ]]
then
    if $bashtools_develop
    then
        echo "INFO: 'bash-tools' --> Running in development mode."
    else
        unset btr
        echo "Sorry, you have to install 'bash-tools' first."
        exit 1 # Exit with error
    fi
fi


# Get list of modules
module_list=($(ls $BASHTOOLS_HOME/installed/))


# Register modules
for module in ${module_list[@]}
do
    module_name=${module}
    is_enabled=false
    is_enabled=$(grep -iE -e "enabled=" $BASHTOOLS_HOME/installed/$module_name/module.cfg | sed "s/enabled=//")
    # Only bootstrap if enabled
    if [[ ${is_enabled} == true ]]
    then
        auto_source=false
        auto_source=$(grep -iE -e "auto_source=" $BASHTOOLS_HOME/installed/$module_name/module.cfg | sed "s/auto_source=//")
        source "$BASHTOOLS_HOME/etc/hook.sh" $module_name $auto_source
        echo "INFO: 'bash-tools' --> Bootstrapping module: $module_name, auto source: $auto_source"
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
echo ""
docgen_shutdown
unset bashtools_installed
unset module
unset module_list


function btr() {
    sh dev_clean_build.sh -fcv
    exit
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
