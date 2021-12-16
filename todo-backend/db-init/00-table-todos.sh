#!/usr/bin/env bash
set -e

if [ -z "${POSTGRES_ADDRESS}" ]; then
  SQL_HOST_FLAGS="--username $POSTGRES_USER --dbname $POSTGRES_DB"
else
  SQL_HOST_FLAGS="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_ADDRESS}/${POSTGRES_DB}"
fi

psql -v ON_ERROR_STOP=1 $SQL_HOST_FLAGS <<-EOSQL
BEGIN;
CREATE TABLE IF NOT EXISTS todos (
  id varchar PRIMARY KEY,
  title varchar,
  completed boolean,
  created date DEFAULT now(),
  updated date DEFAULT now()
);
END;
EOSQL
