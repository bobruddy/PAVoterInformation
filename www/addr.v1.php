<?php
require("phpsqlajax_dbinfo.pw");
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
$connection=mysqli_connect ($dbhost, $dbuser);
if (!$connection) {
  die('Not connected : ' . mysqli_error($connection));
}
// Set the active MySQL database
$db_selected = mysqli_select_db($connection, $db);
if (!$db_selected) {
  die ('Can\'t use db : ' . mysqli_error($connection));
}
// Select all the rows in the markers table
//$query = "SELECT First_Name, Last_Name, MapAddress FROM voter_list WHERE 1";
$query = "SELECT First_Name, Last_Name, mapAddress, lat, lng, Political_Party FROM mapInfo WHERE Voter_Status='A' and lat is not NULL AND lng is not NULL order by Political_Party desc";
$result = mysqli_query($connection, $query);
if (!$result) {
  die('Invalid query: ' . mysqli_error($connection));
}
header("Content-type: text/xml");
// Start XML file, echo parent node
echo '<markers>';
// Iterate through the rows, printing XML nodes for each
while ($row = @mysqli_fetch_assoc($result)){
  // Add to XML document node
  echo '<marker ';
  echo 'name="' . parseToXML($row['First_Name']." ".$row['Last_Name'] ." (" . $row['Political_Party'] . ")") . '" ';
  echo 'address="' . parseToXML($row['mapAddress']) . '" ';
  echo 'lat="' . $row['lat'] . '" ';
  echo 'lng="' . $row['lng'] . '" ';
  echo 'party="' . parseToXML($row['Political_Party']) . '" ';
  //echo 'type="' . $row['type'] . '" ';
  echo '/>';
}
// End XML file
echo '</markers>';
?>
