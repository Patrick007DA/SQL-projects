create database sqlproject2;
use sqlproject2;

create table match1(
srno int,
match_number int,
name1 varchar(50),
start_date date,
matchtype varchar(20),
series_id int,
match_detail_id	int,
scorecard_id int,
title varchar(50),
runs int,
overs float,
run_rate float,
match_id int,
opp_team_id	int,
team_id int
);

select * from match1 limit 20;

create table bat(
srno int,	
name_x varchar(50),
playing_role Varchar(50),	
id int,
orders int,	
runs_x int,	
balls int,	
strike_rate float,	
fours int,	
sixes int,	
how_out varchar(50),		
fall_of_wicket_over float,	
player_id int,	
scorecard_id int,	
match_number int,	
name_y varchar(50),	
start_date datetime,	
matchtype varchar(30),	
series_id int,	
match_detail_id	int,
title varchar(50),
runs_y int,	
overs float,	
run_rate float,	
match_id int,	
opp_team_id int,	
team_id int);

create table ball
(
srno int,
name_x char(50),	
playing_role varchar(20),
id int,
orders int,	
run_conceded int,	
maidens int,	
wickets	int,
overs float,
economy float,	
wides int,	
no_balls int,	
fours int,	
sixes int,	
zeros int,	 
player_id int,	
scorecard_id int,	
match_number int,	
name_y varchar(50),	
start_date datetime,	
matchtype varchar(30),
series_id int,	
match_detail_id int,	
title varchar(50),	
runs int,	
overs_played float,	
run_rate float,	
match_id int,	
opp_team_id	int,
team_id int);

select * from bat;
select * from ball;
select * from match1;

alter table match1 
rename column name1 to name_y;

/*Select India v Pakistan odi Matches*/
select match_id,name_y,matchtype, title
from match1
where name_y ="India v Pakistan" or name_y = "Pakistan v India" and matchType="odi";

/*no. of odi matches between India and Bangladesh*/
select name_y,count(*)
from match1
where name_y ="India v Bangladesh" or name_y = "Bangladesh v India" and matchType="odi"
group by name_y;


/*no. of matches played 50 ovrs*/
select name_y ,matchtype,overs,series_id,title
from match1
where matchtype="odi" and overs=50;

/*player with max strike rate who scored greater than 50*/
select name_x,max(strike_rate) as max_sr
from bat
where runs_x>50;

select * from bat;

/*rank by srike rate and partitioned by runs*/
select name_x,runs_x,strike_rate,dense_rank() over (partition by runs_x  order by strike_rate desc) as rnk
from bat
where runs_x<>0
order by runs_x desc;


/*opner player with status not out*/
select id,name_x,count(*) as not_out
from bat
where how_out="not out" and orders=1
group by name_x
order by not_out desc;

/*players who got catch out*/
select id,name_x,count(*) as catch_out
from bat
where how_out like 'c%' 
group by name_x
order by catch_out desc;

/*which team scored highest in t20*/
select * from match1;
select match_id,name_y,matchtype,title,max(runs) as max_runs
from match1
where matchtype="t20";

/*which team scored highest in all formats*/
select * from match1;
select match_id,name_y,matchtype,title,max(runs) as max_runs
from match1
group by matchtype;


/*list players with highest sixes and fours*/
select id,name_x,sum(sixes) as sixes,sum(fours) as four
from bat
group by name_x
order by sixes desc, fours desc;

select * from ball;
/*player with least economy*/
select name_x,min(economy) as leasteconomy,wickets
from ball
group by name_x
order by 2 ;

/*player with most wkt in t20*/
select name_x,matchtype,sum(wickets) as wickets1
from ball
where matchtype="t20"
group by 1
order by 3 desc;
/*Highest no. of wkts taken by players in all format*/
with cte as (
select name_x,matchtype,sum(wickets) as wickets1
from ball
group by 2,1
order by 3 desc)
select matchtype,name_x,max(wickets1) as wkt2
from cte
where matchtype is not null
group by 1
order by 3 desc;   

select * from ball;
select * from bat;
select * from match1;

/*list of player with strike rate match wise where runs are more than 40*/
select m1.match_detail_id,name_x,name_y,title,max(strike_rate) as Sr
from match1 as m1 inner join bat as b on m1.match_detail_id=b.match_detail_id 
where runs_x>40
group by name_x
order by strike_rate desc;

/* list of players economy match wise*/
with cte as (
select m1.match_detail_id,name_x,name_y,matchtype,title,min(economy) as LeastEco
from match1 as m1 inner join ball as b on m1.match_detail_id=b.match_detail_id 
where b.overs>5 
group by name_x
order by min(economy) asc)
select match_detail_id,name_x,name_y,matchtype,title,LeastEco
from cte
group by matchtype;

/*player with most maidens matchtype wise*/

select name_x,matchtype,sum(maidens) as maiden1 ,b.overs
from ball as b inner join match1 as m1 on b.match_detail_id=m1.match_detail_id
where b.overs>5 and matchtype="odi"
group by name_x
order by 3 desc;


