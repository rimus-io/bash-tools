#!/bin/sh
################################################################
#
##{name:   dockradmin
##{vers:   0.0.1
##{auth:   Rimas Krivickas
##{aurl:   github.com/rimusdesign
##{mail:   rimas@rimusgroup.co.uk
#
##{desc:   Collection of convenience methods for Docker.
##{desc:   Get IPs of running services by name, etc.
#
################################################################



##{fdes:   Returns an IP of specified Docker container.
##{frpr:   Name of service (has to be at least partial)
function dip(){


    # Validate and set input
    search_str=${1}
    if [ -z ${search_str} ]
		then
			echo "Please provide a search string. Example: dip <YOUR_SEARCH_STRING>"
			return 1
	fi

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

    # Retrieve container ID
    container_id=$(docker ps | grep ${search_str} | grep -Eo '^[^ ]+')
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="No running container matches search string '${search_str}', can't retrieve container ID."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

    # Retrieve container IP within Docker
    container_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container_id})
    response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="hmmm 2"
			echo "${alias_error_msg}: ${response_code}"
			return ${response_code}
	fi

    # Error if IP is not found
	if [[ -z ${container_ip} ]]
		then
			echo "Container with ID '${container_id}' does not seem to have a Docker IP assigned to it. Container may be connected to 'host' or other network."
			return 1
	fi

    # Error if multiple IPs found
    stripped_str=${container_ip//[[:digit:]]/}
    if [ ${#stripped_str} != 3 ]
        then
            echo "Multiple IPs match the search string '${search_str}': ${container_ip//[[:space:]]/, }"
            return 1

    fi

    # Return the IP
	echo ${container_ip//[[:space:]]/}
	return 0
}

##{fdes:   Returns an ID of specified Docker container.
##{frpr:   Name of service (has to be at least partial)
function did(){

    # Validate and set input
    search_str=${1}
    if [ -z ${search_str} ]
		then
			echo "Please provide a search string. Example: did <YOUR_SEARCH_STRING>"
			return 1
	fi

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

    # Retrieve container ID
    container_id=$(docker ps | grep ${search_str} | grep -Eo '^[^ ]+')
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="No running container matches search string '${search_str}', can't retrieve container ID."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

    # Return the ID
	echo ${container_id}
	return 0
}

##{fdes:   Kills all running Docker containers.
function dkillall(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

	# TODO Ask to confirm

	# Get running container IDs
	container_ids=$(docker ps -q)
	if [[ -z ${container_ids} ]]
	    then
	        echo "No running containers to be killed"
	        return 0
	fi

	# Kill all containers
	docker kill ${container_ids} > /dev/null 2>&1
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "There was a problem trying to kill running containers."
			return ${response_code}
	fi

    return 0

}

##{fdes:   Removes all Docker containers, including running ones.
function drmall(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

    # TODO Ask to confirm

	# Get container IDs
	container_ids=$(docker ps -a -q)
	if [[ -z ${container_ids} ]]
	    then
	        echo "No containers to be removed."
	        return 0
	fi

	# Remove all containers, force kill if needed
	docker rm -f ${container_ids} > /dev/null 2>&1
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "There was a problem trying to remove all containers."
			return ${response_code}
	fi

    return 0

}

##{fdes:   Removes all Docker images.
##{fdes:   WARNING: All images will have to be rebuilt.
function dirmall(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

	# TODO Ask to confirm

	# Get image IDs
	image_ids=$(docker images -q)
	if [[ -z ${image_ids} ]]
	    then
	        echo "No images to be removed."
	        return 0
	fi

	# Remove all images
	docker rmi -f ${image_ids} > /dev/null 2>&1
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "There was a problem trying to remove all images."
			return ${response_code}
	fi

    return 0

}

##{fdes:   Displays running Docker containers.
function dl(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

	# Get containers IDs
	container_ids=$(docker ps -q)
	if [[ -z ${container_ids} ]]
	    then
	        echo "No running containers."
	        return 0
	fi

    # Retrieve container details
    response_text=$(docker inspect --format '{{ printf "╭─ Container: %s [ id: %.12s ] ─┐\n┆\n┆%10s\t%s\n┆%10s\t%s\n" .Name .Id "Image:" .Config.Image "IP:" .NetworkSettings.IPAddress }}{{ printf "┆%13s\n" "Ports: ─┐" }}{{ range $key, $element := .HostConfig.PortBindings }}{{ printf "┆%13.13s\t%s -> " "├" $key }}{{ range $key2, $element2 := $element }}{{ printf "%s\n" $element2.HostPort }}{{ end }}{{ end }}{{ printf "%.13s" "┆\n╰─── ┄ ┄ ┄" }}' ${container_ids})
    response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "Encountered a problem while retrieving information."
			return ${response_code}
	fi

    if [[ -z ${response_text} ]]
	    then
	        echo "No details found."
	        return 0
	fi

    echo ""
	echo "${response_text}"
    echo ""
    return 0
}

##{fdes:   Displays running Docker containers.
##{fdes:   Same as 'dl', but returns less details.
function dlq(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

	# Get containers IDs
	container_ids=$(docker ps -q)
	if [[ -z ${container_ids} ]]
	    then
	        echo "No running containers."
	        return 0
	fi

    # Retrieve container details
    response_text=$(docker inspect --format '{{ printf "%.12s %s" .Id .Name }}' ${container_ids})
    response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "Encountered a problem while retrieving information."
			return ${response_code}
	fi

    if [[ -z ${response_text} ]]
	    then
	        echo "No details found."
	        return 0
	fi

	echo "${response_text}"
    return 0
}


##{fdes:   Displays all Docker containers.
function dla(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

	# Get containers IDs
	container_ids=$(docker ps -a -q)
	if [[ -z ${container_ids} ]]
	    then
	        echo "No containers found."
	        return 0
	fi

	# Retrieve container details
    response_text=$(docker inspect --format '{{ printf "╭─ Container: %s [ id: %.12s ] ─┐\n┆\n┆%10s\t%s\n┆%10s\t%s\n" .Name .Id "Image:" .Config.Image "IP:" .NetworkSettings.IPAddress }}{{ printf "┆%13s\n" "Ports: ─┐" }}{{ range $key, $element := .HostConfig.PortBindings }}{{ printf "┆%13.13s\t%s -> " "├" $key }}{{ range $key2, $element2 := $element }}{{ printf "%s\n" $element2.HostPort }}{{ end }}{{ end }}{{ printf "%.13s" "┆\n╰─── ┄ ┄ ┄" }}' ${container_ids})
    response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "Encountered a problem while retrieving information."
			return ${response_code}
	fi

    if [[ -z ${response_text} ]]
	    then
	        echo "No details found."
	        return 0
	fi

    echo ""
	echo "${response_text}"
    echo ""
    return 0
}

##{fdes:   Displays all Docker containers.
##{fdes:   Same as 'dla', but returns less details.
function dlaq(){

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

	# Get containers IDs
	container_ids=$(docker ps -a -q)
	if [[ -z ${container_ids} ]]
	    then
	        echo "No containers found."
	        return 0
	fi

	# Retrieve container details
	response_text=$(docker inspect --format '{{ printf "%.12s %s" .Id .Name }}' ${container_ids})
    response_code=${?}
    if [ ${response_code} != "0" ]
		then
			echo "Encountered a problem while retrieving information."
			return ${response_code}
	fi

    if [[ -z ${response_text} ]]
	    then
	        echo "No details found."
	        return 0
	fi

	echo "${response_text}"
    return 0
}

##{fdes:   Generates dns configuration file.
##{fdes:   NOTE: To be used with Docker, and 'dnsmasq' service.
##{frpr:   Input file. Can be multi-line (one value per line). Lines must adhere to the following format: <SEARCH_STRING>=<DESIRED_HOSTNAME>
function dgen(){

    # Validate and set input
    input_file=${1}
    if [ -z ${input_file} ]
		then
			echo "Please provide input file. Example: dgen /path/to/file"
			return 1
	fi

    # Check if Docker is running
    docker_info=$(docker info > /dev/null 2>&1)
	response_code=${?}
    if [ ${response_code} != "0" ]
		then
			alias_error_msg="Check if docker is installed, and is running."
			echo "${alias_error_msg}"
			return ${response_code}
	fi

    # Iterate through lines
    while read line
    do
        # Clear whitespaces
        clean_line="${line//[[:space:]]/}"

        # Write comment to identify mapping
        echo "# $( echo ${clean_line} | sed -e 's/=/ -> /g')"

        # Check if formatted correctly
        if [[ "${clean_line}" != *"="* ]]
            then
                echo "# ERROR: Invalid mapping format '${line}'"
            else

                # Retrieve values
                IFS='=' read -ra key_val <<< "${clean_line}"

                # Validate values
                if [[ "${#key_val[@]}" != 2 ]]
                    then
                        echo "# ERROR: Invalid mapping format '${line}'"
                    else
                        search_str="${key_val[0]}"
                        hostname="${key_val[1]}"
                        if [[ -z ${search_str} || -z ${hostname} ]]
                            then
                                 echo "# ERROR: Invalid mapping format '${line}'"
                            else
                                ip=$(dip ${search_str})
                                response_code=${?}
                                if [ ${response_code} != "0" ]
                                    then
                                        echo "# INFO: No IP assigned"
                                    else
                                        echo "address=/${hostname}/${ip}"
                                        echo "txt-record=txt.${hostname}"
                                fi
                        fi
                fi
        fi
        echo ""
    done < ${input_file}

}