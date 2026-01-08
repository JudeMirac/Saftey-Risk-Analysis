-- integration: site x fiscal year x period x process path
-- grain: 1 row per site per fiscal year per period name per process path

DROP VIEW IF EXISTS int_site_period_process_path; 

CREATE VIEW int_site_period_process_path as 
SELECT
site, 
period_name, 
year, 
incidents, 
incident_pct, 
fclm_hours, 
fclm_hours_pct, 
process_path

FROM stg_path_rates
WHERE site IS NOT NULL; 

