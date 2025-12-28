-- staging for severity level
DROP VIEW IF EXISTS stg_severity_level; -- Standard for reproducibility

CREATE VIEW stg_severity_level AS -- create new view (Standard for re running analytical pipelines 
SELECT
-- standardize text 
TRIM(LOWER("Metric 3"))  AS severity, 

-- numeric values 
CAST(Incidents AS INTEGER) AS incidents, 
CAST("incident_id(CUSTOM)" AS REAL) AS incident_id,
CAST(RI AS INTEGER) AS RI, 
CAST("recordable(CUSTOM)" AS REAL) AS "recordable_pct", 
CAST("MSD RI" AS INTEGER) AS msd_ri, 
CAST("%MSD RI" AS REAL) AS "msd_ri_pct", 
CAST(DART AS INTEGER) AS dart, 
CAST("dart(custom)" AS REAL) AS "dart_pct", 
CAST(LTI AS INTEGER) AS lti, 
CAST("%LTI" AS REAL) AS "lti_pct" 

FROM raw_severity_level
WHERE "Metric 3" IS NOT NULL; 
