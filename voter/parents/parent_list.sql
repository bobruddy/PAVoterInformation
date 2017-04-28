create table parent_list (
	last_name	varchar(128),
	first_name	varchar(128),
	confidence	tinyint,
	primary key 	(last_name, first_name)
);
