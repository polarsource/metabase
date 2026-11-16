FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg tini util-linux \
    && rm -rf /var/lib/apt/lists/*

ARG DATAVINE_VERSION=1.3.3
RUN set -eu; \
    package="datavine-cloud-connector_${DATAVINE_VERSION}_$(dpkg --print-architecture).deb"; \
    url="https://gitlab.com/api/v4/projects/81725141/packages/generic/datavine_cloud_connector/${DATAVINE_VERSION}"; \
    cd /tmp; \
    curl -fLO "$url/$package"; \
    curl -fLO "$url/$package.asc"; \
    curl -fsSL -o signing-key.asc https://app.datavine.com/cloud-connector/signing-key.asc; \
    gpg --import signing-key.asc; \
    gpg --verify "$package.asc" "$package"; \
    dpkg -i "$package"; \
    mv /opt/datavine-cloud-connector /usr/local/share/datavine; \
    rm -f "$package" "$package.asc" signing-key.asc; \
    rm -rf /root/.gnupg

COPY --chmod=755 start.sh /usr/local/bin/start-datavine
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/usr/local/bin/start-datavine"]
