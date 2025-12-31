import sqlite3 # bring in sql
conn = sqlite3.connect('database/Safety.db') # connection to db 
import pandas as pd # load dataset
df_counts = pd.read_csv('Data/exposure/safety_event_counts_2025-12-16.csv') 
df_counts.to_sql('raw_event_counts', conn, if_exists = 'replace', index = False) # create table 

conn.close() # close database