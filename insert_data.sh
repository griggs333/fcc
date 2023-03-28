#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams;")"
cat games.csv | while IFS=$',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # get winner_id
    WINNER_ID="$($PSQL "SELECT team_id from teams WHERE name = '$WINNER';")"
    # if no winner_id insert team
    if [[ -z $WINNER_ID ]]
    then
      WINNER_INSERT_RETURN="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")"
      if [[ $WINNER_INSERT_RETURN = 'INSERT 0 1' ]]
      then
        # get winner_id
        WINNER_ID="$($PSQL "SELECT team_id from teams WHERE name = '$WINNER';")"
      fi
      
    fi

    # get opponent_id
     OPPONENT_ID="$($PSQL "SELECT team_id from teams WHERE name = '$OPPONENT';")"
    # if no opponent_id insert team
    if [[ -z $OPPONENT_ID ]]
    then
      OPPONENT_INSERT_RETURN="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")"
      if [[ $OPPONENT_INSERT_RETURN = 'INSERT 0 1' ]]
      then
        # get opponent_id
        OPPONENT_ID="$($PSQL "SELECT team_id from teams WHERE name = '$OPPONENT';")"
      fi
      
    fi

    # insert game
    GAME_INSERT_RETURN="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS); ")"
    echo $GAME_INSERT_RETURN
  fi

done
