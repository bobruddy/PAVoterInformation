
create view drv_elec_attended_notWeighted as
SELECT
        e.Last_Name,
        e.First_Name,
        e.Date_Of_Birth,
        e.Elec_Type,
	e.Elec_Eligible,
	IFNULL(t.Elec_Attended,0) As Elec_Attended,
	round((IFNULL(t.Elec_Attended,0)/e.Elec_Eligible*100)) As Percent_Attended_notWeighted
FROM
	drv_total_elec_by_type AS e LEFT JOIN drv_attended_elec_by_type AS t ON 
        	e.Last_Name=t.Last_Name AND e.First_Name=t.First_Name AND
        	e.Date_Of_Birth=t.Date_Of_Birth AND e.Elec_Type=t.Elec_Type
