<?php
$port_file="PHPPortListener.log";
$sock = socket_create_listen(0);
socket_getsockname($sock, $addr, $port);
print "Server listening on 
$addr:$port\n";
$fp = fopen($port_file, 'w');
fwrite ($fp, $port);
fclose ($fp);
while ($c=socket_accept($sock)) {
socket_getpeername($c, $raddr, $rport);
print "Received Connection from $raddr:$rport\n";
$value = socket_read ($sock,128);
print $value;

}

socket_close($sock);
print "Socket closed";
?>



