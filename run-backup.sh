SCRIPT_PATH=$(readlink -f "$0")
DIR=$(dirname $SCRIPT_PATH)

source $DIR/.conf

DATE=$(date +%Y%m%d)
EXCLUDE_CMD=("")
for i in $EXCLUDE_FILES
do
    EXCLUDE_CMD+=("--exclude=${i}")
done
FILE_NAME=${SAVE_DIR}/${DATE}.tar.bz2

mkdir -p $SAVE_DIR
echo '' && date &&echo "[$(date +%T)] - [Deleting old backup...]"
find $SAVE_DIR -mtime +$EXPIRE_DAYS -name "*.*" -exec rm -rf {} \;
echo "[$(date +%T)] - [Making directory...]"
mkdir -p ${SAVE_DIR}/${DATE}/
echo "[$(date +%T)] - [Preparing backup...]"
mysqldump -u${MYSQL_USERNAME} -p${MYSQL_PASSWORD} -A > ${SAVE_DIR}/${DATE}/mysql.sql
tar -cpf ${SAVE_DIR}/${DATE}/files.tar ${BACKUP_FILES} ${EXCLUDE_CMD}
tar -cjpf $FILE_NAME ${SAVE_DIR}/${DATE} --remove-files

if [ ! -z "$UPLOAD_CMD" ]
then
    if [[ $SHELL == *zsh ]]
    then
        ${=UPLOAD_CMD/"{filename}"/$FILE_NAME}
    else
        ${UPLOAD_CMD/"{filename}"/$FILE_NAME}
    fi
fi

echo "[$(date +%T)] - [Job done!]"
