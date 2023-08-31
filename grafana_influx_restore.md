## Restoring Grafana and InfluxDB Data from Backup

### Prerequisites:

- Ensure you have `rclone` installed and configured with Google Drive.
- Ensure you have access to your backup location on Google Drive.
- Ensure `influxd` (InfluxDB's command-line interface) is installed on your system.

### Steps:

1. **Download the Backup from Google Drive**:
   
   Navigate to the directory where you want to download the backup.
   
   ```bash
   rclone copy gdrive:/RaspberryPiBackups /path/to/local/restore/directory
   ```

   Replace `/path/to/local/restore/directory` with your desired local directory path.

2. **Restoring Grafana**:

   - **Configurations**:
   
     Copy the Grafana configurations back to the Grafana directory.
     
     ```bash
     cp -r /path/to/local/restore/directory/Grafana/Configs/* /etc/grafana/
     ```

   - **Database**:
   
     Copy the Grafana database back to the Grafana data directory.
     
     ```bash
     cp /path/to/local/restore/directory/Grafana/Database/grafana.db /var/lib/grafana/
     ```

   - **Plugins**:
   
     Copy the Grafana plugins back to the Grafana plugins directory.
     
     ```bash
     cp -r /path/to/local/restore/directory/Grafana/Plugins/* /var/lib/grafana/plugins/
     ```

3. **Restoring InfluxDB**:
   -  **Decompress the Backup**:
      Before restoring, you'll need to decompress the InfluxDB backup. Navigate to the directory where you downloaded the backup and decompress the `.tar.gz` file.

       ```bash
       cd /path/to/local/restore/directory/InfluxDBBackups
       tar -xzvf influxdb_backup.tar.gz
       ```

      This will extract the backup files to the current directory.

   - **Use the `influxd restore` Command**:

      Now, with the decompressed backup files, use the `influxd restore` command to restore the data. For a portable backup, the command would look like:

       ```bash
       influxd restore -portable /path/to/local/restore/directory/InfluxDBBackups
       ```

   - **Clean Up**:

       After successfully restoring the backup, you can optionally delete the decompressed backup files to free up space.
    
       ```bash
       rm -r /path/to/local/restore/directory/InfluxDBBackups/*
       ```

4. **Restart Services**:

   After restoring the backups, you'll need to restart the Grafana and InfluxDB services to ensure they pick up the restored data.

   ```bash
   sudo systemctl restart grafana-server
   sudo systemctl restart influxdb
   ```

5. **Verification**:

   - **Grafana**: Access the Grafana web interface and verify that your dashboards, data sources, and other configurations are restored.
   
   - **InfluxDB**: Use the `influx` CLI to query your databases and ensure that your data is present.

### Issues You May Encounter Along the Way:

1. **Permission Issues**: If you encounter permission issues during the restore process, you might need to adjust the ownership or permissions of the restored files. For instance, InfluxDB typically runs as the `influxdb` user, so you might need to ensure that the restored files are owned by this user.

2. **Version Mismatch**: Ensure that the version of Grafana and InfluxDB you're restoring to is the same as the version from which you took the backup. Restoring to a different version might cause issues.

3. **Existing Data**: If you're restoring to a directory that already has data, ensure you backup or move the existing data first to avoid any conflicts.

4. **Rclone Configuration**: Ensure that `rclone` is correctly configured to access Google Drive. If you encounter issues, re-run the `rclone config` command to verify your settings.

5. **Network Issues**: If you're downloading large backups, ensure you have a stable internet connection. Interruptions can cause the download to fail.

Remember, always test your restore process in a safe environment before applying it to your production system. This ensures that you're familiar with the process and can address any issues that arise without affecting your live data.
