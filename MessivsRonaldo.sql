-- Display dataset

SELECT *
FROM MessivsRonaldo_Dataset



-- Compare Goals For Career by Competition

ALTER TABLE MessivsRonaldo_Dataset
ALTER COLUMN Goals int;

	
SELECT Player, Competition, SUM(Goals) AS 'Career Goals'
FROM MessivsRonaldo_Dataset
WHERE Player = 'Messi' or Player = 'Ronaldo'
GROUP BY Player, Competition;



--Compare Assists

ALTER TABLE MessivsRonaldo_Dataset
ALTER COLUMN Assists int;

SELECT Player, Competition, SUM(Assists) AS 'Career Assists'
FROM MessivsRonaldo_Dataset
WHERE Player = 'Messi' or Player = 'Ronaldo'
GROUP BY Player, Competition;


-- Find AVG Match Rating that was less than 8 


ALTER TABLE MessivsRonaldo_Dataset
ALTER COLUMN Average_Match_Rating float;

SELECT Player, Season, Average_Match_Rating
FROM MessivsRonaldo_Dataset
WHERE Competition = 'UCL' AND average_Match_Rating < 8;



--Compare Average Goals per Competition to Goals per Competition per season in same table

SELECT Player,Season, Goals, SUM(Goals)
FROM MessivsRonaldo_Dataset
WHERE Competition = 'League' AND Player = 'Messi'
GROUP BY Player,Season, Goals 

SELECT Player,Season, Goals, AVG(Goals) 
FROM MessivsRonaldo_Dataset
WHERE Competition = 'League' AND Player = 'Ronaldo'
GROUP BY Player,Season, Goals



-- Use CASE to assign Ratings depending on Goal_Assist Totals Per Season

SELECT Player, Season, Goals_Assists,
CASE
	WHEN Goals_Assists BETWEEN 20 and 30 THEN 'Average'
	WHEN Goals_Assists BETWEEN 30 and 40 THEN 'Good'
	WHEN Goals_Assists BETWEEN 40 and 50 THEN 'Phenomenal'
	WHEN Goals_Assists >50 THEN 'Legendary'
	ELSE 'Poor'
END AS 'Season Rating'
FROM MessivsRonaldo_dataset
WHERE Competition = 'League'
ORDER BY 2;


--Average minutes playeed CTE in Champions League

ALTER TABLE MessivsRonaldo_Dataset
ALTER COLUMN Minutes int;


WITH Average_Minutes_Played as (
	SELECT Player, Competition, Season, [Minutes], AVG(Minutes) OVER(PARTITION BY Player) as Avg_Minutes
	FROM MessivsRonaldo_Dataset
	WHERE Competition = 'UCL'
	)
SELECT *
FROM Average_Minutes_Played
ORDER BY 3


