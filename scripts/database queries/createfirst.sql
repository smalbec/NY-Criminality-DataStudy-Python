CREATE TABLE NYAidCrimeMean (
  County VARCHAR(50),
  AidAmount_mean int,
  Population_mean int,
  JailPopulation_mean int,
  CrimesReported_mean int,
  AidPerCap int,
  CrimesPerCap float,
  PRIMARY KEY (County)
)

CREATE TABLE NYAidCrimeTimeSeries (
  County VARCHAR(50),
  Year int,
  AidAmount int,
  Population int,
  JailPopulation int,
  CrimesReported int,
  PRIMARY KEY (County, year),
  FOREIGN KEY (County) REFERENCES NYAidCrimeMean (County)
)