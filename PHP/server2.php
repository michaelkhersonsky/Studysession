
<?php
	$host = "192.168.1.204";

	$eclient = $argv[1] or $eclient = $host;
	
	$port = $argv[2] or $port = 80;
	
	// No Timeout 
	set_time_limit(0);

	//Create Socket
	$sock = socket_create(AF_INET, SOCK_STREAM, 0) or die("Could not create socket\n");

	//Bind the socket to port and host
	$result = socket_bind($sock, $host, $port) or die("Could not bind to socket\n");
	print "Listening to: $eclient\n" ;
	
	while(true) {
		//Start listening to the port
		$result = socket_listen($sock, 3) or die("Could not set up socket listener\n");

		//Make it to accept incoming connection
		$spawn = socket_accept($sock) or die("Could not accept incoming connection\n");

		//Read the message from the client socket
		$header = socket_read($spawn, 2) or die("Could not read input\n");
		
		$input = socket_read($spawn, intval($header)) or die("Could not read input\n");

		socket_getpeername($spawn, $raddr, $rport);

			print "Message received from $raddr on $rport, message is: $input\n";
			
			if ($raddr == $eclient) 

			{

			$output = "Message received from ". $eclient;
			$fp = fopen($raddr.".log", 'w');
			fwrite ($fp, $input);
			fclose ($fp);
			}
			else
			{
			$output = "Wrong client: waiting for ". $eclient;
			}
			//Send message back to client socket
			socket_write($spawn, $output, strlen ($output)) or die("Could not write output\n");
			
	}

	socket_close($spawn);
	socket_close($socket);

?>
