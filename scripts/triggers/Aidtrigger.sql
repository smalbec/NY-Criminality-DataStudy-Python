CREATE or replace FUNCTION update_AidAmountMean() RETURNS trigger AS
  $BODY$  
BEGIN
  UPDATE NYAidCrimeMean
  set AidAmount_mean = sub_q.newaidmean, Aidpercap = sub_q.newaidmean / sub_q.newpopmean
  from (select avg(new.aidAmount) as newaidmean, avg(new.population) as newpopmean from NYAidCrimeTimeSeries where county = old.county) as sub_q
  WHERE County = NEW.county;
  RETURN NEW;
END
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_AidAmountMean_after_update
AFTER UPDATE 
ON NYAidCrimeTimeSeries
FOR EACH ROW
EXECUTE PROCEDURE update_AidAmount(); 