FROM tailscale/tailscale:stable AS tailscale

FROM metabase/metabase-enterprise:v1.63.15.x

COPY --from=tailscale /usr/local/bin/tailscale /usr/local/bin/tailscale
COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/tailscaled
COPY --chmod=755 start.sh /app/start.sh

ENTRYPOINT ["/app/start.sh"]
