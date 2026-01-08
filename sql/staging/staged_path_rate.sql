-- staging process path rates per week

DROP VIEW IF EXISTS stg_path_rates; -- greate for rerunning pipelines 

CREATE VIEW stg_path_rates AS
SELECT 
TRIM(LOWER("OBR BU")) as obr_bu,
TRIM(LOWER("BU Defined Filter 2")) as bu_defined_filter_2,
TRIM(LOWER("BU Defined Filter 3")) as bu_defined_filter_3,
TRIM(LOWER(Site)) as site, 
TRIM(LOWER("Process Path")) as process_path, 
CAST(FY as INTEGER) as year,
CAST("period name" as INTEGER) as period_name, 
CAST(Incidents as INTEGER) as incidents, 
CAST("%Incidents" as REAL) as incident_pct, 
CAST("FCLM Hours" as REAL) AS fclm_hours, 
CAST("%FLCM Hours" as REAL) as fclm_hours_pct, 
CAST(AIR as REAL) as air

FROM raw_path_rates
WHERE site IS NOT NULL; 



