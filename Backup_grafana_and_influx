

# **Backup Raspberry Pi Data to Google Drive using `rclone`**

This guide provides steps to backup data from a Raspberry Pi to Google Drive using `rclone`.

## **Table of Contents**

1. [Install and Configure `rclone`](#install-and-configure-rclone)
2. [Backup Script](#backup-script)
3. [Automate Backup using Cron](#automate-backup-using-cron)
4. [Issues You Might Encounter](#issues-you-might-encounter)

---

## **1. Install and Configure `rclone`** <a name="install-and-configure-rclone"></a>

### **1.1. Installation**:

```bash
curl -O https://downloads.rclone.org/rclone-current-linux-arm.zip
unzip rclone-current-linux-arm.zip
cd rclone-*-linux-arm
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
```

### **1.2. Create a Google Cloud Project**:

Before using `rclone` with Google Drive:

1. Visit [Google Cloud Console](https://console.cloud.google.com/).
2. Click on the project drop-down and select `New Project`.
3. Name your project (e.g., "Rclone Backup") and click `Create`.
4. Search for "Drive API" in the search bar.
5. Click on `Drive API` from the results.
6. Click `Enable`.

### **1.3. Create Credentials for `rclone`**:

1. In the Google Cloud Console, select your project and go to the `Credentials` tab.
2. Click `Create Credentials` > `OAuth 2.0 Client IDs`.
3. Select `Desktop App` and click `Create`.
4. Click `OK` on the modal.
5. Download the JSON file of the client ID you created.
6. Save this file on your Raspberry Pi, e.g., `/home/pi/credentials.json`.

### **1.4. Configure `rclone` for Google Drive**:

```bash
rclone config
```

Follow the on-screen instructions and provide the path to the credentials file when prompted.

---

## **2. Backup Script** <a name="backup-script"></a>

Here's a sample script to backup Grafana and InfluxDB data:

```bash
#!/bin/bash

# Backup Grafana
rclone copy /etc/grafana gdrive:/RaspberryPiBackups/Grafana/Configs
rclone copy /var/lib/grafana/grafana.db gdrive:/RaspberryPiBackups/Grafana/Database

# Backup InfluxDB
DATE=$(date +"%d-%m-%Y_%H:%M")
LOCAL_BACKUP_DIR="/var/backups/influxBackup/$DATE"
mkdir -p $LOCAL_BACKUP_DIR
influxd backup -portable $LOCAL_BACKUP_DIR
rclone copy $LOCAL_BACKUP_DIR gdrive:/RaspberryPiBackups/InfluxDBBackups/$DATE
rm -rf $LOCAL_BACKUP_DIR
```

---

## **3. Automate Backup using Cron** <a name="automate-backup-using-cron"></a>

To automate the backup process:

1. Open the crontab editor:

```bash
crontab -e
```

2. Add the following line to run the backup script daily at 2 AM:

```bash
0 2 * * * /home/pi/grafana_influx_backup.sh
```

---

## **4. Issues You Might Encounter** <a name="issues-you-might-encounter"></a>

- **Permission Issues**: Ensure the script has the necessary permissions to access and modify the directories.
- **Rclone Configuration**: Ensure you've correctly set up the Google Cloud project and provided the right credentials to `rclone`.
- **Backup Duration**: Compressing the backup and uploading to Google Drive might take time, especially if the data size is large.

---

Copy and paste the above markdown content into your GitHub repository's README or any markdown file, and it should render correctly.
