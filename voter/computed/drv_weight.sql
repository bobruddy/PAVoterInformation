
CREATE VIEW drv_weight AS 


SELECT
        e.Last_Name,
        e.First_Name,
        e.Date_Of_Birth,
        e.Elec_Type, 
	sum(IF(STRCMP(IFNULL(e.Vote_Type,1),IFNULL(e.Vote_Type,2)),0,1) *
		(mw.MaxWeight + 1 - (year(curdate()) - year(e.Elec_Date)))) AS Attendance,
	sum((mw.MaxWeight + 1 - (year(curdate()) - year(e.Elec_Date)))) AS Weight
FROM
	drv_eligible_elec AS e LEFT JOIN drv_max_weight AS mw ON
        e.Last_Name=mw.Last_Name AND e.First_Name=mw.First_Name AND 
		e.Date_Of_Birth=mw.Date_Of_Birth AND e.Elec_Type=mw.Elec_Type
/*
where e.last_name like 'web%' and e.first_name like 'ly%'
*/
GROUP BY
        e.Last_Name,
        e.First_Name,
        e.Date_Of_Birth,
        e.Elec_Type 
		
/*

order by e.Elec_Type, e.Elec_Date
*/
