create view v_voter_list As
select
	concat(IFNULL(v.First_Name,''), " ", IFNULL(v.Middle_Name,''), " ", IFNULL(v.Last_Name,''), " ", IFNULL(v.Suffix,'')) As Full_Name,
	v.Last_Name,
	v.First_Name,
	v.Middle_Name,
	v.Suffix,
	CASE
		WHEN v.Sex='M' THEN 'Male'
		WHEN v.Sex='F' THEN 'Female'
		ELSE v.Sex
	END As Sex,
	v.Date_Of_Birth,
	(year(curdate()) - year(v.Date_Of_Birth)) As Age,
	(floor((year(curdate())-year(v.Date_Of_Birth))/10)*10) As Age_Group,
	v.Date_Registered,
	CASE
		WHEN v.Voter_Status='A' THEN 'Active'
		WHEN v.Voter_Status='I' THEN 'Inactive'
	END As Voter_Status,
	v.StatusChangeDate As Date_Status_Change,
	CASE
		WHEN v.Political_Party='R' THEN 'Republician'
		WHEN v.Political_Party='D' THEN 'Democrat'
		ELSE v.Political_Party
	END As Polictical_Party,
	concat(IFNULL(v.House,''), " ", IFNULL(v.HouseNoSuffix,''), " ", IFNULL(v.StreetNameComplete,''), " ", IFNULL(v.Apt,''), ", ", IFNULL(v.Address_Line_2,''), ", ", IFNULL(v.City,''), ", ", IFNULL(v.State,''), " ", IFNULL(v.Zip_Code,'')) As Full_Street_Address,
	v.House As House_No,
	v.HouseNoSuffix As House_No_Suffix,
	v.StreetNameComplete As Street_Name_Complete,
	v.Apt,
	v.Address_Line_2,
	v.City,
	v.State,
	v.Zip_Code,
	concat(IFNULL(v.MAddress_Line_1,''), "", IFNULL(v.MAddress_Line_2,''), "", IFNULL(v.MCity,''), ", ", IFNULL(v.MState,''), " ", IFNULL(v.MZip_Code,'')) As Full_Mail,
	v.MAddress_Line_1,
	v.MAddress_Line_2,
	v.MCity,
	v.MState,
	v.MZip_Code,
	v.PollingPlaceDescript,
	v.PollPlaceAdd,
	v.PollPlaceCSZ,
	v.Last_Date_Voted,
	v.Precinct,
	CASE
		WHEN v.School=15 THEN 'Region 1'
		WHEN v.School=16 THEN 'Region 2'
		WHEN v.School=17 THEN 'Region 3'
	END As Region,
	v.Precinct_Split,
	v.Date_Last_Changed,
	v.PhoneNumHome,
	gn.Elec_Eligible As General_Elec_Eligible,
	gn.Elec_Attended As General_Elec_Attended,
	gn.Percent_Attended_notWeighted As General_Percent_Attended,
	gn.Percent_Attended_Weighted As General_Percent_Attended_Weighted,
	pr.Elec_Eligible As Primary_Elec_Eligible,
	pr.Elec_Attended As Primary_Elec_Attended,
	pr.Percent_Attended_notWeighted As Primary_Percent_Attended,
	pr.Percent_Attended_Weighted As Primary_Percent_Attended_Weighted
from
	voter_list AS v LEFT JOIN elec_attended AS gn ON
		v.Last_Name=gn.Last_Name AND v.First_Name=gn.First_Name AND
		v.Date_Of_Birth=gn.Date_Of_Birth AND gn.Elec_Type like 'GN'
	LEFT JOIN elec_attended AS pr ON
		v.Last_Name=pr.Last_Name AND v.First_Name=pr.First_Name AND
		v.Date_Of_Birth=pr.Date_Of_Birth AND pr.Elec_Type like 'PR'
