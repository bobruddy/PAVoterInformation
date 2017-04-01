
CREATE VIEW drv_max_weight AS 

SELECT
        e.Last_Name,
        e.First_Name,
        e.Date_Of_Birth,
        e.Elec_Type, 
	max((year(curdate()) - year(e.Elec_Date))) AS MaxWeight 
FROM
	drv_eligible_elec AS e
GROUP BY
        e.Last_Name, e.First_Name, e.Date_Of_Birth, e.Elec_Type
