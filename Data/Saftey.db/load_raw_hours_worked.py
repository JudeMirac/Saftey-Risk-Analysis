import sqlite3
conn = sqlite3.connect('Saftey.db') # database connection 

import pandas as pd # load dataset
df_hours = pd.read_csv('Data/hours_worked/hours_worked_daily_quicksight_2025-12-16.csv')
df_hours.to_sql('raw_hours_worked', conn, if_exists= 'replace', index = False)
 
conn.close() # close sql database 