#!/bin/bash
set -e

test -n "$1" || ( echo "no directory specified"; exit 1)
test "$(realpath $1)" != "/" || ( echo "should not work on root /"; exit 1)
test -d $1 || ( echo "directory does not exist"; exit 1)
folder="$1"
cd $folder
for i in $( ls $folder | grep -v sha256 | sed 's/-backup-.*$//g' | uniq ); do
    for j in $(ls -t $folder/$i* | grep -v sha256 | tail +8); do
        if [[ $(realpath $j) == $folder* ]]; then
            echo rm $j*
        else
            echo "Internal Error"
            exit 1
        fi
    done
done

