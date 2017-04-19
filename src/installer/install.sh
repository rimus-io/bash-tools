#!/bin/sh
################################################################
#
#   This script installs 'bash-tools'
#
################################################################


# General vars
step="Action:"
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")


# Verbose method to control 'echo'
verbose=false
OPTIND=1 #Absolutely vital to reset this to 1
while getopts ":v" OPTION
do
    case ${OPTION} in
        v)
            verbose=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            return # Not 'exit' as that would kick you out of shell
            ;;
    esac
done

function _verbose() {
    if ${verbose}
    then
        echo "${@}"
    fi
}


# Navigate to the path so all file references work
REL_PATH=${BASH_SOURCE%/*}
cd $REL_PATH


# Getting current directory
root_location=$(pwd)
build_info_file="$root_location/build.info"

# Prevent installation if it has been performed already
bashtools_installed=false
bashtools_installed=$(grep -iE -e "installed=" "$root_location/main.cfg" | sed "s/installed=//")
if [[ ${bashtools_installed} == true ]]
then
    _verbose "You already have 'bash-tools' installed!"
    exit 1 # Exit with error
fi


# Setting version details from 'build.info' file if it exists
version_info=$(grep -iE -e "version=" "$root_location/main.cfg" | sed "s/version=//")
release_date_info=$(grep -iE -e "build_date=" ${build_info_file} | sed "s/build_date=//")
release_time_info=$(grep -iE -e "build_time=" ${build_info_file} | sed "s/build_time=//")


# Print out details
_verbose "
================================

Installing:     bash-tools"

if [ -f "$build_info_file" ]
then
    _verbose ""
    _verbose "Version:        $version_info"
    _verbose "Release date:   $release_date_info"
    _verbose "Release time:   $release_time_info"
fi

_verbose "
================================
"


# Determine which startup file to use
# File selection sequence here follows the same pattern as shell does on login
bash_file=
if [ -f ~/.bash_profile ]
then
    bash_file=.bash_profile
else
    if [ -f ~/.bash_login ]
    then
        bash_file=.bash_login
    else
        if [ -f ~/.profile ]
        then
            bash_file=.profile
        else
            # No startup files found - create startup file
            echo "#!/bin/sh" > ~/.bash_profile
            bash_file=.bash_profile
            _verbose "$step No startup file found - '.bash_profile' file has been created in your user directory."
        fi
    fi
fi



# Backing up startup file
bash_file_backup="${bash_file}.bash-tools-SAVED.$timestamp.backup"
sudo cp ~/${bash_file} ~/${bash_file_backup}
_verbose "$step Backed up '$bash_file' as '$bash_file_backup'."



# Patch startup file to include bash-tools on login
bootstrap_file=$(echo "$root_location" | sed "s/\/etc//")"/bootstrap.sh"
bootstrap_patch_start="# ----------------------{ Including 'bash-tools' }-----------------------"
bootstrap_patch_sources="source $bootstrap_file"
bootstrap_patch_end="# -------------------------------- Enjoy! -------------------------------"
bootstrap_patch=${bootstrap_patch_start}"\n\n"${bootstrap_patch_sources}"\n\n"${bootstrap_patch_end}"\n"

# Check if startup file already contains installation details
do_write_details=false
if grep -q "${bootstrap_patch_start}" ~/${bash_file}
    then
        _verbose "$step Already contains bash-tools"
        # Check if sources match
        if grep -q "${bootstrap_patch_sources}" ~/${bash_file}
            then
                _verbose "$step Installation details valid"
                do_write_details=fale
        else
            _verbose "$step Source path mismatch!"
            # Get cleaned up bash file and save it into a temporary fle
            temp_bash_file=$(mktemp /tmp/bash_tls_clean_start.XXXXXX)
            grep -iEv -e "^[ \n\r]{2,}$"  -e "${bootstrap_patch_start}" -e "(bash-tools([A-Z,a-z,0-9,/\\-_+.:|,])*bootstrap.sh)$" -e "${bootstrap_patch_end}" ~/${bash_file} | tee -a ${temp_bash_file} > /dev/null 2>&1

            # Cleanup empty lines
            empty_lines=($(grep -anE -e '^$' ${temp_bash_file}))
            lines_to_remove=()
            prev_line_num=0
            allowed_lines=2
            curr_allowed=${allowed_lines}
            for i in "${empty_lines[@]}"
            do
                if [[ "${curr_allowed}" != 0 && "${prev_line_num}" != 0 ]]
                then
                    curr_allowed=$((${curr_allowed}-1))
                fi
                expected_line_num=$((${prev_line_num}+1))
                len=$((${#i}-1))
                curr_line_num=${i:0:len}
                if [[ "${expected_line_num}" == "${curr_line_num}" ]]
                then
                    if [[ "${curr_allowed}" == 0 ]]
                    then
                        # Add previous line to lines to remove
                        lines_to_remove+=(${expected_line_num})
                    fi
                else
                    # Reset allowed line counter
                    curr_allowed=${allowed_lines}
                fi
                # Update previous line
                prev_line_num=${curr_line_num}
            done

            sed_string=""
            for i in "${lines_to_remove[@]}"
            do
                sed_string+=${i}'d;'
            done
            sed_string=${sed_string/%";"/""}
            sed -i.bak ${sed_string} ${temp_bash_file}

            # Overwrite startup file with cleaned up startup file
            sudo cp ${temp_bash_file} ~/${bash_file}
            # Clean up
            rm ${temp_bash_file}
            rm ${temp_bash_file}".bak"
            do_write_details=true
        fi
else
    do_write_details=true
fi

if [[ ${do_write_details} == true ]]
    then
        while read -re line
        do
            echo ${line} | sudo tee -a ~/${bash_file} > /dev/null 2>&1
        done <<< ${bootstrap_patch}
        _verbose "$step Patched up '$bash_file' file to include 'bash-tools' on login."
fi

# Write status file to mark successful installation
echo "installed=true" >> "$root_location/main.cfg"
echo "installed_on=$timestamp" >> "$root_location/main.cfg"

# Print out success message
_verbose "
Installation complete!
NOTE: You will have to re-login for changes to take effect.

Enjoy!

--------------------------------
"