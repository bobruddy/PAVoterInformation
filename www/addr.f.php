<?php
require("phpsqlajax_dbinfo.pw");

$pwFile = file_get_contents('../etc/passwords.pw');
$rows = explode ("\n", $pwFile);

$pw;

foreach($rows as $row => $data)
{
	$row_data = explode(' => ', $data);
	$pw[$row_data[0]] = $row_data[1];

}

#echo "dbuser $pw[dbuser] <br>";
#echo "db: $pw[db] <br>";
#echo "dbhost: $pw[dbhost] <br>";
#echo "dbpass: .$pw[dbpass]. <br>";
#echo "mapsAPIweb: $pw[mapsAPIweb] <br>";
#echo "mapsAPIbat: $pw[mapsAPIbat] <br>";
#exit;



function parseToXML($htmlStr)
{
$xmlStr=str_replace('<','&lt;',$htmlStr);
$xmlStr=str_replace('>','&gt;',$xmlStr);
$xmlStr=str_replace('"','&quot;',$xmlStr);
$xmlStr=str_replace("'",'&#39;',$xmlStr);
$xmlStr=str_replace("&",'&amp;',$xmlStr);
return $xmlStr;
}
// Opens a connection to a MySQL server
$connection=mysqli_connect ($pw[dbhost], $pw[dbuser], $pw[dbpass], $pw[db]);
if(mysqli_connect_errno()) {
  die('Not connected : ' . mysqli_connect_error());
}
// Set the active MySQL database
//$db_selected = mysqli_select_db($connection, $pw[db]);
//if (!$db_selected) {
//  die ('Can\'t use db : ' . mysqli_error($connection));
//}
// Select all the rows in the markers table
//$query = "SELECT First_Name, Last_Name, MapAddress FROM voter_list WHERE 1";
$query = "SELECT m.First_Name, m.Last_Name, m.mapAddress, m.lat, m.lng, m.Political_Party FROM mapInfo as m join simple_voter_list as s on m.First_Name=s.First_Name AND m.Last_Name=s.Last_Name and m.Date_Of_Birth=s.Date_Of_Birth and s.PotentialFriendly='Yes' WHERE Voter_Status='A' and lat is not NULL AND lng is not NULL order by mapAddress, Political_Party, Last_Name, First_Name";
#$query = "SELECT First_Name, Last_Name, mapAddress, lat, lng, Political_Party FROM mapInfo WHERE Voter_Status='A' and lat is not NULL AND lng is not NULL and last_name IN ('Ruddy', 'Michael') order by mapAddress";
$result = mysqli_query($connection, $query);
if (!$result) {
  die('Invalid query: ' . mysqli_error($connection));
}
header("Content-type: text/xml");
// Start XML file, echo parent node
echo '<markers>';

// Iterate through the rows, printing XML nodes for each
$label="";
$address="";
$lat="";
$lng="";
$party="";
$count=0;

while ($row = @mysqli_fetch_assoc($result)){

  // group by address
  if( ($address != $row['mapAddress']) && ($address != "") ){
  	// Add to XML document node
  	echo '<marker ';
  	echo 'name="' . parseToXML($label) . '" ';
  	//echo 'name="' . $label . '" ';
  	echo 'address="' . parseToXML($address) . '" ';
  	echo 'lat="' . $lat . '" ';
  	echo 'lng="' . $lng . '" ';
  	echo 'party="' . parseToXML($party) . '" ';
  	//echo 'type="' . $row['type'] . '" ';
  	echo '/>';

        // zero out the variables after we print them
        $label="";
        $address="";
        $lat="";
        $lng="";
        $party="";
	$count=0;
  }
  if($count != 0) $label.='; ';
  $label .= $row['First_Name'] . " " . $row['Last_Name'] . " (" . $row['Political_Party'] . ")";
  $address=$row['mapAddress'];
  $lat=$row['lat'];
  $lng=$row['lng'];
  if( ($party != $row['Political_Party'] && $party != "") || $party == "mixed") {
    $party="mixed";
  } else {
    $party=$row['Political_Party'];
  }
  $count++;

}

// End XML file
echo '</markers>';
?>
