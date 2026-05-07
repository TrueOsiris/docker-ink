#!/bin/sh
# File: entrypoint.sh
set -e

# Define variables with default fallbacks
CRON_FILE="/cron/ink.conf"
# If PRINTER_IP is not passed as an env variable, default to 10.10.1.21
PRINTER_IP=${PRINTER_IP:-"10.10.1.21"}
CRON_SCHEDULE=${CRON_SCHEDULE:-"0 * * * *"}

# 1. Create the cron file in the external volume if it doesn't exist
if [ ! -f "$CRON_FILE" ]; then
    echo "Cron config not found. Creating default for printer IP: $PRINTER_IP"
    
    # Write the cron job with the dynamically injected IP
    echo "$CRON_SCHEDULE root ink -b bjnp://$PRINTER_IP > /printerink/ink_levels.txt 2>&1" > "$CRON_FILE"
    
    # Cron requires an empty line at the end of the file
    echo "" >> "$CRON_FILE"
else
    echo "Existing cron config found at $CRON_FILE"
fi

# 2. Copy to the system cron directory and enforce strict permissions
# Cron will silently ignore files if permissions are too open or owned by non-root
cp "$CRON_FILE" /etc/cron.d/ink-monitor
chmod 0644 /etc/cron.d/ink-monitor
chown root:root /etc/cron.d/ink-monitor

# 3. Execute the CMD passed from the Dockerfile (which is 'cron -f')
exec "$@"