#!/bin/sh
set -eu

: "${TS_AUTHKEY:?TS_AUTHKEY is required}"

env -u TS_AUTHKEY tailscaled \
  --socket=/tmp/tailscaled.sock \
  --state=/var/lib/tailscale/tailscaled.state \
  --tun=userspace-networking &

tailscale --socket=/tmp/tailscaled.sock up \
  --accept-dns=false \
  --advertise-tags=tag:metabase \
  --auth-key="$TS_AUTHKEY" \
  --hostname="${TS_HOSTNAME:-metabase}"
unset TS_AUTHKEY

tailscale --socket=/tmp/tailscaled.sock serve \
  --bg \
  --https=443 \
  --yes \
  http://127.0.0.1:3000

exec /app/run_metabase.sh
