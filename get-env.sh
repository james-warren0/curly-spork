#!/usr/bin/env bash

RAW_ENV_VARS=$(env | awk -F '=' '{printf "\""; printf $1; printf "\":\""; printf $2; print "\"";}')
printf '{'; echo -n "${RAW_ENV_VARS//$'\n'/,}"; printf '}'

# echo '{"foo": "bar"}'
