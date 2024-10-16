#!/bin/bash
#
# Easysoft mysql server handler library

# shellcheck disable=SC1090,SC1091

# Load generic libraries
. /opt/easysoft/scripts/liblog.sh
. /opt/easysoft/scripts/libos.sh

########################
# Check and waiting service to be ready. 
# Globals:
#   MAXWAIT
# Arguments:
#   $1 - Service name
#   $2 - Service host
#   $3 - Service port
#   S4 - Prefix information
# Returns:
#   0 if the service is can be connected, 1 otherwise
#########################
wait_for_service() {
    local retries=${MAXWAIT:-5}
    local service_name="${1^}"
    local svc_host="${2:-localhost}"
    local svc_port="${3:-80}"
    local prefix_info=${4^}

    info "Check whether the $service_name is available."

    for ((i = 0; i <= retries; i += 1)); do
        # 重试5次，每次间隔2的i次方秒
        secs=$((2 ** i))
        sleep $secs
        if nc -z "${svc_host}" "${svc_port}" > /dev/null 2>&1;
        then
            info "$prefix_info: $service_name is ready."
            break
        fi

        warn "$prefix_info: Waiting $service_name $secs seconds"

        if [ "$i" == "$retries" ]; then
            error "$prefix_info Maximum number of retries reached!"
            error "$prefix_info Unable to connect to $service_name: $svc_host:$svc_port"
            return 1
        fi
    done
    return 0
}

########################
# Initialize app database.
# Globals:
#   MYSQL_HOST
#   MYSQL_PORT
#   MYSQL_USER
#   MYSQL_PASSWORD
#   MYSQL_DB
# Arguments:
#   $1 - mysql service host
#   $2 - mysql service port
#   $3 - app database name
# Returns:
#   0 if the database create succeed,1 otherwise
#########################
mysql_init_db() {
    local init_db=${1:-MYSQL_DB}
    local -a args=("--host=$MYSQL_HOST" "--port=$MYSQL_PORT" "--user=$MYSQL_USER" "--password=$MYSQL_PASSWORD")
    local command="/usr/bin/mysql"

    args+=("--execute=CREATE DATABASE IF NOT EXISTS $init_db;")
    
    info "Check $EASYSOFT_APP_NAME database."
    debug_execute "$command" "${args[@]}" || return 1
}

########################
# Import to mysql from mysql dump file
# Globals:
#   MYSQL_HOST
#   MYSQL_PORT
#   MYSQL_USER
#   MYSQL_PASSWORD
#   MYSQL_DB
# Arguments:
#   $1 - app database name
#   $2 - mysql dump file(*.sql) 
# Returns:
#   0 if import succeed,1 otherwise
#########################
mysql_import_to_db() {
    local db_name=${1:?missing db name}
    local sql_file=${2:?missing db init file}
    local -a args=("--host=$MYSQL_HOST" "--port=$MYSQL_PORT" "--user=$MYSQL_USER" "--password=$MYSQL_PASSWORD" "$db_name")
    local command="/usr/bin/mysql"

    if [ -f "$sql_file" ] ;then
        info "Import $sql_file to ${db_name}."
        debug_execute "$command" "${args[@]}" < "$sql_file" || return 1
    else
        error "The specified import file: $sql_file does not exist"
        return 1
    fi 

}