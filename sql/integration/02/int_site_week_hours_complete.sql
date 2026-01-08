-- final view for integrated safety counts and hours worked table 
-- integration; site x fiscal_year x period 
-- grain: site x year x week x hours x metrics 

DROP VIEW IF EXISTS int_site_year_week_hours_metrics; 

CREATE VIEW int_site_year_week_hours_metrics AS 
SELECT 
site, 
fiscal_year, 
period_name, 
week_sum, 
sir_incidents,
hours, 
rate, 
period_over_period_pct_change, 
employee_hours, 
contractor_hours, 
total_hours_worked

FROM int_site_week_hours 
WHERE site IS NOT NULL; 
