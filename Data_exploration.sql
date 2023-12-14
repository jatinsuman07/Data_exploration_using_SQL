USE new

select * from iplBallbyBall

select * from iplmatches

select count(*) from iplBallbyBall
select count(*) from iplmatches

-- 1~ find playing teams and winner when team 1 is winner 
select team1, team2, winner from iplmatches
where winner = team1

-- 2~ finding no of win when won toss
select count(winner) from
(select winner, toss_winner from iplmatches
where toss_winner=winner)a

-- 3 find all the matches where result mode is in runs and margin is > 100
select result, result_margin from iplmatches
where result='runs' and result_margin>100

-- 4~ fetch data of all the matches where final score of both team tied 
select * from iplmatches
where result = 'tie'
order by id

-- 5~ get count of cities of where match is hosted
select count(distinct venue) from iplmatches

-- 6~ create table new_ipl with all the columns of the table 'iplBallbyBall' 
-- and an additional column ball_result containing 
-- values boundry, dot or other depending on the total_run

SELECT *,
       CASE
           WHEN total_runs >= 4 THEN 'boundary'
           WHEN total_runs = 0 THEN 'dot'
           ELSE 'other'
       END AS ball_result
INTO new_ipl
FROM iplBallbyBall;

select * from new_ipl 

-- 7.0~ fetch the total number of boundries and dot balls from 'new_ipl table
select ball_result, count(*) from new_ipl
group by ball_result
--7.1 total number of only boundary
select ball_result, count(*) from new_ipl
where ball_result='boundary'
group by ball_result
--7.2 total number of dot balls
select ball_result, count(*) from new_ipl
where ball_result='dot'
group by ball_result

-- 8~ find the total number of boundary scored by each team from table 'new_ipl' 
-- and order it in descending order
select batting_team,count(ball_result)  no_of_boundries from
(select batting_team,ball_result from new_ipl
where ball_result = 'boundary')a
group by batting_team
order by count(ball_result) desc

-- 9~ finding matches per season (using matches played per year)
select year, count(distinct id) Number_of_matches from
(select year(date) Year, id from iplmatches)a
group by year

-- 10~ most player of the match
select player_of_match, count(player_of_match) mom from iplmatches
group by player_of_match    
order by count(player_of_match) desc;
-- now you can find most times player of the match

-- 11~ most wins by any team
select winner,count(winner) from iplmatches
group by winner
order by count(winner) desc;   -- arranging in descending order

-- 12~ top 5 venues where matches were played
select top 5 venue, count(venue) from iplmatches
group by venue
order by count(venue) desc;

-- 13~ most runs by any batsman
select top 1 batsman, sum(total_runs) from iplBallbyBall
group by batsman
order by sum(total_runs) desc;

-- 14~ total runs scored in ipl
select sum(total_runs) Total_runs_in_IPL from
 (select batsman, sum(total_runs) total_runs from iplBallbyBall group by batsman)a;

 select *,
 sum(total_runs) over(order by total_runs rows between unbounded preceding and unbounded following) runs from
 (select batsman, sum(total_runs) total_runs from iplBallbyBall group by batsman)a;

 -- 15~ most sixes by any batsman
select top 1 batsman, count(batsman) from 
 (select * from iplBallbyBall where batsman_runs = 6)a
group by batsman
order by count(batsman) desc

-- 16~ most fours by any batsman
select top 1 batsman, count(batsman) from
(select * from iplBallbyBall where batsman_runs=4)a
group by batsman
order by count(batsman) desc

-- 17~ more than 3000 runs and highest strike rate
select top 1 batsman,batsman_runs,strike_rate from
(select batsman,batsman_runs,((batsman_runs*1.0/balls_faced)*100) strike_rate from
(select batsman, sum(batsman_runs) batsman_runs, count(batsman) balls_faced from iplBallbyBall  -- we have counted batsman because batsman name arrives whan he faced a ball (no. of balls faced == no. of batsman name arrive
group by batsman)a)b
where batsman_runs>=3000
order by strike_rate desc;

-- 18 ~ lowest econumy rate for a bowler who has bowled at least 50 overs
---------------------------
select * from iplBallbyBall
---------------------------

select top 1 bowler,total_overs,Economy from
(select bowler,total_overs,total_balls,total_runs, (total_runs/(total_balls*1.0)) Economy from
(select bowler,sum(total_runs) total_runs,count(bowler) total_balls, count(bowler)/6 total_overs from iplBallbyBall
group by bowler)a)b
where total_overs>=50
order by Economy

-- 19 ~ total matches played till 2020
select count(distinct id) from iplmatches -- because we have data till 2020 only

-- 20 total no. of matches win by each team
select winner, count(winner) Matches_won from iplmatches
group by winner
order by Matches_won desc;







