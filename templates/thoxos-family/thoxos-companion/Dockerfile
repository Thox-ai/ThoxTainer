# Dockerfile for thoxos-companion
#
# Target: Wearables, earbuds, companion modules, always-on sensors.
# Extremely small footprint + aggressive power management.
#
# Pair with a very stripped ThoxOS Air or custom Companion kernel profile.

FROM alpine:3.21 AS base

RUN apk add --no-cache \
    ca-certificates \
    dbus \
    bluez \
    i2c-tools \
    && rm -rf /var/cache/apk/*

RUN adduser -D -u 1000 -s /bin/sh companion

# Copy companion runtime (usually very small Rust or C binary)
# COPY --from=builder /out/thox-companion /usr/local/bin/

COPY entrypoint.sh /usr/local/bin/thox-companion-entrypoint
RUN chmod +x /usr/local/bin/thox-companion-entrypoint

USER companion
WORKDIR /home/companion

ENTRYPOINT ["/usr/local/bin/thox-companion-entrypoint"]
CMD []
