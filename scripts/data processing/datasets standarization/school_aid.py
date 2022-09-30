import numpy as np
import pandas as pd

school_aid = pd.read_csv("data/New_York_State_School_Aid__Beginning_School_Year_1996-97.csv")

len(school_aid.columns)

school_aid = school_aid.drop(["BEDS Code", 'District', 'Base Year', 'Change', '% Change'], axis = 1)

school_aid['Event'] = school_aid['Event'].str[:4].astype(int)

school_aid = school_aid[school_aid['Aid Category'] == 'Sum of Above Aid Categories']

school_aid = school_aid.drop(['Aid Category'], axis = 1)

school_aid = school_aid.rename({'Event': 'Year', 'School Year': 'Aid Amount'}, axis = 1)

school_aid = school_aid[school_aid['Year'] >= 2009]

school_aid = school_aid[school_aid['Year'] <= 2019]

# school_aid['Year'] = school_aid.loc[['Year']== 2009] = 2010

school_aid['Year'] = school_aid['Year'].replace([2009],2010)

school_aid = school_aid.groupby(['County','Year'])['Aid Amount'].sum()

school_aid.dropna()

school_aid.to_csv(r"C:\Users\Bruh\Desktop\CSE487\Phase 1\data\processedData\schoolAid.csv", index = True, header=True)

print(school_aid)
