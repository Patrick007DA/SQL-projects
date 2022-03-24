/*Data Exploration using Mysql*/
create database Rproject;
use Rproject;
select * from resultn;

select count(MatchID) from resultn;

/*Converting date column which is in text to date*/ 
Set SQL_SAFE_UPDATES = 0;

Alter table resultn
add column date date;
update resultn 
set Mdate=str_to_date(Odate,"%Y-%m-%d");

/*Droping previous original date column*/
alter table resultn
drop column Odate;

select * from resultn
where home_team = "England";

/*How many times England wins*/
select home_team , count(*) as No_of_Wins
from resultn
where home_team="England" and home_score>away_score
group by home_team;

/*to find a team with max. no. of wins*/
select home_team,count(*) as Max_win
from resultn 
where home_score>away_score
group by home_team
order by count(*) desc
limit 1;

/*to find a team with min. no. of wins*/
select home_team,count(*) as Min_win
from resultn 
where home_score>away_score
group by home_team
order by 2 asc
limit 1;

/*no. of diffrent tournaments*/
select distinct(tournament)
from results;

/*Most no. of goals*/
select home_team,sum(home_score+away_score) Goals 
from resultn
group by home_team
order by 2 desc;

/*Finding location of Match*/
select r.MatchID,home_team,away_team,city
from resultn as r inner join location as l
on
r.Matchid=l.Matchid;

/*Find matches of britishChamponship*/
select r.MatchID,home_team,away_team,tournament
from resultn as r inner join location as l
on
r.Matchid=l.Matchid
where tournament="British Championship";

/*No. of times country played in home country*/
select r.MatchID,home_team,away_team,country
from resultn as r inner join location as l
on
r.Matchid=l.Matchid
where home_team=country
group by home_team
order by matchid asc;


/* find 3rd least goal scoring country using cte and */
with Cte as (
select home_team,sum(home_score+away_score) Goals 
from resultn
group by home_team
order by 2 desc)
select home_team , Goals
from (select home_team,goals,dense_rank() over (order by goals asc) as nthgoalscorer
from cte ) as tt
where nthgoalscorer=2;


/*no. matches tied*/
select count(*) as tied_matches
from resultn
where home_score=away_score;
