#!/bin/bash

vip_cnt=$(wc -l < vip_items)

while [ $vip_cnt -gt 0 ]
	do
		vip_id=$(head -n 1 < vip_items)
		grep -v $vip_id < items > items_cpy
		grep -v $vip_id < vip_items > vip_items_cpy
		mv items_cpy items
		mv vip_items_cpy vip_items
		vip_cnt=$(wc -l < vip_items)
	done

rm vip_items
head -n 7 < items > items_cpy
mv items_cpy items
