
create view elec_attended as

SELECT
        nw.Last_Name,
        nw.First_Name,
        nw.Date_Of_Birth,
        nw.Elec_Type,
	nw.Elec_Eligible,
	nw.Elec_Attended,
	nw.Percent_Attended_notWeighted,
	round((100 * (w.Attendance/w.Weight))) As Percent_Attended_Weighted
FROM
	drv_elec_attended_notWeighted AS nw JOIN drv_weight AS w ON 
        	nw.Last_Name=w.Last_Name AND nw.First_Name=w.First_Name AND
        	nw.Date_Of_Birth=w.Date_Of_Birth AND nw.Elec_Type=w.Elec_Type

/*
where nw.last_name like 'web%' and nw.first_name like 'lyn%'
*/
