

drop view if exists mapInfo;

create view mapInfo As

select
	v.First_Name,
	v.Last_Name,
	v.Date_Of_Birth,
	v.Voter_Status,
	v.Political_Party,
	v.mapAddress,
	v.PollingPlaceDescript,
	v.Region,
	v.PhoneNumHome,
	m.lat,
	m.lng
from
	voter_list as v left join streetAddress as m on v.mapAddress=m.mapAddress;
