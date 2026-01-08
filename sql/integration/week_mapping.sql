-- integration helper: map(fiscal_year + period = week_sum)
-- parsing period_name into week (example "2025 wk1" -> 1) 

DROP VIEW IF EXISTS week_mapping; 

CREATE VIEW week_mapping AS 
SELECT DISTINCT
    fiscal_year, 
    period_name,
        CAST(
            TRIM(
                REPLACE(
                    REPLACE(LOWER(period_name), 'wk', ''), 
                    CAST(fiscal_year as TEXT), ''
                )
            )AS INTEGER
        )AS week_sum

FROM stg_event_counts 
WHERE fiscal_year IS NOT NULL 
AND period_name IS NOT NULL; 
