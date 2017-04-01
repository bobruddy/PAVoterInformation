
/*
drop view drv_attended_elec_by_type;
*/

create view drv_attended_elec_by_type as
SELECT
        h.Last_Name,
        h.First_Name,
        h.Date_Of_Birth,
        h.Elec_Type,
	IFNULL(count(*),0) AS Elec_Attended
FROM
	drv_eligible_elec AS h
WHERE
	h.Vote_Type IS NOT NULL
GROUP BY
        h.Last_Name,
        h.First_Name,
        h.Date_Of_Birth,
        h.Elec_Type
