import sqlite3

def run_sql_file(db_path: str, sql_path: str) -> None:  #create function for connecting to db and opening sql file
    with open(sql_path, 'r', encoding = 'utf_8') as f: 
        sql = f.read(). 

    with sqlite3.connect('database/safety.db') as conn:
        conn.executescript(sql)

    if __name__ == '__main__': 
        run_sql_file('database/safety.db', 'sql/staged_event_counts.sql')


