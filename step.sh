#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${THIS_SCRIPTDIR}/_utils.sh"
source "${THIS_SCRIPTDIR}/_formatted_output.sh"

# init / cleanup the formatted output
echo "" > "${formatted_output_file_path}"


#
# Input checking

if [ -z "${APPKEY}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$APPKEY` not provided!'
	exit 1
fi

if [ -z "${APPSECRET}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$APPSECRET` not provided!'
	exit 1
fi

if [ -z "${ACCESS_LEVEL}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$ACCESS_LEVEL` not provided!'
	exit 1
fi

if [ -z "${OAUTH_ACCESS_TOKEN}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$OAUTH_ACCESS_TOKEN` not provided!'
	exit 1
fi

if [ -z "${DIRECTORY_TO_UPLOAD}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$DIRECTORY_TO_UPLOAD` not provided!'
	exit 1
fi

if [ -z "${UPLOAD_PATH}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$UPLOAD_PATH` not provided!'
	exit 1
fi

write_section_to_formatted_output "# Configuration"
echo_string_to_formatted_output "* APPKEY: ${APPKEY}"
echo_string_to_formatted_output "* APPSECRET: ${APPSECRET}"
echo_string_to_formatted_output "* ACCESS_LEVEL: ${ACCESS_LEVEL}"
echo_string_to_formatted_output "* OAUTH_ACCESS_TOKEN: ${OAUTH_ACCESS_TOKEN}"
echo_string_to_formatted_output "* DIRECTORY_TO_UPLOAD: ${DIRECTORY_TO_UPLOAD}"
echo_string_to_formatted_output "* UPLOAD_PATH: ${UPLOAD_PATH}"


#
# Main

files_to_upload=()

# Get files to upload
cd "${DIRECTORY_TO_UPLOAD}"
for file in *
do
	files_to_upload+=($file)
done

write_section_to_formatted_output "# Uploading"

# Iterate through files
# and upload them to Dropbox
for file in "${files_to_upload[@]}"
do
	filename=$(basename "$file")
	echo_string_to_formatted_output "* Uploading ${filename}"

	print_and_do_command_exit_on_error bash ./dropbox_uploader.sh upload "${file}" "${UPLOAD_PATH}/${filename}"
done