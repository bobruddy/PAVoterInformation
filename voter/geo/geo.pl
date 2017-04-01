#!/usr/bin/perl

use LWP::Simple;
use JSON qw( decode_json );
use Time::HiRes qw( sleep );
use Data::Dumper;
use DBI;

my $apiKey = $mapsAPIbat;

my $myConnection = DBI->connect("DBI:mysql:$db:$dbhost", $dbuser, $dbpass);
my $list = $myConnection->prepare("select distinct mapAddress from streetAddress where (lat is NULL OR lng is NULL OR mapPoint is NULL) AND (geoError is NULL or geoError <> 'Y');");
my $insert = $myConnection->prepare("update streetAddress set lat=?, lng=?, mapPoint=? where mapAddress=?;");
my $error = $myConnection->prepare("update streetAddress set geoError='Y', mapPoint=? where mapAddress=?;");


$list->execute();
my $addr = $list->fetchall_arrayref;

foreach my $row (@$addr) {
	my $address = $row->[0];

	my $format = "json"; #can also to 'xml'

	my $geocodeapi = "https://maps.googleapis.com/maps/api/geocode/";

	my $url = $geocodeapi . $format . "?sensor=false&key=". $apiKey . "&address=" . $address;

	my $json = get($url);

	my $d_json = decode_json( $json );

	my $status = $d_json->{status};

	if( $status eq 'REQUEST_DENIED' ) {
		print "STATUS: $status\n";
		print Dumper($d_json);
		exit 1;
	} elsif( $status eq 'OK' ) {
		my $lat = $d_json->{results}->[0]->{geometry}->{location}->{lat};
		my $lng = $d_json->{results}->[0]->{geometry}->{location}->{lng};

		$insert->execute($lat,$lng, $json, $address);
		print "lat $lat -> lng $lng -> $address\n";
	} elsif( $status eq 'ZERO_RESULTS' ) {
		print "ADDRESS: $address\n";
		print "STATUS: $status\n";
		$error->execute($json, $address);
	} else {
		$error->execute($json, $address);
		print "STATUS: $status\n";
		print Dumper($d_json);
	}
	sleep(0.1);

}
