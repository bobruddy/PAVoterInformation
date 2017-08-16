#drop view if exists mapInfo;
#create view MapInfo as 

select
	`v`.`First_Name` AS `First_Name`,
	`v`.`Last_Name` AS `Last_Name`,
	`v`.`Voter_Status` AS `Voter_Status`,
	`v`.`Political_Party` AS `Political_Party`,
	`v`.`MapAddress` AS `mapAddress`,
	`v`.`PollingPlaceDescript` AS `PollingPlaceDescript`,
	`v`.`Region` AS `Region`,
	`v`.`PhoneNumHome` AS `PhoneNumHome`,
	`m`.`lat` AS `lat`,
	`m`.`lng` AS `lng`
from
	`voter_list` `v` left join `streetAddress` `m` on
		((`v`.`MapAddress` = `m`.`MapAddress`))
	LEFT JOIN simple_voter_list as svl on
		v.First_Name = svl.First_Name AND v.Last_Name = svl.Last_Name AND v.Date_Of_Birth = svl.Date_Of_Birth
