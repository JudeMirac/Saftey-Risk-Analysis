-- feature build out for the process path x weekly exposure 
-- KPI: Incidents + YTD metrics  
-- Trend: Rolling weekly incidents + hours 
-- signal: NWeekly incident rate/ hours + normalized rates  

DROP VIEW IF EXISTS feat_site_week_hours_path_risk; 

CREATE VIEW feat_site_week_hours_path_risk AS
with base AS (
    SELECT 
    site, 
    fiscal_year, 
    week_sum, 
    incidents as incidents_ytd, -- KPI (cumalative incidents)
    fclm_hours, -- signal
    process_path -- KPI

FROM int_site_week_hours_path),

base_weekly AS (
select *,

-- incidents metric is a running total/cumalative results, this is unefficient when it comes to analysis. 
-- Convert cumalative incidents metric into a weekly delata 
-- weekly delta = cumalative incidents current week - cumalative incidents privous week

    (incidents_ytd - LAG(incidents_ytd, 1, 0) OVER 
        (PARTITION by site, fiscal_year, process_path
            ORDER by week_sum) 
                )as incidents_weekly

FROM base), 
    

rolling AS ( 
    select *,  
        avg(fclm_hours) over            -- Rolling Hourly averages over 4 weeks (Trend)
            (PARTITION by site, fiscal_year, process_path
                ORDER BY fiscal_year, week_sum
                    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
                        as avg_hours_per_path,  

 
        avg(incidents_weekly) over    -- Average incident over 4 weeks (TREND)
            (PARTITION by site, fiscal_year, process_path
                ORDER BY fiscal_year, week_sum
                 ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) 
                    as avg_incident_per_path, 

    SQRT(
        AVG(fclm_hours * fclm_hours) OVER                -- rolling deviation over 4 weeks for fclm hours (Trend) 
            (PARTITION by process_path
                ORDER by week_sum 
                    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        )
        -
        (
            AVG(fclm_hours) OVER 
                (PARTITION BY process_path
                    ORDER BY week_sum
                        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        )
        *
            AVG(fclm_hours) OVER 
                (PARTITION BY process_path
                    ORDER BY week_sum 
                        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
                            ) AS fclm_hours_4wk_std,


    SQRT(
        AVG(incidents_weekly * incidents_weekly) OVER -- Standard deviation over 4 week averages for incidents (TREND) 
            (PARTITION by process_path
                ORDER BY fiscal_year, week_sum
                    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) 
        -
        ( 
        AVG(incidents_weekly) OVER 
            (PARTITION by process_path
                ORDER BY fiscal_year, week_sum
                    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW 
        )
        *
        AVG(incidents_weekly) OVER 
            (PARTITION by process_path
                ORDER BY fiscal_year, week_sum
                    ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
                )
            )
        ) AS incident_4wk_std

FROM base_weekly), 

rates AS (

    select *,                       
    -- normalized rate  
     --- signal Incidents per 1000 hours
        incidents_weekly * 1000.0/nullif(fclm_hours, 0)   --- Incidents per 1000 hours 
            as incidents_per_1k_hours, 

    -- deviation for the norm 
    -- Trend (This flags week where hours are unusual relative to history) 
    (fclm_hours - avg_hours_per_path) as hours_deviation, -- signal (This flags week where hours are unusual relative to history) 

    -- Percent deviation 
    -- Trend (This gives a scaled percentage output on whether the week is above or under the normal in terms of hours 
    (fclm_hours - avg_hours_per_path * 1.0/nullif(avg_hours_per_path, 0) as deviation_pct 

    

FROM rolling), 

ranked AS (
    SELECT *, 
    -- Rank top path by desceding order
        RANk () OVER 
            (PARTITION by site, fiscal_year, week_sum 
                ORDER by incidents_per_1k_hours DESC)            
                    AS process_path_rank 
FROM rates)

SELECT *,  

CASE       -- display the top 3 process path for incidents  
    WHEN process_path_rank <= 3 THEN 1 ELSE 0 END AS top_3_flag_path, 

CASE       -- find weeks where incidents dropped 
    When incidents_weekly < avg_incident_per_path THEN 1 ELSE 0 END AS incident_drop,

CASE       -- find week where incidents spiked 
    WHEN incidents_weekly > avg_incident_per_path THEN 1 ELSE 0 END AS incident_spike, 

CASE       -- flag weeks where hours dropped
    WHEN fclm_hours <  avg_hours_per_path THEN 1 ELSE 0 END AS hours_drop, 

CASE       -- alert weeks where hours spiked 
    WHEN fclm_hours > avg_hours_per_path THEN 1 ELSE 0 END AS hours_spike
 
FROM ranked;                                      


