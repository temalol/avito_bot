#!/bin/bash

export LC_ALL=en_US.UTF-8
export PATH=$PATH:/usr/local/Cellar/python/3.7.4/Frameworks/Python.framework/Versions/3.7/bin
uagent="Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1"
proxy=https://log:pass:8888
items_num=$(diff items-old items | grep '>' | wc -l)
items_num=$((items_num+1))
cnt=1
max_page_views=15

while [ $items_num -gt $cnt ]
	do
	item_id=$(diff items-old items | grep '>' | cut -d" " -f 2 | sed -n $cnt'p' )
	/usr/local/bin/wget --quiet --user-agent=$uagent -O html_item_page "https://m.avito.ru/$item_id"
	item=$(grep -o -E 'name="description" content=".{0,90}' < html_item_page | cut -d':' -f1 | cut -d'"' -f4)
	price=$(grep -o 'price:amount" content="[0-9]*' < html_item_page | cut -d'"' -f3)
	views=$(grep -o 'Просмотров: <!-- -->[0-9]*' < html_item_page | cut -d '>' -f2)
	echo "$item $price https://m.avito.ru/$item_id Views:$views" >> items_log
	
	is_already_sended=$(grep $item_id < telegram_sent)
		if [ $views -le $max_page_views ] && [ -z "$is_already_sended" ]
			then
			https_proxy=$proxy telegram-send -g "$item  | Price $price ₽ | https://m.avito.ru/$item_id | Views $views"
			echo $item_id >> telegram_sent
		fi
	cnt=$((cnt+1))
	done
