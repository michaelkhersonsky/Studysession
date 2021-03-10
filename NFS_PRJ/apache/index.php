<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<body>
<?php

$hostname = "127.0.0.1";
$username = "labx";
$password = "";
$db = "falldevops2020";
$rn = rand(1,6);
$hstname = gethostname();


#shell_exec("ssh -N -f -L 3306:127.0.0.1:3306 root@labx-db-001.local");
#shell_exec("mysql -u labx -h 127.0.0.1 -e "show databases;");
shell_exec("/usr/bin/ssh -i /root/my-key -N -f -L 3307:127.0.0.1:3306 root@labx-db-001.local");
$dbconnect=mysqli_connect($hostname,$username,$password,$db,3307);

if ($dbconnect->connect_error) {
  die("Database connection failed: " . $dbconnect->connect_error);
}

?>

<table border="1" align="center">

<tr>
  	<td>
<?php
echo $hstname
?>

	</td>
</tr>

<tr>
  <td>First Name</td>
  <td>Last Name</td>
  <td>GPA</td>
</tr>

<?php

$query = mysqli_query($dbconnect, "SELECT * FROM StarTech WHERE Student_ID=$rn")
   or die (mysqli_error($dbconnect));

while ($row = mysqli_fetch_array($query)) {
  echo
   "<tr>
    <td>{$row['first_name']}</td>
    <td>{$row['last_name']}</td>
    <td>{$row['GPA']}</td>
   </tr>\n";
}

?>
</table>
</body>
</html>
