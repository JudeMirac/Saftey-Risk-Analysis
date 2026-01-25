-- staging for root cause 

DROP VIEW IF EXISTS stg_root_cause; 

CREATE VIEW stg_root_cause AS 
SELECT
-- metric
TRIM(LOWER("METRIC 2")) as root_cause, 

-- measures 
CAST(Incidents as INTEGER) as incidents, 
CAST("incident_id (CUSTOM)" as REAL) as incident_id, 
CAST(RI as INTEGER) AS ri, 
CAST("recordable (CUSTOM)" as REAL) as recordable_pct, 
CAST("MSD RI" as INTEGER) as msd, 
CAST("%MSD RI" as REAL) as msd_ri, 
CAST(DART as INTEGER) as dart, 
CAST("DART (CUSTOM)" as REAL) as dart_pct

FROM raw_root_cause 
WHERE "Metric 2" IS NOT NULL; 