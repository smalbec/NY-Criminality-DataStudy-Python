COPY nyaidcrimetimeseriesSample (County,Year,AidAmount,Population,JailPopulation,CrimesReported)
FROM 'C:\Users\Bruh\Desktop\CSE460\data\sampleData.csv'
DELIMITER ','
CSV HEADER;