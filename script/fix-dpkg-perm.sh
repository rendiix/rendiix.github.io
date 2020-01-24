#!/data/data/com.termux/files/usr/bin/bash
# File       : fix-dpkg-perm.sh
# Author     : rendiix <vanzdobz@gmail.com>
# Create date:  6-Jul-2019 19:00
# fix-dpkg-perm.sh
# Copyright (c) 2019 rendiix <vanzdobz@gmail.com>
#
#      DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#               Version 2, December 2004
#
# Everyone is permitted to copy and distribute verbatim or 
# modified copies of this license document,and changing it
# is allowed as long as the name is changed.
#
#      DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#           TERMS AND CONDITIONS FOR COPYING,
#             DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.

unset LD_PRELOAD

if [ -z "$1" ]; then
	echo -e "Usage: $0 [file or dir]"
	exit 1
fi
USER=$(whoami)
USER_INPUT="$1"
INPUT=$(realpath $USER_INPUT)
NO='\033[00m';ME='\033[31m';HI='\033[32m';KU='\033[33m'BI='\033[34m';CY='\033[36m';PU='\033[37m'
MET='\033[01;31m';HIT='\033[01;32m';KUT='\033[01;33m';BIT='\033[01;34m';CYT='\033[01;36m';PUT='\033[01;37m';MGT='\033[01;35m'

function checkstorage() {
	ls $HOME/storage/shared > /dev/null 2>&1
}

function check_prerequisite() {
	echo -e "checking weather termux has storage-permissions...\c"
	while checkstorage; [ $? -ne 0 ];do
		echo -e "${ME} no${NO}\nplease grant permission to acces storage?"
		termux-setup-storage
	done
	sleep 1
	echo -e "${HI} yes${NO}"
	echo -e "checking weather tsu is installed...\c"
	if [ -z $(which tsu) ]; then
		echo -e "${ME} no${NO}\n\tinstalling tsu..\c"
		apt-get install tsu -y > /dev/null 2>&1
		echo -e "${ME} done${NO}"
	else
		echo -e "${HI} yes${NO}"
	fi

	echo -e "checking weather restorecon is present on your devive...\c"
	if [ -x "/system/bin/restorecon" ]; then
		echo -e "${HI} yes${NO}"
		TYPE_FIX=1
	else
		echo -e "${ME} no${NO}"
	fi
}

function resetviabackup() {
	TMPDIR=${HOME}/storage/shared/script/backup
	mkdir -p $TMPDIR
	cp -r $INPUT $TMPDIR/
	tsu -c rm -rf $INPUT
	cp -r $TMPDIR/* $INPUT
	rm -rf $TMPDIR
	echo "done"
}

function viarestorecon() {
	tsu -c chown -R $USER:$USER $INPUT
	tsu -c /system/bin/restorecon -DRFv $INPUT
}


check_prerequisite
INPUT=$(realpath $USER_INPUT)
if [ "$TYPE_FIX" = "1" ]; then
	viarestorecon;
else
	resetviabackup;
fi
