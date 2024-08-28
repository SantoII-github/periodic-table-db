#!/bin/bash
# This script gets information about an element in periodic_table.sql
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# This function will attempt to get the Atomic Number of the element using the argument provided, assuming it's an atomic number,
# symbol, or element name, in that order. It will then call the function to print info about an element given its atomic number.
GET_ELEMENT() {
  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  else
    # check if is a positive integer
    if [[ $1 =~ ^[1-9][0-9]*$ ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
      ELEMENT_INFO $ATOMIC_NUMBER
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        ELEMENT_INFO $ATOMIC_NUMBER
      fi
    fi
  fi
}

ELEMENT_INFO () {
  ELEMENT_RESULTS=$($PSQL "SELECT symbol, name FROM elements WHERE atomic_number=$1")
  PROPERTIES_RESULTS=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
  IFS="|" read -r SYMBOL NAME <<< "$ELEMENT_RESULTS"
  IFS="|" read -r ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE <<< "$PROPERTIES_RESULTS"

  echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
}

GET_ELEMENT $1