#!/bin/bash
SUFFIX=$(date +'-%Y-%m.tar.gz')
tar --exclude-vcs -czvf backup-bw$SUFFIX /home/ubuntu/bitwarden_gcloud/
rclone copy backup-bw$SUFFIX b2:dsingh-bw-backups
rm backup-bw$SUFFIX
