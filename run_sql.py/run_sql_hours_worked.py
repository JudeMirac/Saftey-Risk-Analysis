import sqlite3

def run_sql_file(db_path: str, sql_path: str) -> None: # # bridges path to database and sql file
    with open(sql_path,'r', encoding = 'utf-8') as f: # open sql file in read mode and assigns file to f obejct 
        sql = f.read() # turns f object into sql (better for interpretability) and reads entire sql file into memory 

    with sqlite3.connect(db_path) as conn:
        conn.executescript(sql) # connects to database, stores it as conn obeject and executes query 
    
if __name__ == '__main__': # block runs only when you run python run_sql_py
    run_sql_file('database/Safety.db', 'sql/staged_hours_worked.sql') # connects to db and passes function



## validate 
import pandas as pd 
with sqlite3.connect('database/Safety.db') as conn:
    print(pd.read_sql('select count(*) as raw_rows from raw_hours_worked;', conn))
    print(pd.read_sql('select count (*) as stg_hours from stg_hours_worked;', conn))
    print(pd.read_sql('select * from stg_hours_worked;', conn))