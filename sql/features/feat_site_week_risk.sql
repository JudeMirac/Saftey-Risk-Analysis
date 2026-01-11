-- feature build out for sir incidents x exposure dataset 

DROP VIEW IF EXISTS feat_site_week_risk; -- drppoing a table is standard for rerunning pipelines 



CREATE VIEW feat_site_week_risk AS
WITH base AS (                  -- Creation of base columns 
    select
    site, fiscal_year,
    week_sum, sir_incidents, 
    total_hours_worked, rate
FROM int_site_week_hours 
), 

rolling AS (                   -- Rolling features
    select 
    *,                          -- select * brings forward all columns from base
    avg(incident) OVER (
        PARTITION by site
        ORDER BY fiscal_year, week_sum
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) as incident_4wk_avg,

rolling AS (
    avg(incident) OVER (
        PARTITION BY site
        ORDER BY ficsal_year, week_sum
        ROWS BETWEEN 3 PRECEDING and CURRENT ROW
    ) as incident_4wk_avg,

    avg(rate) OVER (
        PARTITION by site 
        ORDER BY fiscal_year, week_sum
        ROWS BETWEEN 3 PRECEDING and CURRNT ROW
    ) as rate_4wk_avg, 

    STDDEV(incidents) OVER (
        PARTITION by site)
        ORDER BY fiscal_year, week_sum
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) as incident_4wk_std
FROM base

-- normalized risk features 


