import pandas as pd
df = pd.read_csv('data/cleanedData.csv')
df['AidAmount'] = df['AidAmount'].values.astype(int)
df['CrimesReported'] = df['CrimesReported'].values.astype(int)
df.to_csv('data/cleanedData.csv', index=False)


