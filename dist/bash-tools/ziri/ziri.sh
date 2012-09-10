#!/bin/sh
################################################################
#
#   Ziri - your personal assistant and your best friend!
#
################################################################


# Set default values
_speach_enabled=false
_patience_threshold=0
_MESAGE_TYPE_QUESTION="Type your question:"
_MESSAGE_GREETING="Hello, good to see you! How can I help you today?"
_MESSAGE_RESPONSE_ONE="I'm sorry, I do not understand your question..."
_MESSAGE_RESPONSE_TWO="What do you mean?"
_MESSAGE_GOOD_BYE="Oh, just leave me alone, sex and the city is about to start... Good bye!"


# Ziri speach command
function _ziri_say() {
    if [ "${@}" ]
    then
        echo "Ziri: ${@}"
        if $_speach_enabled
        then
            say "${@}"
        fi
    fi
}


# Main Q&A loop
function _qa_loop() {
    while [ $_patience_threshold -gt 0 ]
    do
        read question
        if [ $_patience_threshold -eq 1 ]
        then
            _ziri_say "$_MESSAGE_GOOD_BYE"
        else
            if [ $[ 1 + $[ RANDOM % 10 ]] -ge 5 ]
            then
                _ziri_say "$_MESSAGE_RESPONSE_ONE"
            else
                _ziri_say "$_MESSAGE_RESPONSE_TWO"
            fi
            echo "$_MESAGE_TYPE_QUESTION"
        fi
        _patience_threshold=$(( $_patience_threshold - 1 ))
    done
    unset question
}


# Constructor
function main() {
    # Set number of questions to answer
    _patience_threshold=$[ 3 + $[ RANDOM % 6 ]]

    # Find out if 'say' is available
    app=$(command -v say)
    if [ ${#app} -gt 0 ]
    then
        _speach_enabled=true
    else
        _speach_enabled=false
    fi
    unset app

    # Check if initial question is supplied
    if [ ! "${@}" ]
    then
        _ziri_say "$_MESSAGE_GREETING"
    else
        _ziri_say "$_MESSAGE_RESPONSE_ONE"
    fi
    echo "$_MESAGE_TYPE_QUESTION"

    _qa_loop
}


# Destructor
function destructor() {
    # Unset constructor and destructor
    unset main
    unset destructor

    # Unset variables
    unset _speach_enabled
    unset _patience_threshold
    unset _MESAGE_TYPE_QUESTION
    unset _MESSAGE_GREETING
    unset _MESSAGE_RESPONSE_ONE
    unset _MESSAGE_RESPONSE_TWO
    unset _MESSAGE_GOOD_BYE

    # Unset methods
    unset _ziri_say
    unset _qa_loop
}


# Run, then clean up
main ${@}
destructor