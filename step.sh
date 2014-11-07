#!/bin/bash

THIS_SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${THIS_SCRIPTDIR}/_utils.sh"
source "${THIS_SCRIPTDIR}/_formatted_output.sh"

# init / cleanup the formatted output
echo "" > "${formatted_output_file_path}"

function CLEANUP_ON_ERROR_FN {
	write_section_to_formatted_output "# Error"
	echo_string_to_formatted_output "See the logs for more details"
}

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

if [ -z "${OAUTH_ACCESS_TOKEN_SECRET}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$OAUTH_ACCESS_TOKEN_SECRET` not provided!'
	exit 1
fi

if [ -z "${PATH_TO_UPLOAD}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$PATH_TO_UPLOAD` not provided!'
	exit 1
fi

if [ -z "${UPLOAD_PATH_ON_DROPBOX}" ] ; then
	write_section_to_formatted_output "# Error"
	write_section_start_to_formatted_output '* Required input `$UPLOAD_PATH_ON_DROPBOX` not provided!'
	exit 1
fi

write_section_to_formatted_output "# Configuration"
echo_string_to_formatted_output "* APPKEY: ${APPKEY}"
echo_string_to_formatted_output "* APPSECRET: ${APPSECRET}"
echo_string_to_formatted_output "* ACCESS_LEVEL: ${ACCESS_LEVEL}"
echo_string_to_formatted_output "* OAUTH_ACCESS_TOKEN: ${OAUTH_ACCESS_TOKEN}"
echo_string_to_formatted_output "* OAUTH_ACCESS_TOKEN_SECRET: ${OAUTH_ACCESS_TOKEN_SECRET}"
echo_string_to_formatted_output "* PATH_TO_UPLOAD: ${PATH_TO_UPLOAD}"
echo_string_to_formatted_output "* UPLOAD_PATH_ON_DROPBOX: ${UPLOAD_PATH_ON_DROPBOX}"


#
# Main

dropbox_config_file_content="APPKEY=${APPKEY}
APPSECRET=${APPSECRET}
ACCESS_LEVEL=${ACCESS_LEVEL}
OAUTH_ACCESS_TOKEN=${OAUTH_ACCESS_TOKEN}
OAUTH_ACCESS_TOKEN_SECRET=${OAUTH_ACCESS_TOKEN_SECRET}"

echo "${dropbox_config_file_content}" > ./dropbox_config
if [ $? -ne 0 ] ; then
	echo "[!] Failed to write the required config file"
	CLEANUP_ON_ERROR_FN
	exit 1
fi

write_section_to_formatted_output "# Uploading"

print_and_do_command_exit_on_error bash dropbox_uploader.sh -f ./dropbox_config upload "${PATH_TO_UPLOAD}" "${UPLOAD_PATH_ON_DROPBOX}"

write_section_to_formatted_output "# Success"
echo_string_to_formatted_output "Target was successfully uploaded"

exit 0
