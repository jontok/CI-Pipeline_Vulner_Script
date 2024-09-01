#!/usr/bin/env bash
# Author: jontok
#                              _     
#    ___  ___ __ _ _ __    ___| |__  
#   / __|/ __/ _` | '_ \  / __| '_ \ 
#   \__ \ (_| (_| | | | |_\__ \ | | |
#   |___/\___\__,_|_| |_(_)___/_| |_|
#                                    
# SCANNING FOR SERVER VULNERABILITIES VIA DOMAIN-NAME
# 
# Features:
# - scan IPs
# - scan domainname
# - use .txt list
# - output as TXT
# - run with CI
#
#

set -e
args=()
nointeraction=$NOINTERACTION
output_format="$OUTPUT_FORMAT"

# set defaults for env settings
if [ -z "${nointeraction}" ];then
	nointeraction=false
fi
if [ -z "${output_format}" ];then
	output_format="txt"
fi


function showHelp {
	echo -e "Usage: ./scan.sh [OPTIONS]\n"
	echo -e "Interaction can be disabled with 'export NOINTERACTION=true'\n	"
	echo -e "The output file format can be set with the'export OUTPUT_FORMAT=[xml/txt]'\n"
	echo -e "Options:"
	echo -e "-h | --help		Show Help"
	echo -e "-d | --domain		Domain/IP Address to scan"
	echo -e "-f | --file		File to get Domains/IP Addresses"
	exit
}

function scanDomain {
	
	local domain=$1
	local spin=(".." "...")
	
	local output_flag="-oN"
	if [ $output_format == "xml" ];then
		output_flag="-oX"
	fi

	echo "Domain: $domain "
	nmap -sV --script vulners $domain $output_flag ${domain}_scan.${output_format} > /dev/null &
	pid=$!
	progressBar $pid
	echo "Scan Complete!"
	
}

function progressBar {
	local indicator="."
	local width=20
	local pid=$1
	local i=0
	while ps -p $pid > /dev/null
	do
		if [ $i -gt ${width-1} ]
		then
			i=1
			bar="\033[K"
		fi
		for j in i;do
			local bar="${bar}${indicator}"
		done
		printf "\r"
		printf "$bar" '%*s' "$width"  
		i=$((i+1))
		
		sleep .2
	done
	printf "\r\033[K"
}

function scanFromFile {
	local filename=$1
	local domains=()

	echo -e "Reading Domains:"
	while IFS= read -r line; do
		echo -e $line
		domains+=(${line})
	done < "$filename"

	echo -e "\n"
	if [ $nointeraction != true ];then
		read -p "Scan the Domains: y/n: " continue
		if [ $continue  != "y" ];then
			echo -e "Aborted"
			exit 0
		fi
	fi

	echo "Starting scan: "
	for domain in ${domains[@]}; do
		scanDomain $domain
	done
	echo "Done"
}

for arg in $@
do
	
	args+=($arg)
done

case "$args" in
	"-h" | "--help") 
		showHelp
		;;

	"-d" | "--domain") 
		scanDomain ${args[+1]}
		;;
	
	"-f" | "--file") 
		scanFromFile ${args[+1]}
		;;

	*)
		echo -e "RTFM - here it is: "
		showHelp
		;;
esac
# case args in
# 	"-h" | "--help") showHelp
# 	;;
# 	2|3) echo 2 or 3
# 	;;
# 	*) echo default
# 	;;
# esac

