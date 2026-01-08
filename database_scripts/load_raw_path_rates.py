import sqlite3 # bring in sql
conn = sqlite3.connect('database/Safety.db') # connect to db

import pandas as pd # bring in pandas and import dataset 
df_path_rate = pd.read_csv('Data/hours_worked/path_rates_quicksuite_01-05-2026.csv')
df_path_rate.to_sql('raw_path_rates', conn, if_exists= 'replace', index = False)

