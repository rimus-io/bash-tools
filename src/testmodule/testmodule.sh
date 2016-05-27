#!/bin/sh
################################################################
#
#   testmodule -  just a test module
#
################################################################


function testme() {
	echo "You're being tested..."
}

# Constructor
function main() {
    testme
}

# Destructor
function destructor() {
    # Unset constructor and destructor
    unset main
    unset destructor

    # Unset variables

    # Unset methods
}

main ${@}
destructor