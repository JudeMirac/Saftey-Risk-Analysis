-- staging contributiing factors
DROP VIEW IF EXISTS raw_contributing_factors; -- This is good start for reproducibility

CREATE VIEW stg_contributing_factors AS 
SELECT 
-- standardize text 
TRIM(LOWER("METRIC 4")) AS factor, 

-- numerical values 
CAST(Incidents AS INTEGER AS) incidents, 
CAST("%Incidents" AS REAL) AS incidents_pct, 
CAST(RI AS INTEGER) AS ri,
CAST('recordable (CUSTOM)' AS REAL) AS recordable_pct, 
CAST("MSD RI" AS INTEGER) AS msd_ri, 
CAST("%MSD RI" ASS REAL) AS msd_ri_pct, 
CAST(DART AS INTEGER) AS dart, 
CAST("dart (CUSTOM)" AS REAL) AS dart_pct, 
CAST(LTI AS INTEGER AS lti, 
CAST("%LTI" AS REAL) AS lti_pct 

FROM raw_contributing_factors
WHERE "METRIC 4" IS NOT NULL; 

