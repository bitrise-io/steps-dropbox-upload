#!/bin/bash

DIRECTORY_TO_UPLOAD='/Users/birmacher/develop/Bitrise/steps/steps-dropbox-upload/'
UPLOAD_PATH='my/test'

export APPKEY="lygfaeocsdd0tgg"
export APPSECRET="octuy3uuktysk5n"
export ACCESS_LEVEL="dropbox"
export OAUTH_ACCESS_TOKEN="c45uivBkr5UAAAAAAAAJa7aIntJQXjfXodEF8Avb_eDe320DU9QKl5W9xz6_Y9Ll"
# export OAUTH_ACCESS_TOKEN_SECRET="lbczysnqmtjat6v"

files_to_upload=()

# Get files to upload
cd $DIRECTORY_TO_UPLOAD
for file in *
do
	files_to_upload+=($file)
done

# Iterate through files
# and upload them to Dropbox
for file in "${files_to_upload[@]}"
do
	filename=$(basename "$file")
	echo "Uploading $filename"

	./dropbox_uploader.sh upload "$file" "$UPLOAD_PATH/$filename"
done