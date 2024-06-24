#!/bin/bash

# Define backup directories
GRAFANA_CONFIG_DIR="/etc/grafana"
GRAFANA_DATA_DIR="/var/lib/grafana"
INFLUXDB_DIR="/var/lib/influxdb"
BACKUP_BASE_DIR="/var/backups/influxBackup"
DATE=$(date +"%d-%m-%Y_%H:%M")
LOCAL_BACKUP_DIR="$BACKUP_BASE_DIR/$DATE"
TAR_NAME="influxdb_backup_$DATE.tar.gz"


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


# Backup Grafana (configs, data, and plugins)
echo "Starting Grafana backup..."
GRAFANA_BACKUP_DIR="$BACKUP_BASE_DIR/grafana_$DATE"
mkdir -p $GRAFANA_BACKUP_DIR
cp -r $GRAFANA_CONFIG_DIR $GRAFANA_BACKUP_DIR/config
cp -r $GRAFANA_DATA_DIR $GRAFANA_BACKUP_DIR/data
if [ $? -eq 0 ]; then
    echo "Grafana local backup completed successfully."
else
    echo "Error occurred during Grafana local backup."
    exit 1
fi

# Compress the Grafana backup
echo "Compressing Grafana backup..."
GRAFANA_TAR_NAME="grafana_backup_$DATE.tar.gz"
tar -czf $BACKUP_BASE_DIR/$GRAFANA_TAR_NAME -C $BACKUP_BASE_DIR grafana_$DATE
if [ $? -eq 0 ]; then
    echo "Grafana backup compressed successfully."
else
    echo "Error occurred during Grafana backup compression."
    exit 1
fi

# Upload Grafana backup to Google Drive
echo "Uploading Grafana backup to Google Drive..."
rclone copy $BACKUP_BASE_DIR/$GRAFANA_TAR_NAME gdrive:/RaspberryPiBackups/Grafana/$DATE/
if [ $? -eq 0 ]; then
    echo "Grafana backup uploaded to Google Drive successfully."
else
    echo "Error occurred while uploading Grafana backup to Google Drive."
    exit 1
fi

# Cleanup local Grafana backup
echo "Cleaning up local Grafana backup..."
rm -rf $GRAFANA_BACKUP_DIR
rm -f $BACKUP_BASE_DIR/$GRAFANA_TAR_NAME
if [ $? -eq 0 ]; then
    echo "Local Grafana backup cleaned up successfully."
else
    echo "Error occurred during local Grafana backup cleanup."
    exit 1
fi

echo "Backup process completed."
