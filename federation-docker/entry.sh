#!/bin/sh

set -e

function main() {
  echo "Starting Federation..."

  PGPASSWORD=password
  while ! psql -h federationpostgres -U federation -c 'select 1' federationdb &> /dev/null
  do
    echo "Waiting for federationdb to be available..."
    sleep 1
  done

  init_federation_db
  start_federation
}

function init_federation_db() {
  if [ -f /opt/federation/.federationdb-initialized ]; then
    echo "federation DB: already initialized"
    return 0
  fi

  # add sample data
  PGPASSWORD=password
  psql -h federationpostgres -U federation federationdb -e <<-EOS
    CREATE TABLE people (id character varying, name character varying, domain character varying);
    INSERT INTO people (id, name, domain) VALUES
      ('GD2GJPL3UOK5LX7TWXOACK2ZPWPFSLBNKL3GTGH6BLBNISK4BGWMFBBG', 'bob', 'stellar.org'),
      ('GCYMGWPZ6NC2U7SO6SMXOP5ZLXOEC5SYPKITDMVEONLCHFSCCQR2J4S3', 'alice', 'stellar.org');
EOS

  touch /opt/federation/.federationdb-initialized
}

function start_federation() {
  build-config /config.toml > /opt/federation/federation.cfg

  /go/bin/federation server -c /opt/federation/federation.cfg
}

main
