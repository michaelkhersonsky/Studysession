ssh root@labx-ns-001.local cat /etc/hosts
ssh root@labx-ns-001.local nslookup <hostname>
ssh root@labx-ns-001.local nslookup <IP address>
ssh root@labx-ns-001.local chronyc sources
ssh root@labx-ns-001.local timedatectl
ssh root@labx-ns-001.local df -h
ssh root@labx-ns-001.local ls /mntdir
ssh root@labx-ns-001.local df -h
ssh root@labx-ns-001.local echo “Hello from DNS” >> /mntdir/dns.txt
ssh root@labx-ns-001.local cat /mndir/dns.txt
ssh root@labx-ns-001.local systemctl status firewalld
ssh root@labx-ns-001.local getenforce


