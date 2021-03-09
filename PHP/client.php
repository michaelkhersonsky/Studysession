<?php
$port_file="PHPPortListener.log";
$value = "Hello frok remote";
$fp=fopen ($port_file, 'r');
$port = fgets ($fp,1024);
fclose ($fp);
$sock = socket_create (AF_INET, SOCK_STREAM, SOL_TCP);
socket_connect($sock,'127.0.0.1',$port);
print "Connecting on :$port\n";
socket_send ($sock, $value, strlen($value),0);
socket_close($sock);
?>
