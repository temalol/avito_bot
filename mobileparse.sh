#!/bin/bash
export LC_ALL=en_US.UTF-8

uagent="Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1" 

url=""

#download page via wget
/usr/local/bin/wget --quiet --user-agent=$uagent -O html_page $url

#parse all items
cat html_page | grep -o '"value":{"id":[0-9]*' | head -n 15 | cut -d ":" -f3 > items

#parse vip items
cat html_page | grep -o 'vip","value":{"id":[0-9]*' | cut -d ":" -f3 > vip_items

#parse highlight items
cat html_page | grep -E -o "highlight.{0,150}" | grep -o 'itemId=[0-9]*' | cut -d "=" -f2 >> vip_items

#parse xl items
cat html_page | grep -o 'xlItem","value":{"id":[0-9]*' | cut -d":" -f 3 >> vip_items

sh delete_adverts.sh

if [[ ! -f items-old ]]
then
	mv items items-old
fi
rm html_page
