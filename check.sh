#!/bin/bash
if [ -z "`which psql`" ]; then
  echo "installing psql client."
  apt-get update
  apt-get -y install postgresql postgresql-contrib
else
  'psql client exists already';
fi
