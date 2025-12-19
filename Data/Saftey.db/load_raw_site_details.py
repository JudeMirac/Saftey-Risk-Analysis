import sqlite3 # bring in sql
conn = sqlite3.connect('Saftey.db') # connect to database

import pandas as pd # load dataset
df_site = pd.read_csv('Data/dimensions/site_details_static_quicksight_2025-12-16.csv')
dd_site.to_sql('raw_site_details', conn, if_exists = 'replace', index = False)

conn.close()