-- integration helper: map(fiscal_year + period = week_sum)
-- parsing period_name into week (example "2025 wk1" -> 1) 

DROP VIEW IF EXISTS week_mapping; 

CREATE VIEW week_mapping 
SELECT 
DISTINCT 
fiscal_year, 
period_name
LOWER(period_name), 
TRIM(REPLACE(period_name) 'wk' '' -- removes week from spelling 
TRIM(CAST(fiscal_year as text) -- numeric stings can't be replaced
TRIM(REPLACE(fiscal_year) '2025' '' -- removes year from spelling 
TRIM(CAST(period_name as INTEGER) as week_sum
FROM stg_event_counts
WHERE fiscal_year IS NOT NULL
AND period_name IS NOT NULL; 

