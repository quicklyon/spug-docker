#!/bin/bash
#
# Spug app handler library

# shellcheck disable=SC1090,SC1091,SC2034

. /opt/easysoft/scripts/liblog.sh
. /opt/easysoft/scripts/libos.sh

########################
# Prepare and execute a SQL statement
# Globals:
#   MYSQL_HOST
#   MYSQL_PORT
#   MYSQL_USER
#   MYSQL_PASSWORD
# Arguments:
#   $1 - SQL statement
# Returns:
#   0 if execute succeed,1 otherwise
#########################
exec_sql() {
    local sql="${1:?sql is missing.}"
    local -a args=("--host=$MYSQL_HOST" "--port=$MYSQL_PORT" "--user=$MYSQL_USER" "--password=$MYSQL_PASSWORD")
    local command="/usr/bin/mysql"

    args+=("--execute=$sql;")
    
    debug_execute "$command" "${args[@]}" || return 1
}


########################
# Check whether the image code is the same as the installed one
# Globals:
#   APP_VER
# Arguments:
#   None
# Returns:
#   1 : No new version
#   0 : There is a new version
#########################
is_updated() {

    if [ -e /data/.inited ];then
        installed_ver=$(cat /data/.inited)
        if [ "$installed_ver" == "$APP_VER" ];then
            return 1
        else
            return 0
        fi
    else
        return 0
    fi
}

########################
# Get image code version
# Globals:
#   None
# Arguments:
#   $1 - api settings.py location
# Returns:
#   string: version
#########################
get_code_version(){
    local setting_file=${1:-/apps/spug/api/spug/settings.py}
    version="$(grep SPUG_VERSION "$setting_file" | cut -d = -f 2 | sed "s/[',v, ]//g")"
    echo "$version"
}