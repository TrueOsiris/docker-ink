# docker-ink
microscopic container to run a cron with the ink command. To check for old printers ink levels.

``` bash
# File: docker-compose.yml
services:
  ink-monitor:
    image: ghcr.io/trueosiris/ink:latest
    container_name: ink-monitor
    restart: unless-stopped
    environment:
      # Inject your printer IP here. You can change this anytime.
      - PRINTER_IP=10.10.1.21
      # Optional: You can also override the default schedule (e.g., every 30 mins)
      # - CRON_SCHEDULE=*/30 * * * *
    volumes:
      # Output file directory
      - ./printerink_data:/printerink
      # Cron configuration directory 
      - ./cron_data:/cron
```