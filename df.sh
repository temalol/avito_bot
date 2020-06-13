#!/bin/bash

cd /Users/artem/redmi_samara

sh mobileparse.sh

diff_num=$(diff items-old items | grep '>' | cut -d" " -f 2 )
dateup=$(date +%b-%d'  '%H:%M:%S)

	if [ -n "$diff_num" ]
	then
		diff items-old items >> diff_log
		echo $dateup >> diff_log
		diff items-old items | grep '>' | cut -d" " -f 2  >> updateslog
		echo $dateup >> updateslog
		sh send_telegram.sh
		mv items items-old
	else
		echo "No new Updates $dateup" >> updateslog
	fi
