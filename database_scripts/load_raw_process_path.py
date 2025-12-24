import sqlite3 # bring in sql
conn = sqlite3.connect('database/Safety.db') # connect to database

import pandas as pd # load dataset
df_process = pd.read_csv('Data/safety_events/safety_events_by_process_weekly_qiuicksight_2025-12-16.csv') # data
df_process.to_sql('raw_process_path', conn, if_exists = 'replace', index = False) # create table 

conn.close() # close connection 