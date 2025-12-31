import sqlite3

def run_sql_file(db_path: str, sql_file: str) -> None:
    with open(sql_file, "r", encoding="utf-8") as f:
        sql = f.read()

    with sqlite3.connect(db_path) as conn:
        conn.executescript(sql)

    print(f"Executed {sql_file}")

if __name__ == "__main__":
    # ---- STAGING ----
    run_sql_file('database/Safety.db', "sql/staging/staged_hours_worked.sql")
    run_sql_file('database/Safety.db','sql/staging/staged_site_details.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_event_counts.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_process_path.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_severity_level.sql')
    run_sql_file('database/Safety.db','sql/staging/staged_contributing_factors.sql')

    # ---- INTEGRATION (just added) ----
    run_sql_file('database/Safety.db',"sql/integration/01/int_site_period_classification.sql")
    run_sql_file('database/Safety.db', 'sql/integration/QA_1.sql')
    run_sql_file('database/Safety.db', 'sql/integration/week_mapping.sql')
    run_sql_file('database/Safety.db', 'sql/integration/02/int_site_week_hours.sql')

    print("Pipeline run complete.")