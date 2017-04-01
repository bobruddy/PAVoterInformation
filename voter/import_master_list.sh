mysqlimport \
	--columns=Last_Name,First_Name,Middle_Name,Suffix,Sex,Date_Of_Birth,Date_Registered,Voter_Status,StatusChangeDate,Political_Party,House__,HouseNoSuffix,StreetNameComplete,Apt__,Address_Line_2,City,State,Zip_Code,MAddress_Line_1,MAddress_Line_2,MCity,MState,MZip_Code,PollingPlaceDescript,PollPlaceAdd,PollPlaceCSZ,Last_Date_Voted,Precinct,Ward,School,Municipality,Magisterial,Legislative,Senatorial,Congressional,County,Rep_State_Comm,Dem_Zone,Rep_Zone,Precinct_Split,Date_Last_Changed,PhoneNumHome,GN_11_08_16,GN_11_08_16_VM,PR_04_26_16,PR_04_26_16_VM,GN_11_03_15,GN_11_03_15_VM,PR_05_19_15,PR_05_19_15_VM,GN_11_04_14,GN_11_04_14_VM,PR_05_20_14,PR_05_20_14_VM,GN_11_05_13,GN_11_05_13_VM,PR_05_21_13,PR_05_21_13_VM,GN_11_06_12,GN_11_06_12_VM,PR_04_24_12,PR_04_24_12_VM,GN_11_08_11,GN_11_08_11_VM,PR_05_17_11,PR_05_17_11_VM,GN_11_02_10,GN_11_02_10_VM,PR_05_18_10,PR_05_18_10_VM,GN_11_03_09,GN_11_03_09_VM,PR_05_19_09,PR_05_19_09_VM,GN_11_04_08,GN_11_04_08_VM,PR_04_22_08,PR_04_22_08_VM,GN_11_06_07,GN_11_06_07_VM,PR_05_15_07,PR_05_15_07_VM,GN_11_07_06,GN_11_07_06_VM,PR_05_16_06,PR_05_16_06_VM,GN_11_08_05,GN_11_08_05_VM,PR_05_17_05,PR_05_17_05_VM,GN_11_02_04,GN_11_02_04_VM,PR_04_27_04,PR_04_27_04_VM,OT_11_04_03,OT_11_04_03_VM,SP_06_17_03,SP_06_17_03_VM,PR_05_20_03,PR_05_20_03_VM,GN_11_05_02,GN_11_05_02_VM,SP_10_01_02,SP_10_01_02_VM,PR_05_21_02,PR_05_21_02_VM,OT_11_06_01,OT_11_06_01_VM,PR_05_15_01,PR_05_15_01_VM,GN_11_07_00,GN_11_07_00_VM,PR_04_04_00,PR_04_04_00_VM,OT_11_02_99,OT_11_02_99_VM,PR_05_18_99,PR_05_18_99_VM,GN_11_03_98,GN_11_03_98_VM,PR_05_19_98,PR_05_19_98_VM \
	-C -h $dbhost -u $dbuser $db master_list.txt
