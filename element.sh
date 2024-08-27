#!/bin/bash
# This script gets information about an element in periodic_table.sql
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c --tuples-only"

GET_ELEMENT() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    echo "code here"
  fi
}

GET_ELEMENT