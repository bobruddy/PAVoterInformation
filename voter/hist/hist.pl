#!/usr/bin/perl

use DBI;
my $myConnection = DBI->connect("DBI:mysql:$db:$dbhost", $dbuser, $dbpass);
my $insert = $myConnection->prepare("insert into master_history (Last_Name, First_Name, Date_Of_Birth, Elec_Type, Elec_Date, Political_Party, Vote_Type) values (?,?,?,?,?,?,?)");

# used to store voter info
my $voter;
my $elec;
my $counter=0;

my ($Last_Name, $First_Name, $Date_Of_Birth, $Elec_Type, $Elec_Date, $Political_Party, $Vote_Type);

while(<STDIN>){
	#chomp($_);
	if(/\*\*\*\*\*\*\*\*\*\*/) {
		$Last_Name='';
		$First_Name='';
		$Date_Of_Birth='';
		$Elec_Type='';
		$Elec_Date='';
		$Political_Party='';
		$Vote_Type='';
		next;
	} elsif(/     Last_Name: (\S*)/) {
		$Last_Name=$1;
        	$Last_Name =~ s/([\w']+)/\u\L$1/g;
	} elsif(/    First_Name: (\S*)/) {
		$First_Name=$1;
        	$First_Name =~ s/([\w']+)/\u\L$1/g;
	} elsif(/   Middle_Name: (\S*)/) {
		#$voter .= $1. ",";
		next;
	} elsif(/        Suffix: (\S*)/) {
		#$voter .= $1. ",";
		next;
	} elsif(/ Date_Of_Birth: (\d+)\/(\d+)\/(\d+)/) {
		my $y=$3;
		my $m=$1;
		my $d=$2;
		#my ($m, $d, $y) = split(/\//, $Date_Of_Birth);
		if($y < 17) { $y="20$y"; } else { $y="19$y"; }
		$Date_Of_Birth = sprintf "%02s-", $y;
		$Date_Of_Birth .= sprintf "%02s-", $m;
		$Date_Of_Birth .= sprintf "%02s", $d;
	} elsif(/   (\S\S)_(\d\d)_(\d\d)_(\d\d): (\S*)/) {

		my $y=$4;
		my $m=$2;
		my $d=$3;
		if($y < 50) { $y="20$y"; } else { $y="19$y"; }

		$Elec_Type=$1;
		$Elec_Date = $y . "-" . $m . "-" . $d;
		$Political_Party = $5;
	} elsif(/\S\S_\d\d_\d\d_\d\d_VM: (\S*)/) {
		$Vote_Type = $1;
		$counter++;
		print "$counter: $Last_Name, $First_Name, $Date_Of_Birth, $Elec_Type, $Elec_Date, $Political_Party, $Vote_Type\n";
		$insert->execute($Last_Name, $First_Name, $Date_Of_Birth, $Elec_Type, $Elec_Date, $Political_Party, $Vote_Type);
	} else {
		print STDERR  "ERROR: ", $_;
	}

}

