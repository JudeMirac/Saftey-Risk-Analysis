import sqlite3

def run_sql_file(db_path: str, sql_file: str) -> None:
    with open(sql_file, "r", encoding="utf-8") as f:
        sql = f.read()

    with sqlite3.connect(db_path) as conn:
        conn.executescript(sql)

    print(f"Executed {sql_file}")

if __name__ == "__main__":
    # ---- STAGING (standardize tables for futher manipulation) -- 
    run_sql_file('database/Safety.db', "sql/staging/staged_hours_worked.sql")
    run_sql_file('database/Safety.db','sql/staging/staged_site_details.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_event_counts.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_process_path.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_severity_level.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_contributing_factors.sql')
    run_sql_file('database/Safety.db', 'sql/staging/staged_path_rate.sql')
    run_sql_file('database/Safety.db', 'sql/staging/staged_root_cause.sql')

    # ---- INTEGRATION (creation of a unified dataset using specific mapping) -- 
    run_sql_file('database/Safety.db',"sql/integration/01/int_site_period.sql") #
    run_sql_file('database/Safety.db', 'sql/integration/week_mapping.sql')
    run_sql_file('database/Safety.db', 'sql/integration/02/int_site_week_hours.sql')
    run_sql_file('database/Safety.db', 'sql/integration/03/int_site_process_path.sql')
    run_sql_file('database/Safety.db', 'sql/integration/03/int_site_week_hours_process_path.sql')

    # ---- Context Layer (proportion of incidents per categoru) Why incidents happen ? 
    run_sql_file('database/Safety.db', 'sql/context/dist_root_cause.sql')
    run_sql_file('database/Safety.db', 'sql/context/dist_process_path.sql')
    run_sql_file('database/Safety.db', 'sql/context/dist_contributing_factors.sql')
    run_sql_file('database/Safety.db', 'sql/context/dist_by_severity_level.sql')

    # --- Features within all incidents and incidents filtered by process path dataset
    run_sql_file('database/Safety.db', 'sql/features/feat_site_week_hours_risk.sql')
    run_sql_file('database/Safety.db', 'sql/features/feat_site_week_hours_path_risk.sql')

    print("Pipeline run complete.") # confirmation sql files are correct 

import pandas as pd 
with sqlite3.connect('database/Safety.db') as conn:
  
  table = pd.read_sql('select name from sqlite_master Where type = "table";', conn )
  print(table)

  QA_1 = pd.read_sql('select * from int_site_period_week_hours_path;', conn)
  print(f'All incidents and exposure filtered by process path dataset {QA_1.columns}')

  QA_2 = pd.read_sql('select * from int_site_week_hours;', conn)
  print(f'all incidents x exposure dataset {QA_2.columns}')

  QA_3 = pd.read_sql('select * from feat_site_week_hours_risk;', conn)
  print(f'Features for all incidents and exposure dataset {QA_3.head}')

  QA_4 = pd.read_sql('select * from feat_site_week_hours_path_risk;', conn)
  print(f'select * from feat_site_week_hours_path_risk {QA_4.head}')
  print(f'select * from feat_ ')