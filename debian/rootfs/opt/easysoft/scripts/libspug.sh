#!/bin/bash
#
# Spug app handler library

# shellcheck disable=SC1090,SC1091,SC2034

. /opt/easysoft/scripts/liblog.sh
. /opt/easysoft/scripts/libos.sh

exec_sql() {
    local sql="${1:?sql is missing.}"
    local -a args=("--host=$MYSQL_HOST" "--port=$MYSQL_PORT" "--user=$MYSQL_USER" "--password=$MYSQL_PASSWORD")
    local command="/usr/bin/mysql"

    args+=("--execute=$sql;")
    
    debug_execute "$command" "${args[@]}" || return 1
}