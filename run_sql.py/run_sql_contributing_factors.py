import sqlite3

def run_sql_file(db_path: str, sql_path: str) -> None: # function created to connect to db and open sql file 
    with open(sql_path, 'r', encoding= 'utf_8') as f: # open sql file in read mode and store as f obeject 
        sql = f.read() # store f objectv as sql (better for interpretability)

    with sqlite3.connect('database/Safety.db') as conn: # connecting to db 
        conn.executescript(sql) # executing sql querry

if __name__ == '__main__': 
    run_sql_file('database/Safety.db', 'sql/staged_contributing_factors.sql')

# validation check 
import pandas as pd
with sqlite3.connect('database/Safety.db') as conn: 
    print(pd.read_sql('select count (*) from raw_contributing_factors;', conn))
    print(pd.read_sql('select count (*) from stg_contributing_factors;', conn))
    print(pd.read_sql('select * from stg_contributing_factors limit 5;', conn))