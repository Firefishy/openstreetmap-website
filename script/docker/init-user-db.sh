#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER openstreetmap;
    CREATE DATABASE openstreetmap;
    GRANT ALL PRIVILEGES ON DATABASE openstreetmap TO openstreetmap;
EOSQL
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" openstreetmap <<-EOSQL
    CREATE EXTENSION btree_gist;
    CREATE OR REPLACE FUNCTION maptile_for_point(int8, int8, int4) RETURNS int4 AS '/app/db/functions/libpgosm.so', 'maptile_for_point' LANGUAGE C STRICT;
    CREATE OR REPLACE FUNCTION tile_for_point(int4, int4) RETURNS int8 AS '/app/db/functions/libpgosm.so', 'tile_for_point' LANGUAGE C STRICT;
    CREATE OR REPLACE FUNCTION xid_to_int4(xid) RETURNS int4 AS '/app/db/functions/libpgosm.so', 'xid_to_int4' LANGUAGE C STRICT;
EOSQL
