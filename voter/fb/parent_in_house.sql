
drop table if exists parent_in_house;
create table parent_in_house (
	Full_Street_Address varchar(512),
	primary key (Full_Street_Address)
);

insert into parent_in_house (Full_Street_Address) select distinct
	vl.Full_Street_Address
from
	mv_voter_list AS vl JOIN parent_list AS pl ON
		pl.First_Name = vl.First_Name AND pl.Last_Name = vl.Last_Name
