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

    search_str=${1}

    container_id=$(docker ps | grep ${search_str} | grep -Eo '^[^ ]+')

	echo $(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${container_id})
}

