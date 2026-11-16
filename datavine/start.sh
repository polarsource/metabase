#!/bin/sh
set -eu

mkdir -p /opt/datavine-cloud-connector
cd /opt/datavine-cloud-connector
if [ "$(id -u)" = 0 ]; then
    # The disk hides image files; refresh packaged files but keep certificates and OTA updates.
    cp /usr/local/share/datavine/agent_client_v0 /usr/local/share/datavine/agent_wrapper /usr/local/share/datavine/root.crt .
    chown datavine-cloud-connector:datavine-cloud-connector . agent_client_v0 agent_wrapper root.crt
    exec setpriv --reuid=datavine-cloud-connector --regid=datavine-cloud-connector --init-groups --no-new-privs "$0"
fi

umask 077
trap 'exit 0' TERM INT

if [ ! -s client.crt ]; then
    ./agent_client_v0 register || true
    if [ ! -s client.crt ]; then
        echo 'Datavine registration did not complete.' >&2
        exit 1
    fi
fi

# Datavine exits after self-updates, including with a successful exit status.
while true; do
    ./agent_wrapper &
    wait "$!" || true
    sleep 5 &
    wait "$!" || true
done
