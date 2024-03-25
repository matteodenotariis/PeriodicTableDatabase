#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t -c"
ELEMENTS=$($PSQL "SELECT atomic_number,symbol,name FROM elements")
if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
else
  # get element
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
      ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' or name='$1'")
  else
      ELEMENT=$($PSQL "SELECT atomic_number FROM  elements WHERE atomic_number=$1")
  fi
  if [[ -z $ELEMENT ]]
  then
      echo "I could not find that element in the database."
  else
      # get element parameters
      ELEMENT_INFO=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,melting_point_celsius,boiling_point_celsius,type  FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id)  WHERE atomic_number=$ELEMENT")
      echo "$ELEMENT_INFO" | while read ATOMIC BAR SYMBOL BAR NAME BAR MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE
      do
        echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
      done
  fi
fi
