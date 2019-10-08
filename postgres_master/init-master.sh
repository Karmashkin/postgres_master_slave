#!/bin/bash -ve

REP_USER=$REPLICATION_USER
REP_PASS=$REPLICATION_PASSWORD
REP_PASS_MD5=$(echo -n "${REP_PASS}${REP_USER}" | md5sum | awk '{print $1}')
DB_NAME=$POSTGRES_DB
DB_USER=$POSTGRES_USER
DB_PASS=$POSTGRES_PASS
DB_PASS_MD5=$(echo -n "${DB_PASS}${DB_USER}" | md5sum | awk '{print $1}')

echo "Creating pg_hba.conf..."
sed -e "s/\${REP_USER}/$REP_USER/" \
    -e "s/\${DB_NAME}/$DB_NAME/" \
    -e "s/\${DB_USER}/$DB_USER/" \
    /tmp/postgresql/pg_hba.conf \
    > $PGDATA/pg_hba.conf
echo "Creating pg_hba.conf complete."

echo "Creating postgresql.conf..."
cp /tmp/postgresql/postgresql.conf $PGDATA/postgresql.conf

echo "Creating replication user..."
psql -v ON_ERROR_STOP=1 --username "$DB_USER" --dbname "$DB_NAME" <<-EOSQL
   CREATE ROLE ${REP_USER} PASSWORD 'md5${REP_PASS_MD5}' REPLICATION LOGIN;
EOSQL
echo "Creating replication user complete."

#mkdir /var/lib/postgresql/archive
#chown postgres:postgres /var/lib/postgresql/archive
chown -R postgres:postgres ${PGDATA}
