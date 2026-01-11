-- Incident severity distribution
-- grain: severity x site 
 
DROP VIEW IF EXISTS dist_severity_level; 

CREATE VIEW dist_severity_level AS
SELECT
site, 
severity,
sum(incidents) as incident_count,
AVG(incidents) as incident_avg, 
min(incidents) as incident_min, 
max(incidents) as incident_max, 

1.0 * sum(ri)
    /sum(sum(ri)) OVER (PARTITION by site) 
         AS pct_of_site_ri,

1.0 * sum(incidents) 
    /SUM(SUM(incidents)) OVER (PARTITION by site)
        AS pct_of_site_incidents,

1.0 * sum(msd_ri)
    /sum(sum(msd_ri)) OVER (PARTITION by site)
        AS pct_of_site_msd_ri,

1.0 * sum(dart)
    /SUM(SUM(dart)) OVER (PARTITION by site)
        AS pct_of_site_dart

FROM stg_severity_level 
WHERE site IS NOT NULL
GROUP BY site, severity; 