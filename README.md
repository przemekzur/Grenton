# Grenton

This repository contains various scripts and configurations for the Grenton specific area.

## Grafana and InfluxDB Backup

For a detailed step-by-step guide on how to backup Grafana and InfluxDB, including setting up rclone and handling potential issues, check out [grafana_influx_backup.md](./grafana_influx_backup.md).

This guide covers:

- Setting up rclone for Google Drive.
- Creating a backup script for Grafana and InfluxDB.
- Automating the backup process using cron.
- Addressing common issues and their solutions.

## Grafana and InfluxDB Restore

If you ever need to restore your Grafana and InfluxDB data from the backups, we've got you covered. Check out the comprehensive restoration guide in [grafana_influx_restore.md](./grafana_influx_restore.md).

This guide will walk you through:

- Downloading the backup from Google Drive.
- Restoring Grafana configurations, database, and plugins.
- Decompressing and restoring InfluxDB data.
- Restarting services post-restoration.
- Addressing common restoration issues.

Feel free to explore other things in the repository!
