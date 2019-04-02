#!/bin/bash

if [ -n "${RPC_PASSWORD}" ]; then
  echo ${RPC_PASSWORD} > /boinc/gui_rpc_auth.cfg
fi

if [ -n "${REMOTE_HOST}" ]; then
  echo ${REMOTE_HOST} >  /boinc/remote_hosts.cfg
fi

exec /usr/local/bin/boinc --attach_project ${PROJECT_URL} ${TOKEN}
