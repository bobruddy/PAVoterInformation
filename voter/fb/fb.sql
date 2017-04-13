
#WHEN STRCMP(pri.page, "agcPrivate") THEN 'private only'
drop view simple_voter_list;
create view simple_voter_list as

select 
	vl.Full_Name,
	vl.Sex,
	vl.Date_Of_Birth,
	vl.Age,
	vl.Polictical_Party,
	vl.Full_Street_Address,
	vl.PollingPlaceDescript,
	vl.Region,
	vl.PhoneNumHome,
	vl.General_Percent_Attended_Weighted,
	vl.Primary_Percent_Attended_Weighted,
	CASE
		WHEN (pri.page="agcPrivate" AND pub.page="agcPublic") THEN 'both'
		WHEN pri.page="agcPrivate" THEN 'private only'
		WHEN pub.page="agcPublic" THEN 'public only'
	END AS Facebook
	#pri.page As Private,
	#pub.page As Pub
from
	mv_voter_list as vl LEFT OUTER JOIN fb_list as pri ON 
		pri.First_Name = vl.First_Name AND pri.Last_Name = vl.Last_Name AND pri.page = "agcPrivate"
		LEFT OUTER JOIN fb_list as pub ON 
		pub.First_Name = vl.First_Name AND pub.Last_Name = vl.Last_Name AND pub.page = "agcPublic"

#where vl.last_name like 'ruddy'
