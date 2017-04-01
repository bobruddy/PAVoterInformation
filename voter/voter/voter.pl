#!/usr/bin/perl

use DBI;
my $myConnection = DBI->connect("DBI:mysql:$db:$dbhost", $dbuser, $dbpass);
my $query = $myConnection->prepare('SELECT First_Name FROM voter_list where Last_Name="Ruddy"');
my $result = $query->execute();
print $query->fetchrow_array(), "\n";
my $insert = $myConnection->prepare("insert into voter_list (Last_Name, First_Name, Middle_Name, Suffix, Sex, Date_Of_Birth, Date_Registered, Voter_Status, StatusChangeDate, Political_Party, House, HouseNoSuffix, StreetNameComplete, Apt, Address_Line_2, City, State, Zip_Code, MapAddress, MAddress_Line_1, MAddress_Line_2, MCity, MState, MZip_Code, PollingPlaceDescript, PollPlaceAdd, PollPlaceCSZ, Region, Last_Date_Voted, Precinct, Ward, School, Municipality, Magisterial, Legislative, Senatorial, Congressional, County, Rep_State_Comm, Dem_Zone, Rep_Zone, Precinct_Split, Date_Last_Changed, PhoneNumHome) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

# used to store voter info

# chuck fist line then print header
my $trash = <STDIN>;
#print "Last_Name,First_Name,Middle_Name,Suffix,Sex,Date_Of_Birth,Date_Registered,Voter_Status,StatusChangeDate,Political_Party,House,HouseNoSuffix,StreetNameComplete,Apt,Address_Line_2,City,State,Zip_Code,MapAddress,MAddress_Line_1,MAddress_Line_2,MCity,MState,MZip_Code,PollingPlaceDescript,PollPlaceAdd,PollPlaceCSZ,Region,Last_Date_Voted,Precinct,Ward,School,Municipality,Magisterial,Legislative,Senatorial,Congressional,County,Rep_State_Comm,Dem_Zone,Rep_Zone,Precinct_Split,Date_Last_Changed,PhoneNumHome\n";

while(<STDIN>){
	chomp($_);
	my ($Last_Name, $First_Name, $Middle_Name, $Suffix, $Sex, $Date_Of_Birth, $Date_Registered, $Voter_Status, $StatusChangeDate, $Political_Party, $House, $HouseNoSuffix, $StreetNameComplete, $Apt, $Address_Line_2, $City, $State, $Zip_Code, $MAddress_Line_1, $MAddress_Line_2, $MCity, $MState, $MZip_Code, $PollingPlaceDescript, $PollPlaceAdd, $PollPlaceCSZ, $Last_Date_Voted, $Precinct, $Ward, $School, $Municipality, $Magisterial, $Legislative, $Senatorial, $Congressional, $County, $Rep_State_Comm, $Dem_Zone, $Rep_Zone, $Precinct_Split, $Date_Last_Changed, $PhoneNumHome, @array) = split(/\t/, $_);

	$Last_Name =~ s/([\w']+)/\u\L$1/g;
	$First_Name =~ s/([\w']+)/\u\L$1/g;
	$Middle_Name =~ s/([\w']+)/\u\L$1/g;
	undef $Middle_Name unless( $Middle_name );
	undef $Suffix unless( $Suffix );
	undef $Sex unless( $Sex );

	if( $Date_Of_Birth) {
		my ($m, $d, $y) = split(/\//, $Date_Of_Birth);
		if($y < 17) { $y="20$y"; } else { $y="19$y"; }
		$Date_Of_Birth = sprintf "%02s-", $y;
		$Date_Of_Birth .= sprintf "%02s-", $m;
		$Date_Of_Birth .= sprintf "%02s", $d;
		#$Date_Of_Birth = sprintf "%02s", $y . "-" . sprintf "%02s", $m . "-" . sprintf "%02s", $d; # not sure why this line does work
	} else {
		#$Date_Of_Birth = "0000-00-00";
		undef $Date_Of_Birth;
	}
	#print "$Date_Of_Birth\n";

	if( $Date_Registered ){
		my ($m, $d, $y) = split(/\//, $Date_Registered);
		if($y < 17) { $y="20$y"; } else { $y="19$y"; }
		$Date_Registered = sprintf "%02s-", $y;
		$Date_Registered .= sprintf "%02s-", $m;
		$Date_Registered .= sprintf "%02s", $d;
		undef $Date_Registered if( $y == 191800 );
	} else {
		#$Date_Registered = "0000-00-00";
		undef $Date_Registered;
	}
	#print "$Date_Registered\n";

	$Voter_Status = $Voter_Status;

	if( $StatusChangeDate ){
		my ($keep, $trash) = split(/ /, $StatusChangeDate);
		my ($m, $d, $y) = split(/\//, $keep);
		if($y < 17) { $y="20$y"; } else { $y="19$y"; }
		$StatusChangeDate = sprintf "%02s-", $y;
		$StatusChangeDate .= sprintf "%02s-", $m;
		$StatusChangeDate .= sprintf "%02s", $d;
	} else {
		#$StatusChangeDate = "0000-00-00";
		undef $StatusChangeDate;
	}
	#print "$StatusChangeDate\n";

	$Political_Party = $Political_Party;
	$House = $House;
	undef $HouseNoSuffix unless( $HouseNoSuffix );
	$StreetNameComplete =~ s/([\w']+)/\u\L$1/g;
	undef $Apt unless( $Apt );
	$Address_Line_2 =~ s/([\w']+)/\u\L$1/g;
	$City =~ s/([\w']+)/\u\L$1/g;
	$State = $State;
	$Zip_Code = $Zip_Code;
	my $MapAddress = "$House $StreetNameComplete, $City, $State, $Zip_Code";
	$MAddress_Line_1 =~ s/([\w']+)/\u\L$1/g;
	$MAddress_Line_2 =~ s/([\w']+)/\u\L$1/g;
	$MCity =~ s/([\w']+)/\u\L$1/g;
	undef $MCity unless( $MCity );
	undef $MState unless( $MState );
	undef $MZip_Code unless( $MZip_Code );
	$PollingPlaceDescript =~ s/([\w']+)/\u\L$1/g;
	$PollPlaceAdd =~ s/([\w']+)/\u\L$1/g;
	$PollPlaceCSZ =~ s/([\w']+)/\u\L$1/g;

	my $Region = "Region 1" if($School==15);
	my $Region = "Region 2" if($School==16);
	my $Region = "Region 3" if($School==17);

	if ($Last_Date_Voted) {
		my ($m, $d, $y) = split(/\//, $Last_Date_Voted);
		if($y < 17) { $y="20$y"; } else { $y="19$y"; }
		$Last_Date_Voted = sprintf "%02s-", $y;
		$Last_Date_Voted .= sprintf "%02s-", $m;
		$Last_Date_Voted .= sprintf "%02s", $d;
	} else {
		#$Last_Date_Voted = "0000-00-00";
		undef $Last_Date_Voted;
	}
	#print "$Last_Date_Voted\n";

	$Precinct = $Precinct;
	undef $Ward unless( $Ward );
	$School = $School;
	$Municipality = $Municipality;
	$Magisterial = $Magisterial;
	$Legislative = $Legislative;
	$Senatorial = $Senatorial;
	$Congressional = $Congressional;
	$County = $County;
	$Rep_State_Comm = $Rep_State_Comm;
	$Dem_Zone = $Dem_Zone;
	$Rep_Zone = $Rep_Zone;
	$Precinct_Split = $Precinct_Split;

	if ($Date_Last_Changed) {
		my ($keep, $trash) = split(/ /, $Date_Last_Changed);
		my ($m, $d, $y) = split(/\//, $keep);
		if($y < 17) { $y="20$y"; } else { $y="19$y"; }
		$Date_Last_Changed = sprintf "%02s-", $y;
		$Date_Last_Changed .= sprintf "%02s-", $m;
		$Date_Last_Changed .= sprintf "%02s", $d;
	} else {
		#$Date_Last_Changed = "0000-00-00";
		undef $Date_Last_Changed;
	}
	#print "$Date_Last_Changed\n";

	undef $PhoneNumHome unless( $PhoneNumHome );

	my $result = $insert->execute( $Last_Name, $First_Name, $Middle_Name, $Suffix, $Sex, $Date_Of_Birth, $Date_Registered, $Voter_Status, $StatusChangeDate, $Political_Party, $House, $HouseNoSuffix, $StreetNameComplete, $Apt, $Address_Line_2, $City, $State, $Zip_Code, $MapAddress, $MAddress_Line_1, $MAddress_Line_2, $MCity, $MState, $MZip_Code, $PollingPlaceDescript, $PollPlaceAdd, $PollPlaceCSZ, $Region, $Last_Date_Voted, $Precinct, $Ward, $School, $Municipality, $Magisterial, $Legislative, $Senatorial, $Congressional, $County, $Rep_State_Comm, $Dem_Zone, $Rep_Zone, $Precinct_Split, $Date_Last_Changed, $PhoneNumHome );

#	print $Last_Name, ",", $First_Name, ",", $Middle_Name, ",", $Suffix, ",", $Sex, ",", $Date_Of_Birth, ",", $Date_Registered, ",", $Voter_Status, ",", $StatusChangeDate, ",", $Political_Party, ",", $House, ",", $HouseNoSuffix, ",", $StreetNameComplete, ",", $Apt, ",", $Address_Line_2, ",", $City, ",", $State, ",", $Zip_Code, ",", $MapAddress, ",", $MAddress_Line_1, ",", $MAddress_Line_2, ",", $MCity, ",", $MState, ",", $MZip_Code, ",", $PollingPlaceDescript, ",", $PollPlaceAdd, ",", $PollPlaceCSZ, ",", $Region, ",", $Last_Date_Voted, ",", $Precinct, ",", $Ward, ",", $School, ",", $Municipality, ",", $Magisterial, ",", $Legislative, ",", $Senatorial, ",", $Congressional, ",", $County, ",", $Rep_State_Comm, ",", $Dem_Zone, ",", $Rep_Zone, ",", $Precinct_Split, ",", $Date_Last_Changed, ",", $PhoneNumHome, "\n";
}
