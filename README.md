# BackupScript

> This script has been re-written in 2022-11

Backup you files and mysql on linux.

# Usage

Create `tar-files` and `tar-exclude` in the same dir of `run-backup.sh`. They defines what files to backup.

Create `secret` in the same dir too. It is written in bash script language and must define a function `put_backup`. It takes two arguments (the tarball and its checksum) and put them to your wanted location. If you want to backup mysql, you should define `MYSQL_USERNAME`, `MYSQL_PASSWORD`, and `MYSQL_HOST` in the file.

Then you can execute the script `bash run-backup.sh`