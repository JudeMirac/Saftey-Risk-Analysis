
                                -- staging for hours worked
DROP VIEW IF EXISTS stg_hours_worked; -- drop existing view (This is used for re running pipelines)

CREATE VIEW stg_hours_worked AS  -- creating the new view ( This process is good for reporducitibity in analytical pipelines)
-- standardize text
SELECT 
TRIM(LOWER(site))          AS site,
TRIM(LOWER(region))        AS region,
TRIM(LOWER(country))       AS country, 
TRIM(LOWER(state))         AS new_jersey,
TRIM(LOWER(site_type))     AS site_type, 
TRIM(LOWER(org))           AS org, 
TRIM(LOWER(suborg))        AS suborg, 

-- time 
CAST(year AS INTEGER) AS year, 
CAST(period AS INTEGER) AS period,
date(created_date) AS created_date, 
date(updated_date) AS updated_date, 

-- exposure 
CAST(employee_hours AS REAL) AS employee_hours, 
CAST(contractor_hours AS REAL) AS contractor_hours, 
CAST(total_hours AS REAL) AS total_hours, 

-- data quality 
TRIM(LOWER(verified)) AS verified

FROM raw_hours_worked 
WHERE site IS NOT NULL;

