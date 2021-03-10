
### remove old reports from /allservers
rm -rf /allservers/labx*

####get .local servers from powerdns database > hostnames
#ssh root@labx-ns-001.local mysql -u root -p -e "use powerdns; select * from records;"|grep "192.168.1"|grep -o "labx-.*.local">hostnames


for i in $(cat hostnames); do 

cat cr_report.sh | ssh root@$i; done  ### send commands to remote servers through ssh

cp /mntdir/labx-nfs-001.local /allservers #### copy local NFS report from /mntdir to /allservers

 
