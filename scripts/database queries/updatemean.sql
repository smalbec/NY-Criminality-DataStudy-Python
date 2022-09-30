UPDATE NYAidCrimeMean WHERE
SET AidAmount = 1
WHERE County = 'Albany'

UPDATE NYAidCrimeTimeSeries
SET AidAmount = 1
WHERE County = 'Broome' AND Year = 2010;