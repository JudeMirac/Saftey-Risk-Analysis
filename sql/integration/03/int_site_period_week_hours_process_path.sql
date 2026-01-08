-- View: event counts x hours x process path
-- intergration: site x period x week x hours x process path 
-- grain: site x week x hours x process path

DROP VIEW IF EXISTS int_site_period_week_hours_path; 

CREATE VIEW int_site_period_week_hours_path AS 
SELECT 
-- table of contents from int_site_week_hours completed 
e.site, 
e.fiscal_year, 
e.period_name, 
e.week_sum, 
e.sir_incidents, 
e.hours, 
e.rate,
e.period_over_period_pct_change, 
e.employee_hours, 
e.contractor_hours, 
e.total_hours_worked, 

-- table of contents from int_site_period_process_path
w.incidents, 
w.incident_pct, 
w.fclm_hours, 
w.fclm_hours_pct, 
w.process_path, 
w.year

FROM int_site_year_week_hours_metrics e 

LEFT JOIN int_site_period_process_path w
ON w.site = e.site
AND w.year = e.fiscal_year
AND w.period_name = e.week_sum; 
