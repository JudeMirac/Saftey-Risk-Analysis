import sqlite3
import pandas as pd

with sqlite3.connect('database/Safety.db') as conn:
    print(pd.read_sql('select * from stg_event_counts where period_name is not null;', conn))