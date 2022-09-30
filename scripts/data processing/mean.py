import numpy as np
import pandas as pd
from rpy2.robjects import r
import rpy2.robjects.pandas2ri as pandas2ri
import copy
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression

data = pd.read_csv("data\cleanedData.csv")
# display the first five rows data.head(5)

averageCrime = data.groupby(['County']).agg({'CrimesReported': ['mean']})
averageCrime.columns = ["_".join(x) for x in averageCrime.columns.ravel()]
averageCrime.reset_index

averageAid = data.groupby(['County']).agg({'AidAmount': ['mean']})
averageAid.columns = ["_".join(x) for x in averageAid.columns.ravel()]
averageAid.reset_index


perCap = data.groupby(['County']).agg({'AidAmount': ['mean'], 'Population': ['mean'], 'JailPopulation': ['mean'], 'CrimesReported': ['mean']})
perCap.columns = ["_".join(x) for x in perCap.columns.ravel()]
perCap['AidPerCap'] = perCap['AidAmount_mean'] / perCap['Population_mean']
perCap['CrimesPerCap'] = perCap['CrimesReported_mean'] / perCap['Population_mean']


perCap['AidAmount_mean'] = perCap['AidAmount_mean'].values.astype(int)
perCap['Population_mean'] = perCap['Population_mean'].values.astype(int)
perCap['JailPopulation_mean'] = perCap['JailPopulation_mean'].values.astype(int)
perCap['CrimesReported_mean'] = perCap['CrimesReported_mean'].values.astype(int)
perCap.style.set_precision(2)
perCap['AidPerCap'] = perCap['AidPerCap'].values.astype(int)


perCap.to_csv(r"C:\Users\Bruh\Desktop\CSE460\data\mean.csv", index = True, header=True)

print(perCap)





