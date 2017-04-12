#!/bin/sh
_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$child" 2> /dev/null
}

trap _term SIGHUP SIGINT SIGTERM

nutcracker -c /etc/twemproxy/conf.yml &
child=$!

wait "$child"
