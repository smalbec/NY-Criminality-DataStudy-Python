import numpy as np
import pandas as pd

crimes = pd.read_csv("cool.csv")

len(crimes.columns)

crimes["Crimes.Reported"] = crimes["Index Total"]+ crimes["Burglary"]+crimes["Larceny"]+crimes["Motor Vehicle Theft"]


crimes = crimes.drop(['Months Reported',"Violent Total", 'Murder', 'Rape', 'Robbery', 'Aggravated Assault', 'Property Total', 'Region','Index Total','Burglary','Larceny','Motor Vehicle Theft'], axis = 1)

crimes = crimes[crimes['Agency'] == 'County Total']

crimes = crimes.drop('Agency', axis=1)

crimes = crimes[crimes['Year'] >= 2010]

crimes = crimes[crimes['Year'] <= 2019]

crimes.dropna()

crimes.to_csv(r"C:\Users\Bruh\Desktop\CSE487\Phase 1\data\processedData\crimes.csv", index = False, header=True)



print(crimes)

