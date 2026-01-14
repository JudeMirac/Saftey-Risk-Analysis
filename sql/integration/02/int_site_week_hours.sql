-- integration: site x fiscal year x week exposure + incidents + hours worked
-- grain: site, fiscal year, period name, metric, incident_classification 

DROP VIEW IF EXISTS int_site_week_hours; 

CREATE VIEW int_site_week_hours AS 
SELECT
e.site, 
e.fiscal_year, 
e.period_name, 
w.week_sum, 

-- measures
e.air_incidents, 
e.hours, 
e.rate,
e.period_over_period_pct_change,

-- catch any null fields automatically 
CASE WHEN h.total_hours IS NULL THEN 1 ELSE 0 END as missing_flag_hours, 

-- exposure (hours worked) 
h.employee_hours, 
h.contractor_hours,
h.total_hours as total_hours_worked

FROM int_site_period_classification e

left join week_mapping w
on w.fiscal_year = e.fiscal_year
and w.period_name = e.period_name   

left join stg_hours_worked h
on h.site = e.site
and h.year = e.fiscal_year
and h.period = w.week_sum; 

