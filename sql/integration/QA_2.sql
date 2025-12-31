-- QA period_name -> week_num parsing 
SELECT period_name, week_sum 
FROM dim_week_map 
GROUP BY period_name, week_sum  
ORDER BY week_sum; 

-- QA examples that failed to match 
SELECT site, fiscal_year, period_name, week_num, metric, incident_classification,
FROM int_site_week_exposure_with_hours
WHERE missing_flag_hours = 1
LIMIT 50; 
