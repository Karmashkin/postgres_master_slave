#!/bin/bash -ve

rm -rf ${TMPDATA}/*
echo -e "${REPLICATION_PASSWORD}\n" | pg_basebackup -h ${MASTER_HOST} -D ${TMPDATA} -U ${REPLICATION_USER} -W -vP
cd /backup
#find . -mtime +60 -type f -print0 | xargs -r0 rm --
tar -zcvf "$(date '+%Y-%m-%d').tar.gz" ${TMPDATA}
rm -rf ${TMPDATA}/*
