#!/usr/bin/env bash
set -e

if [ -z "${POSTGRES_ADDRESS}" ]; then
  SQL_HOST_FLAGS="--username $POSTGRES_USER --dbname $POSTGRES_DB"
else
  SQL_HOST_FLAGS="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_ADDRESS}/${POSTGRES_DB}"
fi

psql -v ON_ERROR_STOP=1 $SQL_HOST_FLAGS <<-EOSQL
do \$\$
BEGIN
IF NOT EXISTS (
    SELECT FROM pg_catalog.pg_roles
    WHERE  rolname = 'todo_app') THEN

    CREATE USER todo_app WITH PASSWORD '${POSTGRES_APP_PASSWORD}';

    GRANT CONNECT ON DATABASE ${POSTGRES_DB} TO todo_app;

    GRANT USAGE ON SCHEMA public TO todo_app;

    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO todo_app;

    GRANT SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA public TO todo_app;
END IF;
END
\$\$
EOSQL