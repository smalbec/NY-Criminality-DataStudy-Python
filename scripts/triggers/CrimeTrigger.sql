CREATE or replace FUNCTION update_CrimesMean() RETURNS trigger AS
  $BODY$  
BEGIN
  UPDATE NYAidCrimeMean
  set CrimesReported_mean = sub_q.newcrimesmean, crimesPerCap = sub_q.newcrimesmean / sub_q.newpopmean
  from (select avg(new.crimesReported) as newcrimesmean, avg(new.population) as newpopmean from NYaidcrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_CrimesMean_after_update
AFTER UPDATE 
ON NYAidCrimeTimeSeries
FOR EACH ROW
EXECUTE PROCEDURE update_CrimesMean(); 