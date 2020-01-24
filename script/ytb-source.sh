#!/data/data/com.termux/files/usr/bin/bash
# File       : debian-package/package/ytb-player/ytb-source.sh
# Author     : rendiix <vanzdobz@gmail.com>
# Create date: 10-Jul-2019 14:18
# ./ytb-player.sh
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

NO='\033[00m';ME='\033[31m';HI='\033[32m';KU='\033[33m';BI='\033[34m';CY='\033[36m';PU='\033[37m';TB='\e[1m';MG='\033[35m';AB='\033[90m';B1='\033[48;5;234m';B2='\033[48;5;235m'
CONFIG_DIR=${HOME}/.ytb-player
CONFIG_FILE=${CONFIG_DIR}/youtub.cfg

if [[ ! -d "$CONFIG_DIR" ]]; then
	mkdir -p $CONFIG_DIR
fi

if [ ! -f "${CONFIG_DIR}/api.key" ]; then
	touch ${CONFIG_DIR}/api.key
fi

if [ -z "$(which youtube-dl)" ]; then
	pip install youtube-dl
	fi

if [ -z "$(cat ${CONFIG_DIR}/api.key)" ]; then
	# Ini key saya :( jangan disalah gunakan ya gan
	echo "API_KEY GANTI PAKE PUNYA KALIAN" > ${CONFIG_DIR}/api.key
	fi
api_key="$(cat ${CONFIG_DIR}/api.key)"

function TEST_ERROR(){
google_url="https://console.developers.google.com/apis/library"
curl -s "https://www.googleapis.com/youtube/v3/search?part=snippet&key=${api_key}&maxResults=1&textFormat=plainText" > ${CONFIG_DIR}/tests.tmp
testcon=$(cat ${CONFIG_DIR}/tests.tmp)

if [ -z "$testcon" ]; then
	echo -e "${TB}${ME}Tidak dapat terhubung ke internet!${No}\nPeriksa koneksi jaringan dan coba lagi."
	exit 1
fi
testerr="$(cat ${CONFIG_DIR}/tests.tmp | jq -r .error.code)"
if  [  "$testerr" != "null" ]; then
	echo -en "\n${TB}$(basename $0): "
	errreason=$(cat ${CONFIG_DIR}/tests.tmp | jq -r .error.errors[].reason) >/dev/null
	errmessage=$(cat ${CONFIG_DIR}/tests.tmp | jq -r .error.errors[].message)
	if [ "$errreason" = "keyInvalid" ]; then
		echo -e "${TB}${ME}API KEY salah!${NO}"
	elif [ "$errreason" = "keyExpired" ]; then
		echo -e "${TB}${ME}API KEY expired!${NO}"
	elif [ "$errreason" = "quotaExceeded" ]; then
		echo -en "${TB}${ME}API KEY habis/limit!${NO}\nSilahkan coba kembali besok atau "
	else
	    echo -e "${TB}${ME}API KEY bermasalah!${NO}"
	fi
	echo -e "Ganti ${KU}${CONFIG_DIR}/api.key${NO} dengan key anda"
	echo -e "
   ERROR CODE : $testerr
       REASON : $errreason
ERROR MESSAGE : $errmessage"
	echo -e "\n[${HI}m${NO}]asukkan API_KEY, [${HI}b${NO}]uat API_KEY, [${HI}enter${NO}] keluar"
	read -n 1 -p "ytb-player: " bapi
	if [ "$bapi" = "b" ]; then
		termux-open-url $google_url
		exit 0
	elif [ "$bapi" = "m" ]; then
		echo ""
		read -p "API_KEY: " INPUTAPI
		echo "$INPUTAPI" > ${CONFIG_DIR}/api.key
		echo -e "\n${HI}Done!"
		sleep 1
		exit 0
	else
		echo ""
		exit 1
	fi
fi
}

TEST_ERROR

MAX_PENCARIAN=10
player="mpv"

searchterm=$1

if [[ "$searchterm" = "" ]]; then
	searchterm="Musik populer"
fi

