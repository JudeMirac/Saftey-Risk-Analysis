-- distribution of contributing factors by site

DROP VIEW IF EXISTS dist_contributing_factors; 

CREATE VIEW dist_contributing_factors AS
SELECT
contributing_factor,
incidents, 
ri, 
dart,  

-- Proportion of Incidents 
100.0 * sum(incidents) 
    /sum(sum(incidents)) OVER () 
        as pct_of_site_incidents,

-- Proportion of Repetitive Injuries 
100.0 * sum(ri)
    /sum(sum(ri)) OVER () 
        as pct_of_site_ri, 

-- Proportion of Days Away, Restricted, Transfered 
100.0 * sum(dart)
    /sum(sum(dart)) OVER ()
        as pct_of_site_dart

FROM stg_contributing_factors 
WHERE contributing_factor IS NOT NULL
GROUP BY contributing_factor; 

