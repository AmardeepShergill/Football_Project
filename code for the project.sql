-- How many days have passed from the oldest Match to the most recent one
    SELECT DATE_DIFF(max(date), min(date), day) AS DateDiff 
FROM `sql-sandbox-347110.Final_Exercise.match`;

-- gives the answer of 2868

-- Produce a table which, for each Season and League Name, shows the following statistics about the home goals scored: 
-- a) min 
-- b) average    
-- c) mid-range 
-- d) max 
-- e) sum 
-- Then confirm which combination of Season and League has the highest number of goals?

    SELECT a.season, b.name as league_name,
 min(a.home_team_goal) as min_home_team_goal,
 avg(a.home_team_goal) as avg_home_team_goal,
 (max(a.home_team_goal) + min(a.home_team_goal))/2 as midrange_home_team_goal,
 max(a.home_team_goal) as max_home_team_goal,
 sum(a.home_team_goal) as sum_home_team_goal
FROM `sql-sandbox-347110.Final_Exercise.match` a
LEFT JOIN `sql-sandbox-347110.Final_Exercise.leagues` b
 on a.league_id = b.id
GROUP BY a.season, b.name
ORDER BY sum_home_team_goal desc

-- Find out how many unique seasons there are in the Match table. Then write a query that shows, for each Season, the number of matches played by each League. Do you notice anything out of the ordinary?
    Answer: Belgium Jupiler League only has 12 home goals in 2013/2014
SELECT distinct season
FROM `sql-sandbox-347110.Final_Exercise.match`

SELECT a.season, b.name as league_name,
count(a.id) as Matches_played
FROM `sql-sandbox-347110.Final_Exercise.match` a
LEFT JOIN `sql-sandbox-347110.Final_Exercise.leagues` b
on a.league_id = b.id

-- Using Players as the starting point, create a new table (PlayerBMI) and add:
-- a) a new variable that represents the players’ weight in kg (divide the mass value by 2.205) and call it kg_weight;
-- b) a variable that represents the height in metres (divide the cm value by 100) and call it m_height;
-- c) a variable that shows the body mass index (BMI) of the player;
-- d) Filter the table to show only the players with an optimal BMI (from 18.5 to 24.9). How many rows does this table have?
-- e) How many players do not have an optimal BMI?
Answer: 10,197 
CREATE TABLE Final_Exercise.PlayerBMI AS
SELECT *,
 weight/2.205 as kg_weight,
 height/100 as m_height,
 (weight/2.205)/power(height/100, 2) as BMI
FROM `sql-sandbox-347110.Final_Exercise.player`
WHERE (weight/2.205)/power(height/100, 2) between 18.5 and 24.9

-- for part e)
Answer: 863
SELECT
 (SELECT count(id)
 FROM `sql-sandbox-347110.Final_Exercise.player`) - 
 (SELECT count(id)
 FROM `sql-sandbox-347110.Final_Exercise.PlayerBMI`) as PlayerNoBMI



    
--  Which Team has scored the highest total number of goals (home + away) during the most recent available season? How many goals has it scored?
    select h.team_long_name, h.SumOfGoalHome, a.SumOfGoalAway, h.SumOfGoalHome + a.SumOfGoalAway as TotalGoal
from
 (select t.team_long_name, sum(m.home_team_goal) as SumOfGoalHome
 from `sql-sandbox-347110.Final_Exercise.match` m 
 inner join `sql-sandbox-347110.Final_Exercise.team` t 
   on m.home_team_api_id = t.team_api_id 
 where m.season = (select max(season) from `sql-sandbox-347110.Final_Exercise.match`)
 group by t.team_long_name order by SumOfGoalHome) h 
inner join
 (select t.team_long_name, sum(m.away_team_goal) as SumOfGoalAway
 from `sql-sandbox-347110.Final_Exercise.match` m 
 inner join `sql-sandbox-347110.Final_Exercise.team` t 
   on m.away_team_api_id = t.team_api_id 
 where m.season = (select max(season) from `sql-sandbox-347110.Final_Exercise.match`)
 group by t.team_long_name order by SumOfGoalAway) a 
   on h.team_long_name = a.team_long_name
order by TotalGoal desc
limit 1

   on a.team_api_id = b.team_api_id
GROUP BY b.team_long_name
ORDER BY goals desc
LIMIT 1

-- Create a query that, for each season, shows the name of the team that ranks first in terms of total goals scored (the output table should have as many rows as the number of seasons). Which team was the one that ranked first in most of the seasons?
    Answer: FC Real_madrid
select *
from
(select h.season, h.team_long_name, h.SumOfGoalHome, a.SumOfGoalAway, h.SumOfGoalHome + a.SumOfGoalAway as TotalGoal,
rank() over (partition by a.season order by h.SumOfGoalHome + a.SumOfGoalAway desc) as rank_season
from
(select m.season, t.team_long_name, sum(m.home_team_goal) as SumOfGoalHome
from `sql-sandbox-351014.Final_Exercise.Match` m inner join 
`sql-sandbox-351014.Final_Exercise.Team` t on m.home_team_api_id = t.team_api_id
group by m.season, t.team_long_name order by SumOfGoalHome) h 
inner join
(select m.season,t.team_long_name, sum(m.away_team_goal) as SumOfGoalAway
from `sql-sandbox-351014.Final_Exercise.Match` m inner join 
`sql-sandbox-351014.Final_Exercise.Team` t on m.away_team_api_id = t.team_api_id 
group by m.season, t.team_long_name order by SumOfGoalAway) a 
on h.team_long_name = a.team_long_name and h.season=a.season)
where rank_season = 1
order by season desc

-- From question 8 create a new table (TopScorer) containing the top 10 teams in terms of total goals scored (hint: add the team id as well). Then write a query that shows all the possible “pair combinations” between those 10 teams. How many “pair combinations” did it generate?
Answer: 45
create table `sql-sandbox-347110.Final_Exercise.TopScorer` as
(select h.team_api_id ,h.team_long_name, h.SumOfGoalHome, a.SumOfGoalAway, h.SumOfGoalHome + a.SumOfGoalAway as TotalGoal
from
(select t.team_api_id ,t.team_long_name, sum(m.home_team_goal) as SumOfGoalHome
from `sql-sandbox-347110.Final_Exercise.match` m inner join 
`sql-sandbox-347110.Final_Exercise.team` t on m.home_team_api_id = t.team_api_id 
where m.season = (select max(season) from `sql-sandbox-347110.Final_Exercise.match`)
group by t.team_api_id, t.team_long_name order by SumOfGoalHome) h inner join
(select t.team_long_name, sum(m.away_team_goal) as SumOfGoalAway
from `sql-sandbox-347110.Final_Exercise.match` m inner join 
`sql-sandbox-347110.Final_Exercise.team` t on m.away_team_api_id = t.team_api_id 
where m.season = "2015/2016"
group by t.team_long_name order by SumOfGoalAway) a on h.team_long_name = a.team_long_name
order by TotalGoal desc
limit 10)

SELECT a.team_long_name, b.team_long_name
FROM `sql-sandbox-347110.Final_Exercise.TopScorer` a
LEFT JOIN `sql-sandbox-347110.Final_Exercise.TopScorer` b
on a.team_api_id > b.team_api_id
where a.team_long_name is not null and  b.team_long_name is not null

SELECT a.team_long_name, b.team_long_name
FROM `sql-sandbox-347110.Final_Exercise.TopScorer` a
INNER JOIN `sql-sandbox-347110.Final_Exercise.TopScorer` b
 on a.team_api_id > b.team_api_id
