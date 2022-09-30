import pandas as pd

df = pd.read_csv('data/cleanedData.csv')

df = df.head(30)

df.to_csv('data/sampleData.csv', index=False)




