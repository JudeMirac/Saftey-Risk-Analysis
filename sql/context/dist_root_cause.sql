-- distribution of root_cause by site 
-- grain: site x root cause 

DROP VIEW IF EXISTS dist_root_cause; 

CREATE VIEW dist_root_cause AS
select 
site, 
root_cause, 
sum(incidents) as incident_count, 
AVG(incidents) as incidents_avg, 
MIN(incidents) as incidents_min, 
MAX(incidents) as incidents_max, 

1.0 * sum(incidents)
    /sum(sum(incident_count))
        as pct_of_site_incident, 
1.0 * sum(ri)
    /sum(sum(ri)) over (PARTITION by site)
        as pct_of_site_ri, 
1.0 * sum(mds_ri) 
    /sum(sum(msd_ri)) OVER (PARTITION by site)
            as pct_of_site_msd_ri,

1.0 * sum(sum(dart)) OVER (PARTITION by site)
    /sum(sum(dart)) 
        as pct_of_site_dart 

FROM stg_root_cause
WHERE site IS NOT NULL
GROUP BY site, root_cause; 

