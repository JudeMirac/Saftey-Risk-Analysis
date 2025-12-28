import sqlite3

def run_file_sql(db_path: str, sql_path: str) -> None: # function for connecting to db and opening sql file
    with open(sql_path, 'r', encoding = 'utf_8') as f: # open sql file in read model
        sql = f.read() # storing f object as a 
    
    with sqlite3.connect('database/Saftey.db') as conn: # connect to db as conn
        conn.executescript(sql) # querry sql file

if __name__ == '__main__': # activates when you run sql in py
    run_file_sql('database/Safety.db', 'sql/staged_severity_level.sql')

# validation check 
import pandas as pd
with sqlite3.connect('database/Safety.db') as conn: 
    print(pd.read_sql('select count (*) from raw_severity_level;', conn))
    print(pd.read_sql('select count (*) from stg_severity_level;', conn))
    print(pd.read_sql('select * from stg_severity_level limit 5;', conn))

