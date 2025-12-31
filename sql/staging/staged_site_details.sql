-- staging for site details 

DROP VIEW IF EXISTS stg_site_details; -- This is the standard for re runnning analytical pipelines 

CREATE VIEW stg_site_details AS 
-- standardize text
SELECT
TRIM(LOWER(Site)) AS site,
TRIM(LOWER(Geo)) AS geo, 
TRIM(LOWER(Org)) AS org,
TRIM(LOWER(Scope)) AS scope, 

-- timeframes
date("Period Start") AS peiod_start,
date("Period End") AS period_end, 

-- defect exposure data 
CAST("TDR out" AS REAL)  AS TDR_out,      
CAST("Total Defects" AS INTEGER) AS total_defects,
CAST(DPMO AS REAL) AS DPMO

FROM Raw_site_details 
WHERE Site IS NOT NULL;


