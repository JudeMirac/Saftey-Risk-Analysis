-- distrubution of process path by site
-- grain: site x process path

DROP VIEW IF EXISTS dist_process_path; 

CREATE VIEW dist_process_path AS
SELECT 
process_path, 
incidents, 
ri,
dart,

-- Proportion of Incidents 
SUM(incidents) * 100.0 
    /SUM(SUM(incidents)) OVER ()
        as pct_of_incidents, 

-- Proportion of Repetitive Injuries 
SUM(ri) * 100.0
    /SUM(SUM(ri)) OVER ()
        as pct_of_ri, 

-- Proportion of Days AWAY, Restricted, Transfered
SUM(dart) * 100.0
    /SUM(SUM(dart)) OVER ()
        as pct_of_dart

FROM stg_process_path
WHERE process_path IS NOT NULL 
GROUP BY process_path; 

