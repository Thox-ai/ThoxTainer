# Dockerfile for thoxos-mini-portable
#
# Target: Handheld devices, field kits, battery-powered AI tools.
# Good balance of capability vs size. Often needs real-time sensor I/O.

FROM alpine:3.21 AS base

RUN apk add --no-cache \
    ca-certificates \
    dbus \
    i2c-tools \
    spi-tools \
    can-utils \
    && rm -rf /var/cache/apk/*

RUN adduser -D -u 1000 portable

# COPY --from=builder /out/thox-portable-runtime /usr/local/bin/

COPY entrypoint.sh /usr/local/bin/thox-portable-entrypoint
RUN chmod +x /usr/local/bin/thox-portable-entrypoint

USER portable
WORKDIR /home/portable

ENTRYPOINT ["/usr/local/bin/thox-portable-entrypoint"]
