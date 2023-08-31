#!/bin/bash

# Variables
LOCAL_RESTORE_DIR="/path/to/local/restore/directory"
GRAFANA_CONFIG_DIR="/etc/grafana"
GRAFANA_DATA_DIR="/var/lib/grafana"
INFLUXDB_RESTORE_DIR="/path/to/local/restore/directory/InfluxDBBackups"

# Download the backup from Google Drive
echo "Downloading backup from Google Drive..."
rclone copy gdrive:/RaspberryPiBackups $LOCAL_RESTORE_DIR

# Restore Grafana
echo "Restoring Grafana configurations..."
cp -r $LOCAL_RESTORE_DIR/Grafana/Configs/* $GRAFANA_CONFIG_DIR

echo "Restoring Grafana database..."
cp $LOCAL_RESTORE_DIR/Grafana/Database/grafana.db $GRAFANA_DATA_DIR

echo "Restoring Grafana plugins..."
cp -r $LOCAL_RESTORE_DIR/Grafana/Plugins/* $GRAFANA_DATA_DIR/plugins/

# Decompress and Restore InfluxDB
echo "Decompressing InfluxDB backup..."
cd $INFLUXDB_RESTORE_DIR
tar -xzvf influxdb_backup.tar.gz

echo "Restoring InfluxDB data..."
influxd restore -portable $INFLUXDB_RESTORE_DIR

# Clean up decompressed backup files
echo "Cleaning up decompressed backup files..."
rm -r $INFLUXDB_RESTORE_DIR/*

# Restart services
echo "Restarting Grafana and InfluxDB services..."
sudo systemctl restart grafana-server
sudo systemctl restart influxdb

echo "Restoration process completed. Please verify the data."

