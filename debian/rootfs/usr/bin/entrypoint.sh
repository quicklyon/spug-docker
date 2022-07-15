#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

[ -n "${EASYSOFT_DEBUG:+1}" ] && set -x

# Load libraries
. /opt/easysoft/scripts/liblog.sh
. /opt/easysoft/scripts/libeasysoft.sh
. /opt/easysoft/scripts/libfs.sh


print_welcome_page

# Enable services
make_soft_link "/etc/s6/s6-available/spug-api" "/etc/s6/s6-enable/01-spug-api"
make_soft_link "/etc/s6/s6-available/spug-monitor" "/etc/s6/s6-enable/02-spug-monitor"
make_soft_link "/etc/s6/s6-available/spug-scheduler" "/etc/s6/s6-enable/03-spug-scheduler"
make_soft_link "/etc/s6/s6-available/spug-worker" "/etc/s6/s6-enable/04-spug-worker"
make_soft_link "/etc/s6/s6-available/spug-ws" "/etc/s6/s6-enable/05-spug-ws"
make_soft_link "/etc/s6/s6-available/nginx" "/etc/s6/s6-enable/06-nginx"

if [ $# -gt 0 ]; then
    exec "$@"
else
    # Init service
    /etc/s6/s6-init/run || exit 1

    # Start s6 to manage service
    exec /usr/bin/s6-svscan /etc/s6/s6-enable
fi
