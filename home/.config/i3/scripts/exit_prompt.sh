#!/bin/bash

answer=$(echo -e 'NO\nYES' | dmenu -i -p "Are you sure you want to logout?")
if [ "$answer" == "YES" ]; then
	i3-msg exit
fi
