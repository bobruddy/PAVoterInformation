SELECT
	v.*,
	gn.Elec_Eligible As General_Elec_Eligible,
	gn.Elec_Attended As General_Elec_Attended,
	gn.Percent_Attended_notWeighted As General_Percent_Attended,
	gn.Percent_Attended_Weighted As General_Percent_Attended_Weighted,
	pr.Elec_Eligible As Primary_Elec_Eligible,
	pr.Elec_Attended As Primary_Elec_Attended,
	pr.Percent_Attended_notWeighted As Primary_Percent_Attended,
	pr.Percent_Attended_Weighted As Primary_Percent_Attended_Weighted
FROM
	voter_list AS v LEFT JOIN elec_attended AS gn ON
		v.Last_Name=gn.Last_Name AND v.First_Name=gn.First_Name AND
			v.Date_Of_Birth=gn.Date_Of_Birth AND gn.Elec_Type like 'GN' 
	LEFT JOIN elec_attended AS pr ON
		v.Last_Name=pr.Last_Name AND v.First_Name=pr.First_Name AND
			v.Date_Of_Birth=pr.Date_Of_Birth AND pr.Elec_Type like 'PR'
WHERE
	v.last_name like 'ruddy';
