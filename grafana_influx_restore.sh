#!/bin/bash

# Define restore directories
GRAFANA_CONFIG_DIR="/etc/grafana"
GRAFANA_DATA_DIR="/var/lib/grafana"
INFLUXDB_DIR="/var/lib/influxdb"
RESTORE_BASE_DIR="/var/backups/influxRestore"
DATE_TO_RESTORE=$1  # Pass the date to restore as an argument

if [ -z "$DATE_TO_RESTORE" ]; then
    echo "Usage: $0 <date_to_restore>"
    exit 1
fi

LOCAL_RESTORE_DIR="$RESTORE_BASE_DIR/$DATE_TO_RESTORE"
TAR_NAME="influxdb_backup_$DATE_TO_RESTORE.tar.gz"
GRAFANA_TAR_NAME="grafana_backup_$DATE_TO_RESTORE.tar.gz"

# Create restore directory
mkdir -p $LOCAL_RESTORE_DIR

# Download InfluxDB backup from Google Drive
echo "Downloading InfluxDB backup from Google Drive..."
rclone copy gdrive:/RaspberryPiBackups/InfluxDBBackups/$DATE_TO_RESTORE/$TAR_NAME $LOCAL_RESTORE_DIR
if [ $? -eq 0 ]; then
    echo "InfluxDB backup downloaded successfully."
else
    echo "Error occurred while downloading InfluxDB backup from Google Drive."
    exit 1
fi

# Extract InfluxDB backup
echo "Extracting InfluxDB backup..."
tar -xzf $LOCAL_RESTORE_DIR/$TAR_NAME -C $LOCAL_RESTORE_DIR
if [ $? -eq 0 ]; then
    echo "InfluxDB backup extracted successfully."
else
    echo "Error occurred during InfluxDB backup extraction."
    exit 1
fi

# Restore InfluxDB
echo "Restoring InfluxDB..."
influxd restore -portable -db <your_database_name> $LOCAL_RESTORE_DIR
if [ $? -eq 0 ]; then
    echo "InfluxDB restored successfully."
else
    echo "Error occurred during InfluxDB restore."
    exit 1
fi

# Download Grafana backup from Google Drive
echo "Downloading Grafana backup from Google Drive..."
rclone copy gdrive:/RaspberryPiBackups/Grafana/$DATE_TO_RESTORE/$GRAFANA_TAR_NAME $LOCAL_RESTORE_DIR
if [ $? -eq 0 ]; then
    echo "Grafana backup downloaded successfully."
else
    echo "Error occurred while downloading Grafana backup from Google Drive."
    exit 1
fi

# Extract Grafana backup
echo "Extracting Grafana backup..."
tar -xzf $LOCAL_RESTORE_DIR/$GRAFANA_TAR_NAME -C $LOCAL_RESTORE_DIR
if [ $? -eq 0 ]; then
    echo "Grafana backup extracted successfully."
else
    echo "Error occurred during Grafana backup extraction."
    exit 1
fi

# Restore Grafana configs and data
echo "Restoring Grafana configs and data..."
cp -r $LOCAL_RESTORE_DIR/grafana_$DATE_TO_RESTORE/config/* $GRAFANA_CONFIG_DIR/
cp -r $LOCAL_RESTORE_DIR/grafana_$DATE_TO_RESTORE/data/* $GRAFANA_DATA_DIR/
if [ $? -eq 0 ]; then
    echo "Grafana restored successfully."
else
    echo "Error occurred during Grafana restore."
    exit 1
fi

# Cleanup local restore files
echo "Cleaning up local restore files..."
rm -rf $LOCAL_RESTORE_DIR
if [ $? -eq 0 ]; then
    echo "Local restore files cleaned up successfully."
else
    echo "Error occurred during local restore files cleanup."
    exit 1
fi

echo "Restore process completed."
