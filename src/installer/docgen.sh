#!/bin/sh


function _write_main_details() {

	printf "===============================================================\n\n"

	local module_details_fmt="%14s %s\n"
	local title_label=""

	# Name
	local doc_name="$(grep -iEo -e '^\d*:(##\{name:)[ \t]*(.*)' ${temp_doc_dump} | sed 's/^\([0-9,:]*##{name:[ \t]*\)//')"
	if [[ ! -z "${doc_name}" ]]
	then
		title_label="Name:"
		printf "${module_details_fmt}" "${title_label}" "${doc_name}"
	fi

	# Version
	local doc_version="$(grep -iEo -e '^\d*:(##\{vers:)[ \t]*(.*)' ${temp_doc_dump} | sed 's/^\([0-9,:]*##{vers:[ \t]*\)//')"
	if [[ ! -z "${doc_version}" ]]
	then
		title_label="Version:"
		printf "${module_details_fmt}" "${title_label}" "${doc_version}"
	fi

	# Author
	local doc_author="$(grep -iEo -e '^\d*:(##\{auth:)[ \t]*(.*)' ${temp_doc_dump} | sed 's/^\([0-9,:]*##{auth:[ \t]*\)//')"
	if [[ ! -z "${doc_author}" ]]
	then
		title_label="Author:"
		printf "${module_details_fmt}" "${title_label}" "${doc_author}"
	fi

	# URL
	local doc_url="$(grep -iEo -e '^\d*:(##\{aurl:)[ \t]*(.*)' ${temp_doc_dump} | sed 's/^\([0-9,:]*##{aurl:[ \t]*\)//')"
	if [[ ! -z "${doc_url}" ]]
	then
		title_label="URL:"
		printf "${module_details_fmt}" "${title_label}" "${doc_url}"
	fi

	# E-mail
	local doc_email="$(grep -iEo -e '^\d*:(##\{mail:)[ \t]*(.*)' ${temp_doc_dump} | sed 's/^\([0-9,:]*##{mail:[ \t]*\)//')"
	if [[ ! -z "${doc_email}" ]]
	then
		title_label="E-mail:"
		printf "${module_details_fmt}" "${title_label}" "${doc_email}"
	fi

	# Description
	local tmp_store=$(mktemp /tmp/bash_tls_temp_store.XXXXXX)
	title_label="Description:"

	local title_printed=false
	grep -iE -e '^\d*:(##\{desc:)[ \t]*(.*)' ${temp_doc_dump} | tee -a ${tmp_store} > /dev/null 2>&1
	sed -i.bak 's/^\([0-9,:]*##{desc:[ \t]*\)//g' ${tmp_store}
	while read -r line
	do
		if ! ${title_printed}
		then
			title_printed=true
		else
			title_label=""
		fi
		printf "${module_details_fmt}" "${title_label}" "${line}"
	done < ${tmp_store}

	rm ${tmp_store}
	rm ${tmp_store}".bak"

	printf "\n - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - \n\n"
}

function _write_api_details() {

	local command_name_fmt="      Command: %s\n\n"
	local command_desc_fmt="                 %s\n"
	local command_params_fmt="                  > param:  %s\n"
	local command_returns_fmt="               returns:  %s\n"
	local req_param_label="[required]"
	local tmp_store=$(mktemp /tmp/bash_tls_temp_store.XXXXXX)
	grep -iE -e '^\d*:(##\{f[a-z]{3}:)[ \t]*(.*)'  -e "^\d*:(function)[ \t]*[A-Z,a-z,_,0-9]*[ \t]*\([ \t]*\)" ${temp_doc_dump} | tee -a ${tmp_store} > /dev/null 2>&1

	local command_name=""
	local desc_lines=()
	local params=()
	local return_val=""
	while read -r line
	do

		stripped_line=$(echo ${line} | sed 's/^\([0-9,:]*##{\)//')
		case ${stripped_line:0:4} in
        fdes)
        	# Description line
			desc_lines+=("$(echo ${line} | sed 's/^\([0-9,:]*##{[a-z]*:[ \t]*\)//')")
            ;;
        fpar)
        	# Param
			params+=("$(echo ${line} | sed 's/^\([0-9,:]*##{[a-z]*:[ \t]*\)//')")
            ;;
        frpr)
        	# Required param
			params+=("${req_param_label} $(echo ${line} | sed 's/^\([0-9,:]*##{[a-z]*:[ \t]*\)//')")
            ;;
        fret)
        	# Return value
			return_val="$(echo ${line} | sed 's/^\([0-9,:]*##{[a-z]*:[ \t]*\)//')"
            ;;
        *)
			# Must be a command name
			command_name=$(echo ${line} | sed 's/^\([0-9,:]*function[ \t]*\)//')
			command_name=$(echo ${command_name} | sed 's/([ \t]*)[ \t]*{[ \t]*//')
			if [[ ${#desc_lines} != 0 ]]
			then
				# Write details
				printf "${command_name_fmt}" "${command_name}"
				printf "${command_desc_fmt}" "${desc_lines[@]}"
				printf "\n"
				if [[ ${#params} != 0 ]]
				then
					printf "${command_params_fmt}" "${params[@]}"
					printf "\n"
				fi
				if [[ ! -z ${return_val} ]]
				then
					printf "${command_returns_fmt}" "${return_val}"
					printf "\n"
				fi
				printf "\n"
			fi
			# Reset values
			command_name=""
			desc_lines=()
			params=()
			return_val=""
            ;;
    	esac
	done < ${tmp_store}

	printf "===============================================================\n\n"

	rm ${tmp_store}
}

function _persist_docs() {
	cp ${temp_doc} ${doc_file}
}

function generate_docs() {

	# Create doc directory if doesn't exist
	if [ ! -d "${BASHTOOLS_HOME}/docs/" ]
	then
		mkdir -p "${BASHTOOLS_HOME}/docs/"
	fi

	local src="${1}" module_name="${2}" temp_doc_dump temp_doc doc_file

	temp_doc_dump=$(mktemp /tmp/bash_tls_doc_dump.XXXXXX)
	temp_doc=$(mktemp /tmp/bash_tls_doc.XXXXXX)
	doc_file="${BASHTOOLS_HOME}/docs/${module_name}.info"

	# Strip source of all metadata
	grep -niE -e "^(##\{[a-z]{4}:).*" -e "^(function)[ \t]*[A-Z,a-z,_,0-9]*[ \t]*\([ \t]*\)" ${src} | tee -a ${temp_doc_dump} > /dev/null 2>&1

	_write_main_details | tee -a ${temp_doc} > /dev/null 2>&1
	_write_api_details | tee -a ${temp_doc} > /dev/null 2>&1

	_persist_docs

	# Clean up
	rm ${temp_doc_dump}
	rm ${temp_doc}

}

function docgen_shutdown(){

	unset _write_main_details
	unset _write_api_details
	unset _persist_docs
	unset generate_docs
	unset docgen_shutdown
}