api_url="https://www.googleapis.com/youtube/v3/"
video_url="https://www.youtube.com/watch?v="
HALAMAN=1
TIPE_PENCARIAN="search"

function BRS() {
devider="$(printf '%*s' $(tput cols) | tr " " "-")"
echo "$devider"
}

function SEARCH_MAIN () {
	searchquery="$(echo $searchterm | tr " " "+")"
	if [[ ! -z "$1" ]]; then
		PAGE_C="--data-urlencode pageToken=$1"
	fi

curl -sG "${api_url}search/" \
			--data-urlencode "key=$api_key" \
			--data-urlencode "part=snippet" \
			--data-urlencode "type=video" \
			--data-urlencode "safeSearch=none" \
			--data-urlencode "maxResults=$MAX_PENCARIAN" \
			--data-urlencode "fields=items(snippet/title,snippet/channelTitle,snippet/description,snippet/publishedAt,id/videoId),nextPageToken,prevPageToken" \
			--data-urlencode "q=$searchquery" ${PAGE_C} > ${CONFIG_DIR}/data.tmp
			
prev=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].prevPageToken")
next=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].nextPageToken")
DATA_PENCARIAN
}

function DATA_PENCARIAN () {
	vidids=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].items[].id.videoId")
	mapfile -t vidids_array < <( printf "%s\n" "$vidids" )
	vidtitles=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].items[].snippet.title")
	mapfile -t vidtitles_array < <( printf "%s\n" "$vidtitles" )
	channeltitles=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].items[].snippet.channelTitle")
	mapfile -t channeltitles_array < <( printf "%s\n" "$channeltitles" )
	pubdates=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].items[].snippet.publishedAt")
	mapfile -t pubdates_array < <( printf "%s\n" "$pubdates" )
	descriptions=$(cat ${CONFIG_DIR}/data.tmp | jq -r "[.][].items[].snippet.description")
	mapfile -t descriptions_array < <( printf "%s\n" "$descriptions" )
	printf -v vidids_csv ",%s" "${vidids_array[@]}"
	vidids_csv=${vidids_csv:1}
	durations=$(curl -sG "${api_url}videos/" \
	--data-urlencode "key=$api_key" \
	--data-urlencode "id=$vidids_csv" \
	--data-urlencode "part=contentDetails" \
	--data-urlencode "fields=items(contentDetails/duration)" 2>/dev/null | jq -r "[.][].items[].contentDetails.duration" | sed -e 's/P\|T\|S//g; s/D\|H\|M/:/g' -e 's/\<[0-9]\>/0&/g')
	mapfile -t durations_array < <( printf "%s\n" "$durations" )
	TAMPILAN_PENCARIAN
}

