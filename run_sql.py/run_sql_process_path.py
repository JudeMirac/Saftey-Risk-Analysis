import sqlite3 

def run_sql_file(db_path: str, sql_path: str) -> None: # connecting to db and opening sql file
    with open(sql_path, 'r', encoding = 'utf_8') as f: # open sql file in read mode and store as f object 
        sql = f.read() # store f object as sel( better for interpretability)

    with sqlite3.connect('database/Safety.db') as conn: #connect to db as conn
        conn.executescript(sql) # querry sql

    if __namme__ == '__main__':
        run_sql_file('database/Safety.db', 'sql/staged_process_path.sql')
    
    ## validation check 
import pandas as pd
with sqlite3.connect('database/Safety.db') as conn: 
    print(pd.read_sql('select count (*) from raw_process_path;', conn))
    print(pd.read_sql('select count (*) from stg_process_path;', conn))
    print(pd.read_sql('select (*) from stg_process_path limit 5;', conn))