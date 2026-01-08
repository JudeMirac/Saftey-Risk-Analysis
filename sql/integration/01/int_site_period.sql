-- integration: site x fiscal_year x period_name x metric x incident_classification 
-- grain: site -> fiscal_year -> period_name 

DROP VIEW IF EXISTS int_site_period_classification; 

CREATE VIEW int_site_period_classification AS
SELECT 
-- grain (which variables will be used for alignment of keys joins downstream)
site, 
fiscal_year, 
period_name,  

-- measures
sir_incidents, 
hours, 
rate, 
period_over_period_pct_change

FROM stg_event_counts
WHERE site IS NOT NULL; 



