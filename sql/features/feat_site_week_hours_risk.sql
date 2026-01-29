-- features build out for all incidents x exposure dataset 
-- Output indicators: 
--  KPI: YTD metircs 
--  Signal: Weekly incident rate/hours + weekly normalized rates
--  Trend: Rolling averages + Rolling standard deviation (volatility over time) 

DROP VIEW IF EXISTS feat_site_week_hours_risk; 
-- import out view for downstream feature engineering 
CREATE VIEW feat_site_week_hours_risk AS
WITH base AS (
SELECT
site, 
fiscal_year, 
week_sum, 
air_incidents,  -- KPI
rate as ytd_rate,  -- cumulative rate (kPI) cumalative incidents * 200,000/ culmaltive hours 
hours as hours_ytd -- KPI

FROM int_site_week_hours
), 

base_weekly AS (
    SELECT *, 
-- Currently our data is cumalative/runnning total based. We need to incidents and hours that occured for the specific week
-- weekly_data = cumulative this week - cumulative last week

-- lag: 1 = go back one row
-- lag: 0 = if there is no previous row, use 0 instead

       (air_incidents - LAG(air_incidents, 1, 0) OVER   
       (PARTITION by site, fiscal_year 
       ORDER BY week_sum)) as incidents_weekly,  -- signal 

       (hours_ytd - LAG(hours_ytd, 1, 0) OVER                 
       (PARTITION by site, fiscal_year              
       ORDER by week_sum)) as hours_weekly   -- signal 

FROM base), 
                                                        
rolling AS (    
    SELECT 
        *, 
        AVG(incidents_weekly) OVER -- rolling incidents 4wk time frame (Trend)
        (PARTITION by site
        ORDER BY week_sum 
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
            AS incidents_4wk_avg, 

        AVG(hours_weekly) OVER -- rolling hours 4wk time frame (Trend)
        (PARTITION by site
        ORDER by week_sum
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
            AS hours_4wk_avg, 

        SQRT (                             -- standard deviation 4wk rolling (Trend)
            AVG(incidents_weekly * incidents_weekly) OVER
            (PARTITION by site 
            ORDER by week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW 
            )
            -
            (
            AVG(incidents_weekly) OVER 
            (PARTITION by site 
            ORDER by week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW 
            )
            * 
            AVG(incidents_weekly) OVER 
            (PARTITION by site 
            ORDER BY week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
            )
        )
    ) as incidents_4wk_std, 

        SQRT (
            AVG(hours_ytd * hours_ytd) OVER     -- standard deviation of hours over 4 week period (Trend)
            (PARTITION BY site
            ORDER BY week_sum 
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
            )
            -
            (
            AVG(hours_ytd) OVER 
            (PARTITION by site
            ORDER BY week_sum 
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW 
            )
            * 
            AVG(hours_ytd) OVER 
            (PARTITION by site
            ORDER BY week_sum
            ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
            )
        )
    ) as hours_4wk_std

FROM base_weekly
)

SELECT *, 
-- normalized rates
    incidents_weekly * 10000.0/nullif(hours_weekly, 0) -- incident rate per week (signal)
        as incidents_per_10k_hours_rate,

    hours_weekly * 1.0/nullif(incidents_weekly, 0) -- hour per weekly ncident rate (signal)
     as hours_per_incident_rate,

-- deviation from recent baseline 
     (hours_weekly - hours_4wk_avg) as hours_deviation, -- trend (This flags weeks where hours are unusual or higher relative to history)

-- percent deviation  
(hours_weekly - hours_4wk_avg) * 1.0/nullif(hours_4wk_avg, 0) AS hours_deviation_pct, -- Trend (This gives a scaled percentage output of whether the week is above or below the norm in terms of hours 

-- z score 
(hours_weekly - hours_4wk_avg) * 1.0/nullif(hours_4wk_std, 0) AS hours_zscore_4wk, -- Trend (Calculates how many deviations away from norm)

-- flags
CASE 
    WHEN incidents_weekly  >= incidents_4wk_avg THEN 1 ELSE 0  --logic: if incidents exceed over incident 4wk average flag spike (signal)
        END as incident_spike_flag, 
CASE 
    WHEN hours_weekly < hours_4wk_avg THEN 1 ELSE 0 END as hours_drop_flag, -- Logic: if hours is greater than 4 week average... return 1 (signal)
CASE 
    WHEN hours_weekly > hours_4wk_avg THEN 1 ELSE 0 END as hours_spike_flag -- Logic: If hours is less than 4 week average return 1 (signal)

FROM rolling; 


