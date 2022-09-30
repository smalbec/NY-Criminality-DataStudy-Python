CREATE or replace FUNCTION update_JailMean() RETURNS trigger AS
  $BODY$  
BEGIN
  UPDATE NYAidCrimeMean
  set JailPopulation_mean = sub_q.newJailmean
  from (select avg(new.JailPopulation) as newJailmean from NYAidcrimeTimeSeries where county = new.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_JailMean_after_update
AFTER UPDATE 
ON NYAidCrimeTimeSeries
FOR EACH ROW
EXECUTE PROCEDURE update_JailMean(); 
 