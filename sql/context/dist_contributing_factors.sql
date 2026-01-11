-- distribution of contributing factors by site

DROP VIEW IF EXISTS dist_contributing_factors; 

CREATE VIEW dist_contributing_factors AS
SELECT
site, 
factor, 
sum(incidents) as incident_count, 
avg(incident) as incident_avg,
min(incident) as incident_min, 
max(incident) as incident_max, 

1.0 * sum(incident) 
    /sum(sum(incident)) OVER (PARTITION by site) 
        as pct_of_site_incidents,
1.0 * sum(ri)
    /sum(sum(ri)) OVER (PARTITION by site) 
        as pct_of_site_ri, 
1.0 * sum(msd_ri) 
    /sum(sum(incident)) OVER (PARTITION by site)
        as pct_of_site_msd_ri, 
1.0 * sum(dart)
    /sum(sum(dart)) OVER (PARTITION by site) 
        as pct_of_site_dart

FROM stg_contributing_factors 
WHERE site IS NOT NULL
GROUP BY site, factors; 

