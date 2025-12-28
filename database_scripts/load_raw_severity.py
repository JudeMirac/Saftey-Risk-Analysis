import sqlite3 # bring in sql 
conn = sqlite3.connect('database/Safety.db') # connect to database 

import pandas as pd # load dataset 
df_severity = pd.read_csv('Data/saftey_events/safety_events_by_severity_weekly_quicksight_2025-12-22.csv') #data
df_severity.to_sql('raw_severity_level', conn, if_exists = 'replace', index = False) # create table 

conn.close() # close connection 
