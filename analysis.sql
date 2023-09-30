/*How many olympics games have been held?*/

select count(*) from athlete_events;

/*List down all Olympics games held so far.*/

select count(distinct(Games)) from athlete_events;

/*Mention the total no of nations who participated in each olympics game?*/

select Games, count(DISTINCT(NOC)) from athlete_events
group by Games;


/*Which year saw the highest and lowest no of countries participating in olympics?*/

with cte as
(Select left(Games,4) as Year,count(distinct(Team)) Count_Countries
from athlete_events
group by 1)
select Year, Count_Countries as Maximum from cte where Count_Countries = (select max(Count_Countries) from cte);
	
with cte as
(Select left(Games,4) as Year,count(distinct(Team)) Count_Countries
from athlete_events
group by 1)
select Year, Count_Countries as Minimum from cte where Count_Countries = (select min(Count_Countries) from cte);

/*Which nation has participated in all of the olympic games?*/

select Team, count(Games)
from
(select Team, Games, count(*)
from athlete_events
group by Team, Games) as t1
group by Team
having count(Games) = (select count(distinct(Games)) from athlete_events);

/*Identify the sport which was played in all summer olympics.*/

select Season, Sport, count(*) as count_of
from athlete_events
group by 1,2
having count_of = (select count(Games) from athlete_events where Season = 'Summer');


/*Which Sports were just played only once in the olympics?*/

select Games, Sport,count(Sport)
from athlete_events
group by 1,2
having count(Sport) = 1;


/*Fetch the total no of sports played in each olympic games.*/

select Games,count(distinct(Sport)) as Total_Number_of_Sports
from athlete_events
group by Games;


/*Fetch details of the oldest athletes to win a gold medal.*/

select Name,Age
from athlete_events
where Medal='Gold'
order by Age desc
limit 10;

/*Find the Ratio of male and female athletes participated in all olympic games.*/

with cte as
(select Games,case 
                 when Sex = 'M' then 1
                 else 0
                 end as Males,
             case 
                 when Sex = 'F' then 1
                 else 0
                 end as Females
from athlete_events)
select Games,sum(Males)/sum(Females) as Ratio
from cte             
group by Games
order by Games;              

/*Fetch the top 5 athletes who have won the most gold medals.*/

select Name,count(Medal) as Total_Golds
from athlete_events
where Medal = "Gold"
group by Name
order by 2 desc
limit 5;


/*Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).*/

select Name,count(Medal) as Total_Medals
from athlete_events
group by Name
order by 2 desc
limit 5;


/*Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.*/

select Team, count(Medal) as Total_Medals
from athlete_events
where Medal != 'NA'
group by Team
order by Total_Medals desc
limit 5;


/*List down total gold, silver and broze medals won by each country.*/


select Team, sum(Gold) as Total_Golds,sum(Silver) as Total_Silvers,sum(Bronze) as Total_Bronzes
from
(select Team, case
                 when medal="Gold" then 1
                 else 0
                 end as Gold,
             case
                 when medal="Silver" then 1
                 else 0
                 end as Silver,
             case
                 when medal="Bronze" then 1
                 else 0
                 end as Bronze 
from athlete_events) as t1
group by Team
order by 2 desc,3 desc,4 desc;

/*List down total gold, silver and broze medals won by each country corresponding to each olympic games.*/

select Team, Games, sum(Gold) as Total_Golds,sum(Silver) as Total_Silvers,sum(Bronze) as Total_Bronzes
from
(select Team, Games, 
			 case
                 when medal="Gold" then 1
                 else 0
                 end as Gold,
             case
                 when medal="Silver" then 1
                 else 0
                 end as Silver,
             case
                 when medal="Bronze" then 1
                 else 0
                 end as Bronze 
from athlete_events) as t1
group by Team, Games
order by 3 desc,4 desc,5 desc;

/*Which countries have never won gold medal but have won silver/bronze medals?*/

select Team, count(Medal)
from athlete_events
where Medal!='Gold' and Medal!="NA"
group by Team;


/*In which Sport/event, India has won highest medals.*/

SELECT Team, Sport,count(Medal) as Medal_Counts
from athlete_events
where Team = 'India'
group by Team,Sport
order by Medal_Counts Desc
limit 1;


/*Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.*/

select Games, Sport, sum(Medal_Count)
from
(select Games,Sport,count(Medal) as Medal_Count,case
                                    when Sport='Hockey' then 1
                                    else 0
                                    end as hockey_status
from athlete_events
where Team="India"
group by 1,2) as t1
group by 1,2




