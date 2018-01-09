#!/usr/bin/env sh

set -e

function main() {
  while ! psql -h federationpostgres -U federation -c 'select 1' federationdb &> /dev/null ; do
    echo "Waiting for bifrostdb to be available..."
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

	touch /opt/federation/.federationdb-initialized
 }

function start_federation() {
  build-config /config.toml > /opt/federation/federation.cfg

  /go/bin/federation server -c /opt/federation/federation.cfg
}

main
