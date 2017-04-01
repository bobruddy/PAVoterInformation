drop table master_history;

create table master_history (
	Last_Name		varchar(128),
	First_Name		varchar(128),
	Middle_Name		varchar(128),
	Suffix			varchar(128),
	Date_Of_Birth		date,
	Elec_Type		char(2),
	Elec_Date		date,
	Political_Party		varchar(128),
	Vote_Type		varchar(128),
	PRIMARY KEY ( Last_Name, First_Name, Middle_Name, Suffix, Date_Of_Birth, Elec_Type, Elec_Date)
);
