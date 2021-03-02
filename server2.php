<?php

	$host = gethostname();

	$server = "192.168.1.204";
	$port = 44747;

	echo "Sending to $server : $port\n";

	// No Timeout 
	set_time_limit(0);

	//Create Socket
	$sock = socket_create(AF_INET, SOCK_STREAM, 0) or die("Could not create socket\n");

	//Connect to the server
	$result = socket_connect($sock, $server, $port) or die("Could not connect toserver\n");

	$message = "Hello from ". $host;
	//Write to server socket
	socket_write($sock, $message, strlen($message)) or die("Could not send data to server\n");

	//Read server respond message
	$result = socket_read($sock, 1024) or die("Could not read server response\n");
	echo "Reply From Server  :".$result;

     	//Close the socket  traaa taaa taaa
	socket_close($sock);

?>
