#!/bin/bash

set -e


function do_start {
  : ${CONTAINER_IMAGE?"Need to set CONTAINER_IMAGE"}
  #: ${NETWORK?"Need to set NETWORK"}
  : ${SHIP_NAME?"Need to set SHIP_NAME"}
  : ${API_URL?"Need to set API_URL"}
  docker run --name $SHIP_NAME -e "API_URL=$API_URL" -e "SHIP_NAME=$SHIP_NAME" $CONTAINER_IMAGE > container_id
  CONTAINER_ID=`cat container_id`
  docker inspect -f "{{ .Node.Addr }}" $CONTAINER_ID > node_addr
  NODE_ADDR=`car node_addr`
  echo "{\"id\": \"$CONTAINER_ID\", \"addr\": \"$NODE_ADDR\"}"
}
function do_stop {
  : ${CONTAINER_ID?"Need to set CONTAINER_ID"}
  docker rm -f $CONTAINER_ID
}

function do_move {
  # TODO verify current network is not desired network?
  #: ${NETWORK?"Need to set NETWORK"}
  do_stop
  do_start
}

case $1 in
    start) do_start ;;
    move) do_move ;;
    stop) do_stop ;;
    \?) echo "usage: $0 start|stop|move"; exit 1;;
esac
