#!/bin/bash -ve

DB_NAME=$POSTGRES_DB
REP_USER=$REPLICATION_USER
REP_PASS=$REPLICATION_PASSWORD
DB_USER=$POSTGRES_USER
DB_PASS=$POSTGRES_PASS

echo "Cleaning up old cluster directory"
rm -rf ${PGDATA}/*

echo "Starting base backup as replicator"
echo -e "${REP_PASS}\n" | pg_basebackup -h ${MASTER_HOST} -D ${PGDATA} -U ${REP_USER} -W -vP

echo "Creating pg_hba.conf..."
sed -e "s/\${REP_USER}/$REP_USER/" \
    -e "s/\${DB_NAME}/$DB_NAME/" \
    -e "s/\${DB_USER}/$DB_USER/" \
    /tmp/postgresql/pg_hba.conf \
    > $PGDATA/pg_hba.conf
echo "Creating pg_hba.conf complete."

echo "Creating postgresql.conf..."
cp /tmp/postgresql/postgresql.conf $PGDATA/postgresql.conf

echo "Writing recovery.conf file"
cat > ${PGDATA}/recovery.conf <<EOS
standby_mode = 'on'
primary_conninfo = 'host=${MASTER_HOST} port=5432 user=${REP_USER} password=${REP_PASS}'
EOS

#mkdir /var/lib/postgresql/archive
#chown postgres:postgres /var/lib/postgresql/archive
chown -R postgres:postgres ${PGDATA}

