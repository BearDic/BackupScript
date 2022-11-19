#!/bin/bash

# This script requires three files in the same dir:
# - secret:
#     mysql secret
#     a function named put_backup who puts $1 and $2 to the wanted place
# - tar-files and tar-exclude: files that will be packed into tarball

set -e

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]:-${(%):-%x}}" )" && pwd )
source "$THIS_DIR/secret"

TARGET_DIR="/tmp/backup/$(hostname)-backup-$(date +%Y%m%d-%H%M)"
TARGET_TARBALL="$TARGET_DIR.tar.xz"
TARGET_TARBALL_SHA256="$TARGET_TARBALL.sha256"
cleanup()
{
    echo "exit. cleaning tmp files ..."
    rm -rf "$TARGET_DIR" "$TARGET_TARBALL" "$TARGET_TARBALL_SHA256"
}
trap cleanup EXIT

if [[ -d "$TARGET_DIR" ]]; then
    echo "the target directory $TARGEN_DIR already exists. check if there's some errors"
    exit 1
fi
mkdir -p "$TARGET_DIR"

# tar
if [[ -s "$THIS_DIR/tar-files" ]]; then
    tar -cpf "$TARGET_DIR/rootfs.tar" -X "$THIS_DIR/tar-exclude" -T "$THIS_DIR/tar-files"
fi

# mysql
if [[ -x $(command -v mysqldump) ]]; then
    mysqldump -u"$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" -h"$MYSQL_HOST" -A > "${TARGET_DIR}/mysql.sql"
fi

# pack
cd "$TARGET_DIR/.."
tar -cJpf "$TARGET_TARBALL" --remove-files $(basename "$TARGET_DIR")
sha256sum $(basename "$TARGET_TARBALL") > "$TARGET_TARBALL_SHA256"

# put
put_backup "$TARGET_TARBALL" "$TARGET_TARBALL_SHA256"