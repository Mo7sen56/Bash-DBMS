#!/usr/bin/bash

###Entry point for DBMS

clear
. ./helpers.sh
PS3="Please enter a choice: "
connectDbName=""

echo "  ____            _       ____  ____  __  __ ____  
 | __ )  __ _ ___| |__   |  _ \| __ )|  \/  / ___| 
 |  _ \ / _  / __| '_ \  | | | |  _ \| |\/| \___ \ 
 | |_) | (_| \__ \ | | | | |_| | |_) | |  | |___) |
 |____/ \__,_|___/_| |_| |____/|____/|_|  |_|____/ "

echo 
options=("Create database" "List databases" "Connect to database" "Drop database" "Exit")
select choice in "${options[@]}"
do
	case $REPLY in
		1) . ./createdb.sh;;
		2) . ./listdbs.sh;;
		3) . ./connect.sh
		   printMainMenu;;
		4) . ./dropdb.sh;;
		5) echo "Bye"
			exit;;
		*) echo "Please enter a valid option";;
	esac	
done
