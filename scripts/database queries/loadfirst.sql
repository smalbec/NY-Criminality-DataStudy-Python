COPY NYAidCrimeMean (County,AidAmount_mean,Population_mean,JailPopulation_mean,CrimesReported_mean,AidPerCap,CrimesPerCap)
FROM 'C:\Users\Bruh\Desktop\CSE460\data\mean.csv'
DELIMITER ','
CSV HEADER;

COPY nyaidcrimetimeseries (County,Year,AidAmount,Population,JailPopulation,CrimesReported)
FROM 'C:\Users\Bruh\Desktop\CSE460\data\cleanedData.csv'
DELIMITER ','
CSV HEADER;