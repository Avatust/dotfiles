# autostart i3 if on tty1 and the corresponding boot option was selected
if grep -q I3_ON_START /proc/cmdline && [[ "$(tty)" == '/dev/tty1' ]]; then
    exec startx
fi
