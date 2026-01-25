-- distribution of root_cause by site 
-- grain: root cause x incidents 

DROP VIEW IF EXISTS dist_root_cause; 

CREATE VIEW dist_root_cause AS
select 
root_cause,
incidents,
ri, 
dart,
-- proportion of incidents
sum(incidents) * 100.0              
    /sum(sum(incidents)) OVER ()
        as pct_of_incidents, 

-- proportion of Repetitive injuries  
sum(ri) * 100.0
    /sum(sum(ri)) OVER ()
        as pct_of_ri,

-- Proportion of Days Away Restricted or Tranfered 
sum(dart) * 100.0 
    /sum(sum(dart)) OVER ()
        as pct_of_dart 

FROM stg_root_cause
WHERE root_cause IS NOT NULL
GROUP BY root_cause; 

