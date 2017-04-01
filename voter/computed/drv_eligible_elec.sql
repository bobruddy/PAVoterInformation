/* DROP VIEW drv_eligible_elec; */

CREATE VIEW drv_eligible_elec AS
SELECT
	h.Last_Name,
	h.First_Name,
	h.Date_Of_Birth,
	h.Elec_Type,
	h.Elec_Date,
	h.Vote_Type,
	h.Political_Party
FROM
	voter_history AS h inner join voter_list AS v ON
		h.Last_Name=v.Last_Name AND h.First_Name=v.First_Name AND h.Date_Of_Birth=v.Date_Of_Birth AND v.Date_Registered < h.Elec_Date;
