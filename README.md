# Zotero Git Backup (for macOS)

This setup automates Zotero backups using Git and `launchctl` on macOS. GitHub imposes a **5GB** repository soft limit, with a **100MB file size limit** per file. Performance may degrade if more than **1,000 files** are modified in a single commit.

---

## Setup instructions

### 1. Initialize a Git repository in your Zotero directory
Before setting up the backup, ensure Git is tracking changes in your Zotero folder.

```bash
cd ~/Zotero
git init
```

### 2. Clone this repository
Clone the backup script repository to a location of your choice.

```bash
git clone https://github.com/anujgautam/ZoteroBackup.git
cd ZoteroBackup
```

### 3. Copy the backup script into the Zotero directory
Move the backup script to your Zotero directory and make it executable.

```bash
cp backup.sh ~/Zotero/
chmod +x ~/Zotero/backup.sh
```

### 4. Copy and edit the launch agent file
Move the `.plist` file into macOS's `LaunchAgents` directory.

```bash
cp com.user.zoteroBackup.plist ~/Library/LaunchAgents/
```

Edit the `.plist` file to set the correct path for your Zotero directory. Open it with a text editor:

```bash
nano ~/Library/LaunchAgents/com.user.zoteroBackup.plist
```
Find the line with `ProgramArguments` and replace the path with your Zotero directory:

```xml
<key>ProgramArguments</key>
<array>
    <string>/Users/USERNAME/Zotero/backup.sh</string>
</array>
```
Make sure to replace `USERNAME` with your actual username.

### 5. Load the launch agent
Register the backup script with `launchctl` so it runs automatically.

```bash
launchctl load ~/Library/LaunchAgents/com.user.zoteroBackup.plist
```

At this point, your Zotero backup should run every 3 hours automatically.

### 6. Running the backup
If you need to **trigger a backup manually**, use:

```bash
~/Zotero/backup.sh
```

Alternatively, start it via `launchctl`:

```bash
launchctl start com.user.zoteroBackup
```

---

## Stopping and unloading the backup
To **stop the backup process**, run:

```bash
launchctl stop com.user.zoteroBackup
```

To **completely unload and disable the scheduled backup**, use:

```bash
launchctl unload ~/Library/LaunchAgents/com.user.zoteroBackup.plist
```
---
