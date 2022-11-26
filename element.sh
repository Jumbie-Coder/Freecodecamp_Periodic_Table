PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]*$ ]]
  then
    ATOMIC_NUMBER_EXISTS=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  fi
  SYMBOL_EXISTS=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  NAME_EXISTS=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  # If element is an atomic number and it exists
  if [[ -z $ATOMIC_NUMBER_EXISTS && -z $SYMBOL_EXISTS && -z $NAME_EXISTS ]]
  then
    echo "I could not find that element in the database."
    exit
  elif [[ ! -z $ATOMIC_NUMBER_EXISTS ]]
  then
    ELEMENT_JOIN=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ATOMIC_NUMBER_EXISTS")
  elif [[ ! -z $SYMBOL_EXISTS ]]
  then
    ELEMENT_JOIN=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types ON properties.type_id = types.type_id WHERE symbol='$1'")  
  elif [[ ! -z $NAME_EXISTS ]]
  then
    ELEMENT_JOIN=$($PSQL "SELECT atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types ON properties.type_id = types.type_id WHERE name='$1'")
  fi
  echo "$ELEMENT_JOIN" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  fi
