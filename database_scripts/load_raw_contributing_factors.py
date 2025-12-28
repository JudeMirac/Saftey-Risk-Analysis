import sqlite3
conn = sqlite3.connect('database/Safety.db')

import pandas as pd 
df_contributing = pd.read_csv('Data/saftey_events/saftey_events_by_contributing_factor_2025-12-22.csv')
df_contributing.to_sql('raw_contributing_factors', conn, if_exists= 'replace', index = False)

conn.close()