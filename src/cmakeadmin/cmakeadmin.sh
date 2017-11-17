#!/bin/sh
################################################################
#
##{name:   cmakeadmin
##{vers:   0.0.1
##{auth:   Rimas Krivickas
##{aurl:   github.com/rimusdesign
##{mail:   rimas@rimusgroup.co.uk
#
##{desc:   Collection of convenience methods for CMake.
#
################################################################



##{fdes:   Shortcut for 'gradle init --type <DESIRED_TYPE>'.
##{fdes:   Simplified type shortcuts provided:
##{fdes:     lib = java-library
##{fdes:     exe = java-application
##{fpar:   Desired project type.
##{frpr:   Time in minutes
function cmkinit(){

    # Validate and set input
    gen_type=${1}
    if [ -z ${gen_type} ]
		then
			gen_type="basic"
	elif [ ${gen_type} == "app" ]
	    then
			gen_type="java-application"
	elif [ ${gen_type} == "lib" ]
	    then
			gen_type="java-library"
	elif [ ${gen_type} == "-h" ]
	    then
	        btu_prnti "In addition to regular types simplified shorthands can be used:\n\n    app = java-application\n    lib = java-library"
	        gradle help --task init
	        return 0
	fi

    gradle init --type ${gen_type}

}