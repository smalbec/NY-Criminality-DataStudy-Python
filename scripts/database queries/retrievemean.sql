SELECT * FROM NYAidCrimeMean WHERE County = 'Tioga'

SELECT * FROM NYAidCrimeMean WHERE crimespercap < 0.04

SELECT * FROM NYAidCrimeMean order by aidpercap asc, crimespercap asc;

SELECT CrimesReported FROM NYAidCrimeTimeSeries WHERE County = 'Allegany' AND Year = 2015

SELECT * FROM NYAidCrimeTimeSeries WHERE AidAmount < 100000000

SELECT * FROM NYAidCrimeTimeSeries WHERE Year > 2013 AND Year < 2018 order by JailPopulation asc;
