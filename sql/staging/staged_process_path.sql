-- staging for process path

DROP VIEW IF EXISTS stg_process_path; -- Good start for reproducibiltiy 

CREATE VIEW stg_process_path AS 
SELECT 
--  standardize text 
TRIM(LOWER("METRIC 1")) AS process_path, 

-- numerical values 
CAST(Incidents AS INTEGER) AS incidents, 
CAST(Incident_id AS REAL) AS incident_pct, 
CAST(RI AS INTEGER) AS ri, 
CAST("recordable(CUSTOM)" AS REAL) AS recordable_pct, 
CAST("MSD RI" AS INTEGER) AS msd_ri, 
CAST("%MSD RI" AS REAL) AS msd_ri_pct, 
CAST(DART AS INTEGER) AS dart, 
CAST("dart (CUSTOM)" AS REAL) AS dart_pct

FROM raw_process_path 
WHERE "METRIC 1" IS NOT NULL; 




