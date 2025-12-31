import sqlite3
import pandas as pd 

with sqlite3.connect('database/Safety.db') as conn: 
    tables = pd.read_sql('select name from sqlite_master where type = "table";',conn)
    print(tables)