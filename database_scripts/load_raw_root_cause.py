import sqlite3 # bring in sql 
conn = sqlite3.connect('database/Safety.db') # connect to databse 

import pandas as pd # import dataset 
df_root_cause = pd.read_csv('Data/safety_events/safety_events_by_root_cause_week;ly_quicksight_2025-12-16.csv')
df_root_cause.to_sql('raw_root_cause', conn, if_exists = 'replace', index = False) # create table 

conn.close() # close connection 