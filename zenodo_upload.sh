#!/bin/bash
# Upload big files to Zenodo.
#
# usage: ./zenodo_upload.sh deposition-id filename [--sandbox]
#

set -e

USAGE="$0 deposition-id filename [--sandbox]"

# Check they have provided a deposition id and a file
if [[ $# -lt 2 ]]; then
    echo "usage: $USAGE"
    exit 1
fi

URL_BASE="www.zenodo"

# Check if the user added --sandbox, if so adjust the url
if [[ $# -gt 2 ]] && [[ $3 == "--sandbox" ]]; then
    URL_BASE="sandbox.zenodo"
fi

DEPOSITION="$1"
FILEPATH="$2"
FILENAME=$(echo $FILEPATH | sed 's+.*/++g')

DEPO_URL="https://$URL_BASE.org/api/deposit/depositions/$DEPOSITION"
echo "Uploading $FILEPATH to $DEPO_URL"
BUCKET=$(curl $DEPO_URL?access_token="$ZENODO_TOKEN" | jq --raw-output .links.bucket)

curl --progress-bar -o /dev/null --upload-file "$FILEPATH" $BUCKET/"$FILENAME"?access_token="$ZENODO_TOKEN"
