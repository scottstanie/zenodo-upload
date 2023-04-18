#!/bin/bash
# Deletes all files of a Zenodo deposition.
#
# usage: ./zenodo_delete_all.sh deposition-id [--sandbox]
#

set -e
USAGE="$0 deposition-id [--sandbox]"

# Check they have provided a deposition id and a file
if [[ $# -lt 1 ]]; then
    echo "usage: $USAGE"
    exit 1
fi

URL_BASE="www.zenodo"

# Check if the user added --sandbox, if so adjust the url
if [[ $# -gt 1 ]] && [[ $2 == "--sandbox" ]]; then
    URL_BASE="sandbox.zenodo"
fi

DEPOSITION="$1"
echo "https://${URL_BASE}.org/api/deposit/depositions/${DEPOSITION}/files" 
curl -H @<(echo -e "Accept: application/json\nAuthorization: Bearer $ZENODO_TOKEN") "https://${URL_BASE}.org/api/deposit/depositions/${DEPOSITION}/files" | jq --raw-output .[].id > file_ids.txt

cat file_ids.txt | parallel "echo curl -XDELETE -H '@<(echo -e \"Authorization: Bearer $ZENODO_TOKEN\")' \\\"https://${URL_BASE}.org/api/deposit/depositions/$DEPOSITION/files/{1}\\\"" > delete_cmds.sh
