-- Incident severity distribution
-- grain: severity x site 
 
DROP VIEW IF EXISTS dist_severity_level; 

CREATE VIEW dist_severity_level AS
SELECT
severity,
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

-- Proportion of Days Away, Restricted, Transfered
SUM(dart) * 100.0
    /SUM(SUM(dart)) OVER ()
        as pct_of_dart

FROM stg_severity_level 
WHERE severity IS NOT NULL
GROUP BY severity; 