-- ==========================================
-- Question 1: All matches of a given team, ordered by date
-- Returns: date, home team, score, away team
-- ==========================================

SELECT 
    m.match_date AS "date",
    ht.name AS "home team",
    CASE 
        WHEN m.home_goals IS NULL THEN 'vs'
        ELSE CONCAT(m.home_goals, ' - ', m.away_goals)
    END AS "score",
    at.name AS "away team"
FROM matches m
JOIN teams ht ON m.home_team_id = ht.id
JOIN teams at ON m.away_team_id = at.id
WHERE m.home_team_id = 1 OR m.away_team_id = 1
ORDER BY m.match_date ASC;


-- ==========================================
-- Question 2: The standings
-- Returns: team, matches played, points, goals scored and conceded
-- ==========================================

SELECT 
    t.name AS team,
    COUNT(m.id) AS matches_played,
    COALESCE(SUM(
        CASE 
            WHEN m.home_goals > m.away_goals AND m.home_team_id = t.id THEN 3
            WHEN m.away_goals > m.home_goals AND m.away_team_id = t.id THEN 3
            WHEN m.home_goals = m.away_goals THEN 1
            ELSE 0
        END
    ), 0) AS points,
    COALESCE(SUM(
        CASE 
            WHEN m.home_team_id = t.id THEN m.home_goals
            ELSE m.away_goals
        END
    ), 0) AS goals_scored,
    COALESCE(SUM(
        CASE 
            WHEN m.home_team_id = t.id THEN m.away_goals
            ELSE m.home_goals
        END
    ), 0) AS goals_conceded
FROM teams t
LEFT JOIN matches m 
    ON (t.id = m.home_team_id OR t.id = m.away_team_id)
   AND m.home_goals IS NOT NULL
GROUP BY t.id, t.name
ORDER BY points DESC, (goals_scored - goals_conceded) DESC;