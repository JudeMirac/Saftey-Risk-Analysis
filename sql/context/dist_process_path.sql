-- distrubution of process path by site
-- grain: site x process path

DROP VIEW IF EXISTS dist_process_path; 

CREATE VIEW dist_process_path AS
SELECT 
site, 
process_path, 
avg(incidents) as incident_avg, 
sum(incidents) as incident_count,
min(incidents) as incident_min, 
max(incidents) as incident_max, 

1.0 * sum(incidents)
    /sum(sum(incidents)) OVER (PARTITION by site)
        as pct_of_site_incidents,

1.0 * sum(ri) 
    /sum(sum(ri)) OVER (PARTITION by site)
        as pct_of_site_ri, 

1.0 * sum(msd_ri) 
    /sum(sum(msd_ri)) OVER (PARTITION by site)
      as pct_of_site_msd_ri,

1.0 * sum(dart)
    /sum(sum(dart)) OVER (PARTITION by site)
        as pct_of_site_dart

FROM stg_process_path
WHERE site IS NOT NULL 
GROUP BY site, process_path; 

