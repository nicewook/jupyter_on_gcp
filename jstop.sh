#!/usr/bin/env bash
# stop all running jupyter notebook server

# 1. get all jupyter server port list as string
JPORTS_STRING=$(jupyter notebook list --json | jq -r '.port')

# 2. split to array
JPORTS=($JPORTS_STRING)

# 3. stop loop
for JPORT in "${JPORTS[@]}"
do
        jupyter notebook stop "${JPORT}"
done