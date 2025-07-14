# Football_Project
 
## A SQL based project looking at some seasonal data from european football teams.
  
This is a project that will European Soccer Database, a collection of four individual CSV files know as below
- leagues.csv
- match.csv
- player.csv
- match.csv
- 
I will be looking to answer the below set of questions that had been posed on the data. It was originally done in google bigquery and I will be copying over the code use to answer the given questions.

Questions:
1. How many days have passed from the oldest Match to the most recent one
2. Produce a table which, for each Season and League Name, shows the following statistics about the home goals scored: 
  a) min
  b) average 
  c) mid-range 
  d) max 
  e) sum

Then confirm which combination of Season and League has the highest number of goals?
4. Find out how many unique seasons there are in the Match table. Then write a query that shows, for each Season, the number of matches played by each League. Do you notice anything out of the ordinary?
5. Using Players as the starting point, create a new table (PlayerBMI) and add: 
  a) a new variable that represents the players’ weight in kg (divide the mass value by 2.205) and call it kg_weight; 
  b) a variable that represents the height in metres (divide the cm value by 100) and call it m_height; 
  c) a variable that shows the body mass index (BMI) of the player;
  d) Filter the table to show only the players with an optimal BMI (from 18.5 to 24.9).  How many rows does this table have?
6. How many players do not have an optimal BMI?
7. Which Team has scored the highest total number of goals (home + away) during the most recent available season? How many goals has it scored?
8. Create a query that, for each season, shows the name of the team that ranks first in terms of total goals scored (the output table should have as many rows as the number of seasons).  Which team was the one that ranked first in most of the seasons?
9. From question 8 create a new table (TopScorer) containing the top 10 teams in terms of total goals scored (hint: add the team id as well). 
Then write a query that shows all the possible “pair combinations” between those 10 teams. How many “pair combinations” did it generate?



