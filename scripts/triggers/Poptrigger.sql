CREATE or replace FUNCTION update_PopulationMean() RETURNS trigger AS
  $BODY$  
BEGIN
  UPDATE NYAidCrimeMean
  set Population_mean = sub_q.newpopmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean, CrimesPerCap = sub_q.newcrimemean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean, avg(new.CrimesReported) as newcrimemean from NYAidCrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_PopulationMean_after_update
AFTER UPDATE 
ON NYAidCrimeTimeSeries
FOR EACH ROW
EXECUTE PROCEDURE update_PopulationMean(); 
 