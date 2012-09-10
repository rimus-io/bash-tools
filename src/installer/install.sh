#!/bin/sh
################################################################
#
#   This script installs 'bash-tools'
#
################################################################


# General vars
step="Action:"
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")


# Getting current directory
root_location="$(pwd)/$(dirname $0)"
version_info_file="$root_location/version.info"


# Prevent installation if it has been performed already
if [ -f "$root_location/st" ]
then
    echo "You already have 'bash-tools' installed!"
    exit 1 # Exit with error
fi


# Setting version details from 'version.info' file if it exists
version_info=
release_date_info=
release_time_info=
if [ -f "$version_info_file" ]
then
    index=0
    while read line
    do
        if [ $index -eq 0 ]
        then
            version_info=$line
        fi
        if [ $index -eq 1 ]
        then
            release_date_info=$line
        fi
        if [ $index -eq 2 ]
        then
            release_time_info=$line
        fi
        index=$((index+1))
    done < "$version_info_file"
fi


# Print out details
echo "
================================

Installing:     bash-tools"

if [ -f "$version_info_file" ]
then
    echo ""
    echo "Version:        $version_info"
    echo "Release date:   $release_date_info"
    echo "Release time:   $release_time_info"
fi

echo "
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
            echo "$step No startup file found - '.bash_profile' file has been created in your user directory."
        fi
    fi
fi


# Backing up startup file
bash_file_backup="${bash_file}.bash-tools-SAVED.$timestamp.backup"
sudo cp ~/$bash_file ~/$bash_file_backup
echo "$step Backed up '$bash_file' as '$bash_file_backup'."


# Patch startup file to include bash-tools on login
bootstrap_file="$root_location/bootstrap.sh"
bootstrap_patch="
# Including 'bash-tools'
source $bootstrap_file"
echo "$bootstrap_patch" >> ~/$bash_file
echo "$step Patched up '$bash_file' file to include 'bash-tools' on login."


# Write status file to mark successful installation
echo "" > "$root_location/st"


# Print out success message
echo "
Installation complete!
NOTE: You will have to re-login for changes to take effect.

Enjoy!

--------------------------------
"