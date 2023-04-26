-- Most Fouls Committed
SELECT TOP 10 team, SUM(fouls) as most_fouls_committed
FROM (
    SELECT team1 as team, fouls_against_team1 as fouls
    FROM Fifa_world_cup_matches$
    UNION ALL
    SELECT team2 as team, fouls_against_team2 as fouls
    FROM Fifa_world_cup_matches$
) as match_fouls
GROUP BY team
ORDER BY most_fouls_committed DESC;

--Calculating which team scored the most goals

SELECT team, SUM(goals) as goals_scored
FROM (
    SELECT team1 as team, number_of_goals_team1 as goals
    FROM Fifa_world_cup_matches$
    UNION ALL
    SELECT team2 as team, number_of_goals_team2 as goals
    FROM Fifa_world_cup_matches$
) as match_goals
GROUP BY team
ORDER BY goals_scored DESC;


--Most attempts on goal
SELECT team, SUM(on_target_attempts) as total_on_target_attempts
FROM (
    SELECT team1 as team, on_target_attempts_team1 as on_target_attempts
    FROM Fifa_world_cup_matches$
    UNION ALL
    SELECT team2 as team, on_target_attempts_team2 as on_target_attempts
    FROM Fifa_world_cup_matches$
) as match_on_target_attempts
GROUP BY team
ORDER BY total_on_target_attempts DESC;

--Calculating goal conversion rate based on attempts on goal and total goals scored

SELECT 
    team,
    SUM(goals) as total_goals,
    SUM(on_target_attempts) as total_on_target_attempts,
    ROUND(
	CASE
        WHEN SUM(on_target_attempts) > 0 THEN SUM(goals) * 100 / SUM(on_target_attempts)
        ELSE NULL
    END,2) as goal_conversion_rate
FROM (
    SELECT team1 as team, number_of_goals_team1 as goals, on_target_attempts_team1 as on_target_attempts
    FROM Fifa_world_cup_matches$
    UNION ALL
    SELECT team2 as team, number_of_goals_team2 as goals, on_target_attempts_team2 as on_target_attempts
    FROM Fifa_world_cup_matches$
) as match_stats
GROUP BY team
ORDER BY goal_conversion_rate DESC;

-- Calculating Average Possesstion Per Team
SELECT TOP 10 team, ROUND(AVG(possession)*100, 2) AS avg_possession
FROM (
		SELECT team1 as team, possession_team1 as possession
		FROM Fifa_world_cup_matches$
		UNION ALL	
		SELECT team2 as team, possession_team2 as possession
		FROM Fifa_world_cup_matches$
		) subquery
		GROUP BY team
		ORDER BY avg_possession DESC
--Number of matches drawn
SELECT distinct team, COUNT(*) as total_draws
FROM 
	(
	SELECT team1 as team
	FROM Fifa_world_cup_matches$
	WHERE Outcome='Draw'
	UNION ALL
	SELECT team2 as team
	FROM Fifa_world_cup_matches$
	WHERE Outcome='Draw'

	) sui
GROUP BY team
ORDER BY total_draws desc

--Goals scored inside the box v/s outside the box
SELECT 
    team,
    SUM([Goals_Inside_Box]) AS [Total Goals Inside Box],
    SUM([Goals_Outside_Box]) AS [Total Goals Outside Box]
FROM (
    SELECT 
        team1 AS team,
        SUM([goal_inside_the_penalty_area_team1]) AS [Goals_Inside_Box],
        SUM([goal_outside_the_penalty_area_team1]) AS [Goals_Outside_Box]
    FROM Fifa_WC_2022.dbo.Fifa_world_cup_matches$
    GROUP BY team1

    UNION ALL

    SELECT 
        team2 AS Team,
        SUM([goal_inside_the_penalty_area_team2]) AS [Goals_Inside_Box],
        SUM([goal_outside_the_penalty_area_team2]) AS [Goals_Outside_Box]
    FROM Fifa_WC_2022.dbo.Fifa_world_cup_matches$
    GROUP BY team2
) AS team_goals
GROUP BY team
ORDER BY [Total Goals Inside Box] DESC
	

--- Calculating Offsides per team---
SELECT team,
SUM (offsides_team1) AS Offsides_Per_Team
FROM (
		SELECT team1 as team, Offsides_team1
		FROM Fifa_WC_2022.dbo.Fifa_world_cup_matches$
	
		
		UNION ALL
		SELECT team2 as team, offsides_team2
		FROM Fifa_WC_2022.dbo.Fifa_world_cup_matches$
		) sui
		GROUP BY team
		ORDER BY Offsides_Per_Team desc
