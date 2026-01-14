-- feature build out for the process path x weekly exposure 

DROP VIEW IF EXISTS feat_site_week_hours_path_risk; 

CREATE VIEW feat_site_week_hours_path_risk AS
with base AS (
    SELECT 
    site, 
    fiscal_year, 
    week_sum, 
    incidents, 
    fclm_hours, 
    process_path 
FROM int_site_week_hours_path),

rolling AS ( 
    select *,  
        avg(fclm_hours) over            -- avg amount of hour per process path 
        (PARTITION by process_path
            ORDER BY fiscal_year, week_sum)
                as avg_hours_per_path, 

        avg(incidents) over         
            (PARTITION by process_path
            ORDER BY fiscal_year, week_sum) 
                as avg_incident_per_path, 

    SQRT(
        AVG(incidents * incidents) OVER -- standard deviation 4wk rolling 
            (PARTITION by process_path
            ORDER BY fiscal_year, week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        ) 
        -
        ( 
        AVG(incidents) OVER 
            (PARTITION by process_path
            ORDER BY fiscal_year, week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW 
        )
        *
        AVG(incidents) OVER 
            (PARTITION by process_path
            ORDER BY fiscal_year, week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
        )
    )
) AS incident_4wk_std

FROM base), 

ranked AS (                 
    select *,                       
        incidents * 10000.0/nullif(fclm_hours, 0)   --- incidents per 10000 hours 
            as incidents_per_10k_hours, 

        RANk () OVER 
            (PARTITION by site,           
            fiscal_year, week_sum 
            ORDER by incidents DESC)            -- rank top path by desceding order
                as process_path_rank 
FROM base)

SELECT *, -- display the top 3 process path for incidents  
CASE                   
    WHEN process_path_rank <= 3 THEN 1 ELSE 0 END AS top_3_flag_path        
FROM ranked;                                      





