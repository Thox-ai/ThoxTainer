# Dockerfile for thoxos-mini-mobile
#
# Target: Ultra-compact ThoxOS for mobile / phone-class devices.
# Use with ThoxOS Mini kernel profile (or a mobile-optimized variant).
#
# This is a starter template. Customize for the actual thoxos-mini-mobile repository
# once it is available.

FROM alpine:3.21 AS base

# Install minimal runtime dependencies for mobile ThoxOS
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    dbus \
    udev \
    wireless-tools \
    wpa_supplicant \
    bluez \
    && rm -rf /var/cache/apk/*

# Create non-root user for the mobile agent runtime
RUN adduser -D -u 1000 thox

# Copy your mobile-specific binaries / agent runtime here
# COPY --from=builder /app/thox-mobile-agent /usr/local/bin/
# COPY --from=builder /app/thox-init /usr/local/bin/

# Mobile-optimized entrypoint (lightweight init + agent supervisor)
COPY entrypoint.sh /usr/local/bin/thox-mobile-entrypoint
RUN chmod +x /usr/local/bin/thox-mobile-entrypoint

USER thox
WORKDIR /home/thox

ENTRYPOINT ["/usr/local/bin/thox-mobile-entrypoint"]
CMD ["--mode", "mobile"]
