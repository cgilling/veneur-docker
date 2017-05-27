#! /bin/sh

set -ex

export STATS_ADDRESS=${STATS_ADDRESS:-"0.0.0.0:8125"}
export UDP_ADDRESS=${UDP_ADDRESS:-"0.0.0.0:8126"}
export HTTP_ADDRESS=${HTTP_ADDRESS:-"0.0.0.0:8127"}
export FORWARD_ADDRESS=${FORWARD_ADDRESS:-""}

/usr/bin/confd -onetime -backend env

exec /build/veneur -f config.yaml
