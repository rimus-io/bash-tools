#!/bin/sh
################################################################
#
##{name:   quickadmin
##{vers:   0.0.1
##{auth:   Rimas Krivickas
##{aurl:   github.com/rimusdesign
##{mail:   rimas@rimusgroup.co.uk
#
##{desc:   Collection of convenience methods.
##{desc:   Easy access to advanced system features etc.
#
################################################################



##{fdes:   Sets 'sudo' session time to the given value.
##{fdes:   Requires 'sudo' access to complete.
##{frpr:   Time in minutes
function sutime(){

	# Get current session timeout value
	curr_time=15
	if [[ -f ~/sudoers_curr ]]
		then
			while read line; do
				curr_time=${line}
			done < ~/sudoers_curr
	fi

	if [[ ${curr_time} -eq 0 ]]; then
		echo "Currently 'sudo' will always ask for the password"
	elif [[ ${curr_time} -eq -1 ]]; then
		echo "Currently 'sudo' will never ask for the password"
	elif [[ ${curr_time} -eq 15 ]]; then
		echo "Currently 'sudo' session is set to default timeout: 15 min"
	else
		echo "Currently 'sudo' session is set to timeout after: ${curr_time} min"
	fi

	# Make a fresh copy of the template
	cp ~/sudoers_copy ~/sudoers_copy.tmp

	# Write timeout value to the template
	echo "Processing..."
	echo "Defaults	timestamp_timeout=${1}" | sudo tee -a ~/sudoers_copy.tmp > /dev/null 2>&1

	# Overwrite sudoers file with our template
	echo "Activating new session timeout..."
	sudo cp ~/sudoers_copy.tmp /etc/sudoers

	# Persist current timeout value
	echo ${1} > ~/sudoers_curr

	# Clean up
	rm -f ~/sudoers_copy.tmp

	status_msg=""
	if [[ ${1} -eq 0 ]]; then
		status_msg="Now 'sudo' will always ask for the password"
	elif [[ ${1} -eq -1 ]]; then
		status_msg="Now 'sudo' will never ask for the password"
	elif [[ ${1} -eq 15 ]]; then
		status_msg="Now 'sudo' session is set to default timeout: 15 min"
	else
		status_msg="Now 'sudo' session is set to timeout after: ${curr_time} min"
	fi

	echo "Done! "${status_msg}
}


##{fdes:   Switches 'sudo' session to infinity.
##{fdes:   Will not require 'sudo' password until
##{fdes:   session time is changed again.
function suoff(){

	sutime "-1"
}


##{fdes:   Resets 'sudo' session time to default value.
##{fdes:   Defaults to 15 minutes.
function sureset(){

	sutime "15"
}


##{fdes:   Switches 'sudo' session to zero.
##{fdes:   Will always require to type 'sudo'
##{fdes:   password until settings are changed.
function suallways(){

	sutime "0"
}


##{fdes:   Convenience command to save typing.
##{fdes:   Activates Python virtual environment.
function venvactivate(){

	source venv/bin/activate
}

##{fdes:   Convenience command to save typing.
##{fdes:   Essentially a shortcut for:
##{fdes:   $ sudo vim ~/.bash_profile
function bedit(){

	sudo vim ~/.bash_profile
}

##{fdes:   Convenience command to save typing.
##{fdes:   Essentially a shortcut for:
##{fdes:   $ cat ~/.bash_profile
function bcat(){

	cat ~/.bash_profile
}

##{fdes:   Convenience command to save typing.
##{fdes:   Essentially a shortcut for:
##{fdes:   $ source ~/.bash_profile
function breset(){

	source ~/.bash_profile
}