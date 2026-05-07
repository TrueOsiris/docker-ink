# docker-ink
microscopic container to run a cron with the ink command. To check for old printers ink levels.

``` yaml
  ink:
    image: ghcr.io/trueosiris/ink:latest
    restart: unless-stopped
    environment:
      - PRINTER_IP=10.10.1.21
    volumes:
      - ./ink/printerink_data:/printerink
      - ./ink/cron_data:/cron
    logging:
      driver: "json-file"
      options:
        max-size: "1m"
        max-file: "1"     
    healthcheck:
      # Tests if the entrypoint successfully generated and placed the cron file
      test: ["CMD", "test", "-f", "/etc/cron.d/ink-monitor"]
      interval: 1m
      timeout: 10s
      retries: 3
      start_period: 10s        
```