import numpy as np
import pandas as pd

jail = pd.read_csv("cool.csv")

len(jail.columns)

jail = jail.drop(['Boarded Out',"Boarded In", 'in-House Census', 'Sentenced', 'Civil', 'Federal', 'Technical Parole Violators', 'State Readies', 'Other Unsentenced'], axis = 1)

jail = jail[jail['Facility Name'] != 'All Non-NYC Facilities']

jail = jail[jail['Facility Name'] != 'All NYC Facilities']

jail = jail[jail['Year'] >= 2010]

jail = jail[jail['Year'] <= 2019]

jail = jail.rename({'Facility Name': 'County', 'Census': 'Jail Population'}, axis = 1)

jail.dropna()

jail = jail.groupby(['County','Year'])['Jail.Population'].sum()

jail.to_csv(r"C:\Users\Bruh\Desktop\CSE487\Phase 1\data\processedData\jail.csv", index = True, header=True)

print(jail)


