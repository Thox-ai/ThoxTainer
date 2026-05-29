# Dockerfile for thoxos-desktop
#
# Target: Workstations, creative machines, high-end developer devices,
# MagStack nodes, full desktop experience.

FROM alpine:3.21 AS base

RUN apk add --no-cache \
    ca-certificates \
    dbus \
    wayland \
    mesa \
    pulseaudio \
    fontconfig \
    ttf-dejavu \
    && rm -rf /var/cache/apk/*

RUN adduser -D -u 1000 desktop

# COPY --from=builder /out/thox-desktop /usr/local/bin/
# COPY --from=builder /out/windowd /usr/local/bin/
# COPY assets /usr/share/thox/assets

COPY entrypoint.sh /usr/local/bin/thox-desktop-entrypoint
RUN chmod +x /usr/local/bin/thox-desktop-entrypoint

USER desktop
WORKDIR /home/desktop

ENTRYPOINT ["/usr/local/bin/thox-desktop-entrypoint"]
