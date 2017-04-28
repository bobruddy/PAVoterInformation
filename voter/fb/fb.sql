
drop view if exists simple_voter_list;
create view simple_voter_list as

select 
	vl.Full_Name,
	vl.Sex,
	vl.Date_Of_Birth,
	vl.Age,
	CASE vl.Polictical_Party
		WHEN "Democrat"	THEN 'Democrat'
		WHEN "Republician"	THEN 'Republician'
		ELSE 'Other'
	END AS Polictical_Party,
	vl.Full_Street_Address,
	vl.PollingPlaceDescript,
	vl.Region,
	vl.PhoneNumHome,
	vl.General_Percent_Attended_Weighted,
	vl.Primary_Percent_Attended_Weighted,

	CASE
		WHEN concat(COALESCE(pri.page, ''), COALESCE(pub.page, ''), COALESCE(ple.page, ''), COALESCE(pat.page, ''), COALESCE(bri.page, ''), COALESCE(par.page, '')  ) <> '' THEN 'Yes'
		ELSE 'No'
	END AS Facebook,

	# We check to see if there is a parent in the house. If True and age is of school age
	# baring years than we assume this person is also a parent
	CASE
		WHEN  pl.confidence IS NOT NULL	THEN	pl.confidence
		WHEN  (pih.Full_Street_Address IS NOT NULL) AND (vl.Age between 24 AND 60)	THEN	80
		ELSE 'NA'
	END As ParentConfidence,

	CASE
		WHEN (concat(COALESCE(pri.page, ''), COALESCE(pub.page, ''), COALESCE(ple.page, ''), COALESCE(pl.confidence, ''), COALESCE(bri.page, ''), COALESCE(pat.page, ''), COALESCE(par.page, '') ) <> '' ) OR ((pih.Full_Street_Address IS NOT NULL) AND (vl.Age between 24 and 60))  THEN 'Yes' 
		ELSE	'Unknown'
	END AS PotentialFriendly
from
	mv_voter_list as vl LEFT OUTER JOIN fb_list as pri ON 
			pri.First_Name = vl.First_Name AND pri.Last_Name = vl.Last_Name AND pri.page = "agcPrivate"
		LEFT OUTER JOIN fb_list as pub ON 
			pub.First_Name = vl.First_Name AND pub.Last_Name = vl.Last_Name AND pub.page = "agcPublic"
		LEFT OUTER JOIN fb_list as ple ON 
			ple.First_Name = vl.First_Name AND ple.Last_Name = vl.Last_Name AND ple.page = "plePTA"
		LEFT OUTER JOIN fb_list as par ON 
			par.First_Name = vl.First_Name AND par.Last_Name = vl.Last_Name AND par.page = "parents"
		LEFT OUTER JOIN fb_list as pat ON 
			pat.First_Name = vl.First_Name AND pat.Last_Name = vl.Last_Name AND pat.page = "patrick"
		LEFT OUTER JOIN fb_list as bri ON 
			bri.First_Name = vl.First_Name AND bri.Last_Name = vl.Last_Name AND bri.page = "brian"
		LEFT OUTER JOIN parent_list as pl ON 
			pl.First_Name = vl.First_Name AND pl.Last_Name = vl.Last_Name
		#LEFT OUTER JOIN parent_in_house as pih ON 
		LEFT OUTER JOIN ( select distinct
        				vl.Full_Street_Address
					from
        					mv_voter_list AS vl JOIN parent_list AS pl ON
                				pl.First_Name = vl.First_Name AND pl.Last_Name = vl.Last_Name
				) as pih ON 
			pih.Full_Street_Address = vl.Full_Street_Address

#where vl.last_name like 'ruddy' OR vl.last_name like 'michael'
