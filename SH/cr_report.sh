#yum install 32:bind-utils-9.11.4-26.P2.el7_9.3.x86_64 -y
# semanage port -a -t http_port_t -p tcp 3307

#echo "mysql -u root -p -e "use powerdns; select * from records;"|grep "192.168.1"|grep -o "labx-.*.local"" > dns_query
#cat dns_quiery|ssh root@labx-ns-001.local > hostnames




###### commands to be sent to remote servers via ssh


i=$(hostname)

echo >/mntdir/$i
echo "################ This is from $i" >> /mntdir/$i

echo "dig $i">>/mntdir/$i
echo $(dig $i|grep $i) >> /mntdir/$i
echo $(dig $(hostname -I|cut -d" " -f1)|grep $(hostname -I|cut -d" " -f1)) >> /mntdir/$i

echo "date">>/mntdir/$i 
echo $(date) >> /mntdir/$i

echo "chronyc sources">>/mntdir/$i
echo $(chronyc sources|grep labx-ntp)>>/mntdir/$i

echo "timedatectl|grep NTP">>/mntdir/$i
timedatectl|grep NTP >> /mntdir/$i

echo "ls /mntdir && ls /var/www/html && df -h|grep labx">>/mntdir/$i
ls /mntdir && ls /var/www/html && df -h|grep labx >> /mntdir/$i

echo "cat /etc/hosts" >> /mntdir/$i
cat /etc/hosts >> /mntdir/$i

echo "systemctl status firewalld" >> /mntdir/$i
systemctl status firewalld>> /mntdir/$i

echo "getenforce">>/mntdir/$i
getenforce >> /mntdir/$i

echo "systemctl status httpd" >> /mntdir/$i
systemctl status httpd >> /mntdir/$i

echo "exportfs -va" >> /mntdir/$i
exportfs -va >> /mntdir/$i

echo "#### End report for $i">>/mntdir/$i

