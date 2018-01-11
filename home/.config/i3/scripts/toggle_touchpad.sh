#!/bin/bash
name=$(xinput --list --name-only | grep Touchpad)
if xinput --list-props "$name" | grep --silent 'Device Enabled.*:.*1$'; then
	xinput --disable "$name";
else
	xinput --enable "$name";
fi
