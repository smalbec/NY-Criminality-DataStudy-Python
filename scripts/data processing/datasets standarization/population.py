import numpy as np
import pandas as pd

population = pd.read_csv("data/Annual_Population_Estimates_for_New_York_State_and_Counties__Beginning_1970.csv")

len(population.columns)

population = population.drop(["FIPS Code"], axis = 1)

population = population[population['Program Type'] != 'Census Base Population']

population = population[population['Geography'] != 'New York State']

population = population.drop(["Program Type"], axis = 1)

population = population[population['Year'] >= 2010]

population = population[population['Year'] <= 2019]

population = population.rename({'Geography': 'County'}, axis = 1)

population.dropna()

population.to_csv(r"C:\Users\Bruh\Desktop\CSE487\Phase 1\data\processedData\population.csv", index = False, header=True)


print(population)