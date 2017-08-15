#!/bin/sh
################################################################
#
##{name:   gradleadmin
##{vers:   0.0.1
##{auth:   Rimas Krivickas
##{aurl:   github.com/rimusdesign
##{mail:   rimas@rimusgroup.co.uk
#
##{desc:   Collection of convenience methods for Gradle.
#
################################################################


##{fdes:   Shortcut for 'gradle'.
##{fdes:   If detects generated wrapper - will use './gradlew'.
##{fpar:   Any list of usual parameters.
function gr(){

    if [ -f gradlew ]
        then
            btu_prnti "Wrapper found, using './gradlew'.\nTo ignore wrapper, use 'grr' shortcut, or 'gradle' command directly."
            ./gradlew ${@}
     else
        gradle ${@}
    fi

}

##{fdes:   Shortcut for 'gradle wrapper'.
##{fpar:   If flag 'rm' is passed, the wrapper will be removed.
function grw(){

    # Validate and set input
    param_val=${1}
    if [ -z ${param_val} ]
		then
		    btu_prnti "Generating gradle wrapper."
            gradle wrapper
    else
        if [ ${param_val} == "rm" ]
            then
                had_wrapper=false
                if [ -f "gradlew" ]
                    then
                        had_wrapper=true
                        rm -f "gradlew"
                fi

                if [ -d ".gradle" ]
                    then
                        rm -rf ".gradle"
                fi

                if [ -d "gradle" ]
                    then
                        rm -rf "gradle"
                fi

                if [ -f "gradlew.bat" ]
                    then
                        rm -f "gradlew.bat"
                fi

                if [ ${had_wrapper} == true ]
                    then
                        btu_prnti "Wrapper found, and removed."
                fi
        else
            btu_prnte "Unknown flag '${param_val}' provided.\nUse 'rm' if you want to get rid of the wrapper."
        fi
	fi

}

##{fdes:   Shortcut for 'gradle' (raw).
##{fdes:   Similar to 'gr', but wrapper is ignored.
##{fpar:   Any list of usual parameters.
function grr(){

    if [ -f gradlew ]
        then
            btu_prnti "Wrapper found, but will be ignored"
    fi
    gradle ${@}

}


##{fdes:   Shortcut for 'gradle test'.
function grt(){

    clear
    gr test

}


##{fdes:   Shortcut for 'gradle init --type <DESIRED_TYPE>'.
##{fdes:   Simplified type shortcuts provided:
##{fdes:     app = java-application
##{fdes:     lib = java-library
##{fpar:   Desired project type.
function grinit(){

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