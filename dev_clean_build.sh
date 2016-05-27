#!/bin/sh

# Force flag
force=false
verbose=false
install=false
OPTIND=1 #Absolutely vital to reset this to 1
while getopts ":fcvi" OPTION
do
    case $OPTION in
        c)
            clear
            ;;
        f)
            force=true
            ;;
        v)
            verbose=true
            ;;
        i)
            install=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            echo "
The only valid options are:
    f - Forces a clean build.
    c - Clears the terminal window.
"
            exit
            ;;
    esac
done


# Prevent deleting legitimate startup files
echo "
================================

Development: Clean Build

================================
"
if $force
then
    echo "Forcing clean build..."
fi

if ! $force
then
    understand_risk=false
    echo "WARNING: This will delete all '.bash_profile*' files from
the system, including trash directory.
Are you sure you want to continue? (y/n):"
    while ! $understand_risk
    do
        read confirmation
        if [ "$confirmation" = "y" ]
        then
            understand_risk=true
        elif [ "$confirmation" = "n" ]
        then
            echo "Quitting development clean build process...

--------------------------------"
            exit
        else
            echo "Please type 'y' to continue or 'n' to exit:"
        fi
    done
fi

# Check if ant exists
if hash ant 2>/dev/null; then
    echo "Build tool 'ant' is installed, can proceed"
else
    echo "Build tool 'ant' is not installed, cannot proceed"
    echo "Quitting development clean build process...

--------------------------------"
    exit
fi


# Removes all '.bash_profile*' files
echo "Cleaning up..."
find ~/ -iname ".bash_profile.*" -exec rm -f {} \; -print


# Build distribution
echo "Building distribution..."
if $verbose
then
    ant -DDEVELOP=
else
    ant -DDEVELOP= > /dev/null 2>&1
fi


# Install distribution
if $install
then
    echo "Running a clean 'bash-tools' install..."
    sudo sh dist/bash-tools/install.sh
fi


echo "
DONE! Nice and clean...

--------------------------------
"