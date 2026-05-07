# File: Dockerfile
FROM debian:bookworm-slim

# Install ink and cron, clean up apt cache
RUN apt-get update && \
    apt-get install -y --no-install-recommends ink cron && \
    rm -rf /var/lib/apt/lists/*

# Create the directories we will use as volumes
RUN mkdir -p /printerink /cron

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define the external volumes
VOLUME ["/printerink", "/cron"]

# Set the entrypoint script to run first
ENTRYPOINT ["/entrypoint.sh"]

# Run cron in the foreground as the final process
CMD ["cron", "-f"]