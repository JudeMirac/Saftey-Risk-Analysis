import sqlite3 # bring in sql 

def run_sql_file(db_path: str, sql_file: str) -> None: # func for connecting to database and opening sql file
    with open(sql_file, 'r', encoding = 'utf_8') as f: # open sql file in read mode 
        sql = f.read() # store file in sql obejct for better interpretability 
    
    with sqlite3.connect('database/Safety.db') as conn: 
        conn.executescript(sql)
    
if __name__ == '__main__': 
    run_sql_file('database/Safety.db', 'sql/staging/staged_path_rate.sql')


import pandas as pd 
with sqlite3.connect('database/Safety.db') as conn:
    print(pd.read_sql('select * from stg_path_rates;', conn))
    print(pd.read_sql('select count (*) from stg_path_rates;', conn))