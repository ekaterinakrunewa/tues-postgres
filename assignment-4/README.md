# Decisions I made and why (Assignment 4)

I designed the database with two tables: `teams` and `matches`. 
Every table has an `id SERIAL PRIMARY KEY`, and relationships use `FOREIGN KEY` constraints (`home_team_id` and `away_team_id` reference `teams.id`). 
I deliberately do not store points, goals scored/conceded, or matches played in the `teams` table because storing derived data can lead to data inconsistency; instead, all standings and statistics are calculated dynamically using SQL queries. 
Unplayed matches are supported by allowing `home_goals` and `away_goals` to be `NULL`.
