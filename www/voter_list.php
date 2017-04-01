<?php
require("phpsqlajax_dbinfo.pw");
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
$query = "SELECT * FROM v_voter_list";
$result = mysqli_query($connection, $query);
if (!$result) {
  die('Invalid query: ' . mysqli_error($connection));
}
header("Content-type: text/html");
// Start XML file, echo parent node
echo '<table>';
// Iterate through the rows, printing XML nodes for each


$first_loop=0;
while ($row = @mysqli_fetch_assoc($result)){
	if($first_loop == 0){
		echo '<tr>';
		foreach (array_keys($row) as $key) {
			echo '<th>' . $key . '</th>';
		}
		echo '</tr>';
		$first_loop=1;
	}

  	echo '<tr>';
	foreach (array_keys($row) as $key) {
  		echo '<td>' . $row[$key]."</td>";
	}
  echo '</tr>';
}
// End XML file
echo '</table>';
?>
