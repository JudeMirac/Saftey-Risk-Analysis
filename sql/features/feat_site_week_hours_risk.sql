-- features build out for all incidents x exposure dataset 

DROP VIEW IF EXISTS feat_site_week_hours_risk; 
-- import out view for downstream feature engineering 
CREATE VIEW feat_site_week_hours_risk AS
WITH base AS (
SELECT
site, 
fiscal_year, 
week_sum, 
air_incidents,  
rate, 
hours, 
total_hours_worked, 
employee_hours

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
       ORDER BY week_sum)) as incidents_weekly,
       
       (hours - LAG(hours, 1, 0) OVER                 
       (PARTITION by site, fiscal_year              
       ORDER by week_sum)) as hours_weekly,   

        (total_hours_worked - LAG(total_hours_worked, 1, 0) OVER 
        (PARTITION by site, fiscal_year
        ORDER BY week_sum)) as total_hours_worked_weekly,

        (employee_hours - LAG(employee_hours, 1, 0) OVER
        (PARTITION by site, fiscal_year
        ORDER by week_sum)) as employee_hours_weekly

FROM base), 
                                                        
rolling AS (    
    SELECT 
        *, 
        AVG(incidents_weekly) OVER -- rolling incidents 4wk time frame 
        (PARTITION by site
        ORDER BY week_sum 
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
            AS incidents_4wk_avg, 

        AVG(rate) OVER -- average 4wk rate 
        (PARTITION by site
        ORDER by week_sum
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
            AS rate_4wk_avg,

        AVG(hours_weekly) OVER -- rolling hours 4wk time frame 
        (PARTITION by site
        ORDER by week_sum
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW)
            AS hours_4wk_avg, 

        SQRT (                             -- standard deviation 4wk rolling 
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


CASE     -- When weekly hours is greater than 0 Logic: display as hours_worked (Hours that have not been adjusted, removed, corrected)
    WHEN hours_weekly >= 0 THEN hours_weekly ELSE 0 END as hours_worked, 
CASE     -- If weekly hours is less than 0 Logic: Hours have been adjusted, removed, corrected for that week. 
    WHEN hours_weekly < 0 THEN hours_weekly ELSE 0 END as hours_adjusted
            
FROM base_weekly

) 

SELECT *, 
-- normalized risk
    incidents_weekly * 10000.0/nullif(total_hours_worked_weekly, 0)
        as incident_per_10k_hours,

    total_hours_worked_weekly * 1.0/nullif(incidents_weekly, 0)
     as hours_per_incident, 

CASE 
    WHEN incidents_weekly  > incidents_4wk_avg THEN 1 ELSE 0    --logic: if incidents exceed over incident 4wk average flag spike 
        END as incident_spike_flag 


FROM rolling; 


