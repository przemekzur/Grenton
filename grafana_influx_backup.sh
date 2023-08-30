#!/bin/bash

# Define backup directories
GRAFANA_DIR="/etc/grafana"
INFLUXDB_DIR="/var/lib/influxdb"
BACKUP_BASE_DIR="/var/backups/influxBackup"
DATE=$(date +"%d-%m-%Y_%H:%M")
LOCAL_BACKUP_DIR="$BACKUP_BASE_DIR/$DATE"
TAR_NAME="influxdb_backup_$DATE.tar.gz"

# Backup Grafana
echo "Starting Grafana backup..."
rclone copy $GRAFANA_DIR gdrive:/RaspberryPiBackups/Grafana/Configs
if [ $? -eq 0 ]; then
    echo "Grafana backup completed successfully."
else
    echo "Error occurred during Grafana backup."
    exit 1
fi

# Backup InfluxDB
echo "Starting InfluxDB backup..."
mkdir -p $LOCAL_BACKUP_DIR
influxd backup -portable $LOCAL_BACKUP_DIR
if [ $? -eq 0 ]; then
    echo "InfluxDB local backup completed successfully."
else
    echo "Error occurred during InfluxDB local backup."
    exit 1
fi

# Compress the backup
echo "Compressing InfluxDB backup..."
tar -czf $BACKUP_BASE_DIR/$TAR_NAME -C $BACKUP_BASE_DIR $DATE
if [ $? -eq 0 ]; then
    echo "InfluxDB backup compressed successfully."
else
    echo "Error occurred during InfluxDB backup compression."
    exit 1
fi

# Upload to Google Drive
echo "Uploading InfluxDB backup to Google Drive..."
rclone copy $BACKUP_BASE_DIR/$TAR_NAME gdrive:/RaspberryPiBackups/InfluxDBBackups/$DATE/
if [ $? -eq 0 ]; then
    echo "InfluxDB backup uploaded to Google Drive successfully."
else
    echo "Error occurred while uploading InfluxDB backup to Google Drive."
    exit 1
fi

# Cleanup local backup
echo "Cleaning up local backup..."
rm -rf $LOCAL_BACKUP_DIR
rm -f $BACKUP_BASE_DIR/$TAR_NAME
if [ $? -eq 0 ]; then
    echo "Local backup cleaned up successfully."
else
    echo "Error occurred during local backup cleanup."
    exit 1
fi

echo "Backup process completed."
