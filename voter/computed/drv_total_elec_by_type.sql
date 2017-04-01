/*
drop VIEW drv_total_elec_by_type;
*/

CREATE VIEW drv_total_elec_by_type AS
SELECT
        h.Last_Name,
        h.First_Name,
        h.Date_Of_Birth,
        h.Elec_Type,
	count(*) AS Elec_Eligible
FROM
	drv_eligible_elec AS h
GROUP BY
        h.Last_Name,
        h.First_Name,
        h.Date_Of_Birth,
        h.Elec_Type
