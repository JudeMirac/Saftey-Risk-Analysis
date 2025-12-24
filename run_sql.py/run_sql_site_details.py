import sqlite3

def run_sql_file(db_path: str, sql_path: str) -> None: # function for connecting to database and running sql file
    with open(sql_path, 'r', encoding = 'utf-8') as f: # opens sql file in read mode and stores it as an f object
        sql = f.read() # stores f read in sql object 
    
    with sqlite3.connect('database/Safety.db') as conn: # this tells the functuon to connect to the database and store it in conn object
        conn.executescript(sql) # conn is then exected as an sql querry 

if __name__ == '__main__': # this block is for when we run python script
    run_sql_file('database/Safety.db', 'sql/staged_site_details.sql')

# validation check 
import pandas as pd 
with sqlite3.connect('database/Safety.db') as conn:
    print(pd.read_sql('select count (*) from raw_site_details;', conn))
    print(pd.read_sql('select count (*) from stg_site_details', conn))
    print(pd.read_sql('select * from stg_site_details limit 5;', conn))