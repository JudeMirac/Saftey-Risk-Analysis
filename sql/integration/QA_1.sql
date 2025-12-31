
-- QA basic row count 
SELECT count (*) as rows
FROM int_site_period_classification;

-- QA check for null key joins (anyting > 0 would mean logic needs fixing upstream) 
SELECT 
SUM(CASE WHEN site IS NULL OR site = '' THEN 1 ELSE 0 END) as null_site, 
SUM(CASE WHEN fiscal_year IS NULL OR fiscal_year = '' THEN 1 ELSE 0 END) as null_fiscal_year, 
SUM(CASE WHEN period_name IS NULL OR period_name = '' THEN 1 ELSE 0 END) as null_period_name
FROM int_site_period_classification; 

-- QA check for duplicate rows 
SELECT 
site, fiscal_year, period_name, 
metric, incident_classification, 
COUNT (*) as cnt
FROM int_site_period_classification
GROUP BY site, fiscal_year, period_name, 
metric, incident_classification 
HAVING count (*) > 1 
ORDER BY cnt 
limit 20; 


