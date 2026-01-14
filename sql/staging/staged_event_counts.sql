--- staging for event counts 
DROP VIEW IF EXISTS stg_event_counts;

CREATE VIEW stg_event_counts AS 
SELECT
-- standardize text
TRIM(LOWER("OBR Scope")) AS obr_scope,
TRIM(LOWER("OBR BU")) AS obr_bu, 
TRIM(LOWER("BU Defined Filter")) AS bu_defined, 
TRIM(LOWER("Site")) AS "site", 
TRIM(LOWER("METRIC TYPE")) AS metric, 
TRIM(LOWER("Incident Classification")) AS incident_classification, 

-- dates 
CAST(fiscal_year as INTEGER) AS fiscal_year, 
TRIM(period_name) as period_name, 

-- Metrics
CAST("Incidents" AS INTEGER)            AS air_incidents,
CAST("Hours" AS REAL)                   AS hours,
CAST("Rate" AS REAL)                    AS rate,
CAST("Period Over Period* (%Change)" AS REAL) AS period_over_period_pct_change

FROM raw_event_counts
WHERE "Site" IS NOT NULL;