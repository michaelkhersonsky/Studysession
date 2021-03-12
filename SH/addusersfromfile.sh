#!/bin/bash
######## This script reads from file usersfile which is expected to come as an argument $1, and should be in the same directory
​
CreateGroups() {    #Declare functions
    local j=1
   
    while [ $j -le $linecount ]
        do
        #Processing primary groups
        groupname=$(echo ${ugid[$j]}|cut -d" " -f1)
        groupid=$(echo ${ugid[$j]}|cut -d" " -f2)
        if [ $groupname != "" ]
            then
            groupadd -g$groupid $groupname 2>@1 && echo "$groupname GID $groupid created" || echo "$groupname GID $groupid exists"
        fi
        #Processing secondary groups
        groupname=$(echo ${usgid[$j]}|cut -d" " -f1)
        groupid=$(echo ${usgid[$j]}|cut -d" " -f2)
    
        if [ "$groupname" != "" ]
            then
            groupadd -g$groupid $groupname 2>@1 && echo "$groupname GID $groupid created" || echo "$groupname GID $groupid exists"
            fi
        ((j++))
    done
}
CreateUsers () {
    local j=1
    while [ $j -le $linecount ]
        do
        pgroupname=$(echo ${ugid[$j]}|cut -d" " -f1)
        sgroupname=$(echo ${usgid[$j]}|cut -d" " -f1)
        #
        echo "Requested User ${uname[$j]}, UID ${uuid[$j]}, Primary $pgroupname, Secondary $sgroupname"
        if  grep -q ${uname[$j]} /etc/passwd
            then
            usermod -u "${uuid[$j]}" -g "$pgroupname" -G "$sgroupname" -c "${ucomm[$j]}" -s "${ushell[$j]}" ${uname[$j]}
            else
            useradd -u "${uuid[$j]}" -g "$pgroupname" -c "${ucomm[$j]}" -s ${ushell[$j]} ${uname[$j]}
            usermod -a -G $sgroupname ${uname[$j]}
        fi
        ((j++))
    done
}
SetPasswords() {
    local j=1
    while [ $j -le $linecount ]
        do
        if [ "${upass[$j]}" == "" ]
            then 
            echo "Adding: ${uname[$j]}, UID: ${uuid[$j]}, Primary: ${ugid[$j]}, Secondary: ${usgid[$j]}, Comment: ${ucomm[$j]}, No Password, Shell: ${ushell[$j]}" && echo "...Done" #If group name does not exist
        else
            usermod -p $(echo ${upass[$j]}| openssl passwd -stdin) ${uname[$j]} 
            echo "Adding: ${uname[$j]}, UID: ${uuid[$j]}, Primary: ${ugid[$j]}, Secondary: ${usgid[$j]}, Comment: ${ucomm[$j]}, Password: ${upass[$j]}, Shell: ${ushell[$j]}" && echo "...Done" #If group name does not exist
        fi
        ((j++))
    done
}
ShowResult (){
    # local j=1
    # while [ $j -le $linecount ]
    #     do
    #     echo ${uname[$j]} 
    #     grep ${uname[$j]} /etc/passwd
    #     grep ${uname[$j]} /etc/shadow
    #     grep ${uname[$j]} /etc/group
    #     id -Gn ${uname[$j]} 
    #     ((j++)) 
    # done
    echo "Users -----------------"
    echo
    tail -13 /etc/passwd
    echo "Groups -----------------"
    echo
    tail -13 /etc/group
    echo "GShadow -----------------"
    echo
    tail -13 /etc/gshadow
}
SetSudoers (){
​
    echo "mohammad        ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/access
    echo "%engineering    ALL=(ALL)       ALL" >> /etc/sudoers.d/access
    echo "root    ALL=(chantelle) NOPASSWD: ALL"  >> /etc/sudoers.d/access
    cat /etc/sudoers.d/access
    visudo -c -f /etc/sudoers.d/access
}
SetPasswordExpiration(){
    local j=1
    while [ $j -le $linecount ]
        do
        echo
        echo ${uname[$j]}
        pgroupname=$(echo ${ugid[$j]}|cut -d" " -f1)
      if  [ "${uname[$j]}" == "mohammad" ]
        then
        #want to address more fields to eliminate possible previous settings
    
        NewExp=$(date +%D -d "+90 days")
        chage -m0 -I-1 -M180 -W10 -E$NewExp ${uname[$j]}
        chage -l ${uname[$j]}
     
​
        else
         #want to address more fields to eliminate possible previous settings
        chage -m0 -E-1 -I-1 -M180 -W10 ${uname[$j]}
        chage -l ${uname[$j]}
      fi
     ((j++)) 
    done
}
CreateProjectDirs(){
    echo "Creating directories and updating PATH ------------------"
    echo
    mkdir -p -m755 "/projects/hiring"
    mkdir -p -m755 "/projects/dcm"
    #Hiring Secondary group users get .bash_profile PATH updated
    sgidstring=($(tail /etc/group|grep "hiring"|cut -d: -f4|tr ',' '\n'))
​
    for i in "${sgidstring[@]}"
    do
    echo "$i"
        homestring=$(tail /etc/passwd|grep "$i"|cut -d: -f6)
        echo "PATH=\$PATH:/projects/hiring" >> $homestring/.bash_profile
        echo "export PATH">> $homestring/.bash_profile
        tail -2 $homestring/.bash_profile 
   done
    #Migration Secondary group users get .bash_profile PATH updated
    sgidstring=($(tail /etc/group|grep "migration"|cut -d: -f4|tr ',' '\n'))
    for i in "${sgidstring[@]}"
    do
    echo "$i",
        homestring=$(tail /etc/passwd|grep "$i"|cut -d: -f6)
        echo $homestring/.bash_profile
        echo "PATH=\$PATH:/projects/dcm" >> $homestring/.bash_profile
        echo "export PATH">> $homestring/.bash_profile
        tail -2 $homestring/.bash_profile
   done
}
CreateNewContractors (){
    echo "Mohammad creating 5 contractors"
    echo
    sleep 1
    #I didn't figure out more effective way of passing ball to mohammad user in a loop, so cheated with heredocs
    sudo -i -u mohammad bash << EOF
whoami
sudo useradd contractor1
sudo chage -m0 -E-1 -I-1 -M180 -W10 contractor1
sudo useradd contractor2
sudo chage -m0 -E-1 -I-1 -M180 -W10 contractor2
sudo useradd contractor3
sudo chage -m0 -E-1 -I-1 -M180 -W10 contractor3
sudo useradd contractor4
sudo chage -m0 -E-1 -I-1 -M180 -W10 contractor4
sudo useradd contractor5
sudo chage -m0 -E-1 -I-1 -M180 -W10 contractor5
EOF
whoami
    # useradd contractor$i
}
MakeHRGroupAdmin (){
 echo "Chantelle becomes group admin "
 echo
 sleep 1
 gpasswd -A chantelle engineering
 gpasswd -A chantelle hr
 gpasswd -A chantelle devops
 gpasswd -A chantelle consultants
 gpasswd -A chantelle hiring
 gpasswd -A chantelle migration
    #same with Chantelle, tere should be a more effective way
    sudo -i -u chantelle bash << EOF
whoami
​
sudo usermod -G consultants contractor1
sudo usermod -G consultants contractor2
sudo usermod -G consultants contractor3
sudo usermod -G consultants contractor4
sudo usermod -G consultants contractor5
# gpasswd -M contractor1,contractor2,contractor4,contractor4,contractor5 consultants
EOF
whoami
}
    # Start here
 
    if [ -z $* ] # if no arguments, say something
        then
        echo "Missing argument: filename"
        exit
    fi
    filename=$1
    linecount=$(wc -l $filename|cut -d" " -f1) ######## Checking data file length
    echo $filename, $linecount "users total in file" $filename
​
    for ((i=1;i<=$linecount;i++)) ######## Create data pool, used arrays
    do
        string=$(head -$i $filename|tail -1)
        uname[$i]=$(echo $string|cut -d"," -f1)
        uuid[$i]=$(echo $string|cut -d"," -f2)
        ugid[$i]=$(echo $string|cut -d"," -f3)
        usgid[$i]=$(echo $string|cut -d"," -f4)
        ucomm[$i]=$(echo $string|cut -d"," -f5)
        upass[$i]=$(echo $string|cut -d"," -f6)
        ushell[$i]=$(echo $string|cut -d"," -f7)
    done
echo "Creating Groups---------------------"
​
CreateGroups  ##### Let's go
read -p "Press any key"
CreateUsers
read -p "Press any key"
SetPasswords
read -p "Press any key"
echo "Groups & Users created ---------------------"
ShowResult
read -p "Press any key"
​
SetSudoers
read -p "Press any key"
SetPasswordExpiration
read -p "Press any key"
​
CreateProjectDirs
read -p "Press any key"
CreateNewContractors
​
ShowResult
read -p "Press any key"
​
MakeHRGroupAdmin
ShowResult
read -p "Press any key"
####### that's all, folks. Go submit
