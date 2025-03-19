#!/bin/sh

cd "$(dirname "$0")"
echo "EXECUTING BACKUP OF $(pwd)"

DoBackupFlag=true

# Check if there are any changes to commit
if git diff-index --quiet HEAD --; then
    DoBackupFlag=false
fi

if $DoBackupFlag; then
    rm -f zotero.sqlite.part*
    split -b 25M zotero.sqlite "zotero.sqlite.part"

    git add .

    ChangedDocuments=$(git status --porcelain | awk '
        /^ M / {print "(mod) " substr($0,4)}
        /^\?\?/ {print "(new) " substr($0,4)}
        /^ R / {print "(ren) " substr($0,4)}
        /^ D / {print "(del) " substr($0,4)}
    ')

    if [ -n "$ChangedDocuments" ]; then
        git commit -m "Daily backup" -m "$ChangedDocuments"
    else
        git commit -m "Daily backup"
    fi

    git push origin main
else
    echo " -> Nothing to backup (no changes since last backup)"
fi

$SHELL