function HEADER_BANNER () {
bcol=$(($(tput cols)-2))
clear
title1="* YUTUP-PLAYER *"
title2="* by rendiix *"
printf "${TB}${ME}${B2}%0.s#${NO}" $(seq 1 $(tput cols))
printf "${TB}${ME}${B2}#%*s%*s#${NO}\n" $(((${#title1}+$bcol)/2)) "$title1" $(($bcol-(${#title1}+$bcol)/2))
printf "${TB}${ME}${B2}#%*s%*s#${NO}\n" $(((${#title2}+$bcol)/2)) "$title2" $(($bcol-(${#title2}+$bcol)/2))
printf "${TB}${ME}${B2}%0.s#${NO}" $(seq 1 $(tput cols))
printf "${TB}${ME}%$(tput cols)s\n" "v<ganti_versi>"
}

function BANNER_INFO() {
text_info="$1"
clms=$(tput cols)
printf "${TB}${KU}%*s%*s${NO}\n" $(((${#text_info}+$clms)/2)) "$text_info" $(($clms-(${#text_info}+$clms)/2))
echo
}

function MENU_PENCARIAN () {
		nexttext=""
		if [[ "$next" != "null" ]]; then
			nexttext="Masukkan angka atau [${HI}n${NO}] halaman selanjutnya"
		fi
		if [[ "$prev" != "null" ]]; then
			nextsep=""
			if [[ "$nexttext" != "" ]]; then
				nextsep=", "
			fi
			nexttext="$nexttext$nextsep[${HI}p${NO}] halaman sebelumnya"
		fi
		nexttext="$nexttext, [${HI}c${NO}]ari lagi, [${HI}q${NO}] keluar"
		nexttext="$nexttext"
		echo -e $nexttext
}

function MENU_COMMENT () {
		nexttext=""
		if [[ "$next_comment" != "null" ]]; then
			nexttext="[${HI}h${NO}]alaman selanjutnya"
		fi
		if [[ "$prev_comment" != "null" ]]; then
			nextsep=""
			if [[ "$nexttext" != "" ]]; then
				nextsep=", "
			fi
			nexttext="$nexttext$nextsep[${HI}j${NO}] halaman sebelumnya"
		fi
		nexttext="$nexttext, [${HI}b${NO}] kembali, [${HI}q${NO}] keluar"
		nexttext="$nexttext"
		echo -e $nexttext
}

function DESCONVERT() {
jc=${#1}
pecahan=""
nilai=""
if [[ ! -n ${input//[0-9]/} ]]; then
	if [ "$jc" -lt 4 ]; then
		pecahan=""
		nilai=$1
	elif [[ "$jc" =~ ^[4-6] ]]; then
		pecahan=rb
		nilai=$(echo "scale=1; $1/1000" | bc | tr "." "," | sed "s/,0//")
	elif [ "$jc" -gt 6 ]; then
		pecahan=jt
		nilai=$(echo "scale=1; $1/1000000" | bc | tr "." "," | sed "s/,0//")
	fi
else
	pecahan=""
	nilai=$1
fi
echo "${nilai} ${pecahan}"
}

function  DETAIL_VIDEO() {
	HEADER_BANNER;
	BANNER_INFO "MENU DETAIL VIDEO"
	vidid=${vidids_array[$1]}
	vidtitle=${vidtitles_array[$1]}
	curl -sG "${api_url}videos/" \
	--data-urlencode "key=$api_key" \
	--data-urlencode "id=$vidid" \
	--data-urlencode "part=statistics" > ${CONFIG_DIR}/detail.tmp
	viewc=$(DESCONVERT "$(cat ${CONFIG_DIR}/detail.tmp |  jq -r "[.][].items[].statistics.viewCount")")
	likec=$(DESCONVERT "$(cat ${CONFIG_DIR}/detail.tmp |  jq -r "[.][].items[].statistics.likeCount")")
	dislc=$(DESCONVERT "$(cat ${CONFIG_DIR}/detail.tmp |  jq -r "[.][].items[].statistics.dislikeCount")")
	comc=$(DESCONVERT "$(cat ${CONFIG_DIR}/detail.tmp |  jq -r "[.][].items[].statistics.commentCount")")
	echo -e "JUDUL     : ${ME}${vidtitles_array[$1]}${NO}"
	echo -e "DURASI    : ${durations_array[$1]}"
	echo -e "CHANNEL   : ${channeltitles_array[$1]}"
	pdate=$(date -d "${pubdates_array[$1]}" "+%A %-d %B, %Y")
	echo -e "UPLOAD    : $pdate\n"
	#echo -e "LINK      : $video_url${vidids_array[$1]}\n"
	echo -e "• ${viewc}x ditonton 📺 • ${HI}$likec${NO} 👍 • ${ME}$dislc${NO} 👎 • ${KU}$comc 💬\n${NO}"
	echo -e "DESKRIPSI : ${descriptions_array[$1]}\n"
	MENU_MUSIC
}

function GET_TOPCOMMENT() {
	HEADER_BANNER
	BANNER_INFO "MENU KOMENTAR"
	if [ ! -z "$1" ]; then
		COMMENT_CONTROL="--data-urlencode pageToken=$1"
		fi
	curl -sG "${api_url}commentThreads/" \
	--data-urlencode "part=snippet" \
	--data-urlencode "videoId=$vidid" \
	--data-urlencode "textFormat=plainText" \
	--data-urlencode "key=$api_key" \
	--data-urlencode "maxResults=10" $COMMENT_CONTROL > ${CONFIG_DIR}/comment.tmp
	
	author1=$(cat ${CONFIG_DIR}/comment.tmp | jq -Mr "[.][].items[].snippet.topLevelComment.snippet.authorDisplayName")
	mapfile -t author < <( printf "%s\n" "$author1" )
	comm1=$(cat ${CONFIG_DIR}/comment.tmp | jq -Mr "[.][].items[].snippet.topLevelComment.snippet.textDisplay")
	mapfile -t comm < <( printf "%s\n" "$comm1" )
	reply_count1="$(cat ${CONFIG_DIR}/comment.tmp | jq -Mr "[.][].items[].snippet.totalReplyCount")"
	mapfile -t reply_count < <( printf "%s\n" "$reply_count1" )
	like_count1="$(cat ${CONFIG_DIR}/comment.tmp | jq -Mr "[.][].items[].snippet.topLevelComment.snippet.likeCount")"
	mapfile -t like_count < <( printf "%s\n" "$like_count1" )
	reply_date1=$(cat ${CONFIG_DIR}/comment.tmp | jq -Mr "[.][].items[].snippet.topLevelComment.snippet.publishedAt")
	mapfile -t reply_date < <( printf "%s\n" "$reply_date1" )
	next_comment=$(cat ${CONFIG_DIR}/comment.tmp | jq -r "[.][].nextPageToken")
	prev_comment=$(cat ${CONFIG_DIR}/comment.tmp | jq -r "[.][].prevPageToken")

	for list in "${!author[@]}"; do
		nom=$(( $list + 1 ))
		echo -e "${TB}${AB}\n$(BRS)${NO}\n"
		echo -e "${TB}${CY}${author[$list]}${NO}\n"
		echo -e "${TB}${comm[$list]}${NO}"
		echo -e "\n${HI}${like_count[$list]}${NO} 👍 • ${ME}${reply_count[$list]}${NO} 💬"
	done
		echo -e "${TB}${AB}\n$(BRS)${NO}"
	MENU_COMMENT
	INPUT_MASUKAN
}

function MENU_MUSIC () {
	echo -e "[${HI}m${NO}]ainkan , [${HI}t${NO}]onton video, [${HI}u${NO}]nduh, [${HI}l${NO}]ihat komentar, [${HI}c${NO}]ari lagi, [${HI}k${NO}]embali ke menu pencarian, [${HI}q${NO}] keluar\n"
	INPUT_MASUKAN
}

function INPUT_MASUKAN () {
	if [[ ! -z "$1" ]]; then
		echo $1
	fi
	echo -e "\n${TB}${KU}ytb-player:${NO} \c"
	read userinput
	FUNGSI_MASUKAN_UTAMA
}

function TAMPILAN_PENCARIAN () {
	HEADER_BANNER
	BANNER_INFO "MENU UTAMA"
	clm=$(tput cols)
	echo -e "Menampilkan hasil pencarian untuk: $searchterm"
	fields="$(( ${clm} - 21))"
	printf "${B1}%0.s-${NO}" $(seq 1 ${clm})
	printf "${B1}${TB}| ${KU}%-2s${PU} | ${KU}%-${fields}s${PU} | ${KU}%-9s${PU} |\n${NO}" "NO" "JUDUL LAGU" "DURASI"
	printf "${B1}%0.s-" $(seq 1 ${clm})
	for list in "${!vidids_array[@]}"; do
		nomer=$(( $list + 1 ))
		sep=" "
		if [ "$nomer" -ge 10 ]; then
			sep=""
		fi
		if [ "$(($nomer % 2))" -eq "0" ]; then
                W1=$B1
                W2=$MG
                else
                W1=$B2
                W2=$KU
        fi
        printf "${W1}| %-2s | %-${fields}s | %-9s |\n${NO}" "$nomer" "${vidtitles_array[$list]:0:${fields}}${name}" "${durations_array[$list]}"
	done
	printf "${B1}%0.s-${NO}" $(seq 1 ${clm})
	echo -e "\nHalaman: $HALAMAN\n"
	MENU_PENCARIAN
	INPUT_MASUKAN
}

function DOWNLOAD_MUSIC() {
echo -e "\nMengunduh: ${ME}${vidtitles_array[$playvid]}${NO}\nsilahkan tunggu"
youtube-dl -f bestaudio -o "/data/data/com.termux/files/home/storage/music/%(title)s.%(ext)s" --audio-format mp3 --extract-audio --audio-quality 0 --add-metadata $video_url${vidids_array[$playvid]}
if [ "$?" = 0 ]; then
	echo -e "\n${HI}Download sukses${NO}"
	sleep 2
	fi
}

function TONTON_VIDEO() {
	echo -e "\nMembuka: ${ME}${vidtitles_array[$playvid]}${NO}\n"
	termux-open-url $video_url${vidids_array[$playvid]}
}

function PLAY_MUSIC () {
    echo -e "
${TB}${PU}Kontrol Musik:
	[${HI}q${PU}] Stop
	[${HI}space${PU}] play/pause
	[${HI}m${PU}] Mute/unmute
	[${HI}←${PU}] [${HI}→${PU}] Seek
	[${HI}↑${PU}] [${HI}↓${PU}] SEEK
	[${HI}9${PU}] [${HI}0${PU}] Volume

${NO}Memainkan: ${ME}${vidtitles_array[$playvid]}${NO}"
    if [ -z "$DISPLAY" ]; then 
        $player --no-video $video_url${vidids_array[$playvid]}
        echo # insert newline to compensate for ^C
    else
        $player --no-video --player-operation-mode=pseudo-gui $video_url${vidids_array[$playvid]}
    fi
}

function FUNGSI_MASUKAN_UTAMA () {
	case $userinput in
		[1-9]|10 ) if [[ $userinput -le $MAX_PENCARIAN ]]; then
				playvid=$(( $userinput -1 ))
				DETAIL_VIDEO $playvid
				INPUT_MASUKAN
			else
				INPUT_MASUKAN "Nomor salah"
			fi;;
		b ) DETAIL_VIDEO $playvid;;
		h )
			if [[ "$next_comment" != "null" ]]; then
				HKOMEN=$(( HKOMEN + 1 ))
				GET_TOPCOMMENT $next_comment
			else
				INPUT_MASUKAN "Masukkan salah"
			fi
			;;
		j )
			if [[ "$prev_comment" != "null" ]]; then
				HKOMEN=$(( HKOMEN + 1 ))
				GET_TOPCOMMENT $prev_comment
			else
				INPUT_MASUKAN "Masukkan salah"
			fi
			;;
		n )
			if [[ "$next" != "null" ]]; then
				HALAMAN=$(( HALAMAN + 1 ))
				SEARCH_MAIN $next
			else
				INPUT_MASUKAN "Masukkan salah"
			fi
			;;
		m ) PLAY_MUSIC;
				TAMPILAN_PENCARIAN;;
		u ) DOWNLOAD_MUSIC;
			    TAMPILAN_PENCARIAN;;
		t ) TONTON_VIDEO;
			    TAMPILAN_PENCARIAN;;
		l ) GET_TOPCOMMENT;;
		p )
			if [[ "$prev" != "null" ]]; then
				HALAMAN=$(( HALAMAN - 1 ))
				SEARCH_MAIN $prev
			else
				INPUT_MASUKAN "Masukkan salah"
			fi;;
		c )
			read -p "Masukkan kata pencarian: " searchterm
			HALAMAN=1
			TIPE_PENCARIAN="search"
			SEARCH_MAIN;;
		k ) TAMPILAN_PENCARIAN;;
		q|:q|exit|close|quit )
			exit
			;;
		* ) 
			if [ -z "$userinput" ]; then
				searchterm="Musik terbaru"
			fi
			searchterm=$userinput
			HALAMAN=1
			TIPE_PENCARIAN="search"
			SEARCH_MAIN
			;;
	esac
}

SEARCH_MAIN
