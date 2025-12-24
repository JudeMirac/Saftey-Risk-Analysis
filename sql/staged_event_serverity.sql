-- staging for severity level
DROP VIEW IF EXISTS stg_severity_level; -- Standard for reproducibility

CREATE VIEW stg_severity_level -- create new view (Standard for re running analytical pipelines 
SELECT
-- standardize text 
TRIM(LOWER("Metric 3")  AS severity, 

-- numeric values 
CAST(Incidents AS INTEGER) AS incidents, 
CAST(incident_id(CUSTOM) AS REAL) AS incident_id,
CAST(RI AS INTEGER) AS RI, 
CAST(recordable(CUSTOM) AS REAL) AS %recordable, 
CAST("MSD RI" AS INTEGER) AS msd_ri, 
CAST("%MSD RI" AS REAL) AS msd_ri%, 
CAST(DART AS INTEGER) AS dart, 
CAST(dart(custom) AS REAL) AS %dart, 
CAST(LTI AS INTEGER) AS lti, 
CAST(%LTI AS REAL) AS %lti, 

FROM raw_