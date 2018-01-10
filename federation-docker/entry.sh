#!/bin/sh

set -e

function main() {
  echo "Starting Federation..."

  build-config /configs/config.toml > /opt/federation/federation.cfg

  build-config /configs/pgpass-config > /root/.pgpass
  chmod 600 /root/.pgpass

  while ! psql -h federationpostgres -U stellar -c 'select 1' federationdb &> /dev/null
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
  psql -h federationpostgres -U stellar federationdb -e <<-EOS
    CREATE TABLE people (id character varying, name character varying, domain character varying);
    INSERT INTO people (id, name, domain) VALUES
      ('GCYQSB3UQDSISB5LKAL2OEVLAYJNIR7LFVYDNKRMLWQKDCBX4PU3Z6JP', 'steve', 'stellarkit.io')
 EOS

  touch /opt/federation/.federationdb-initialized
}

function start_federation() {
  /go/bin/federation server --conf /opt/federation/federation.cfg
}

main
