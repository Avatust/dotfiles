#!/bin/bash

PRIMARY=eDP1
EXTERN=HDMI1

function status {
    xrandr | grep -E "\b$1\b (dis)?connected "
}

function is_connected {
    echo $1 | grep -q " connected "
}

function is_active {
    echo $1 | grep -Eq " connected [^0-9]*[0-9]+x[0-9]+"
}

function are_same {
    # strict version:
    # outputs the match or the whole expression if none
    # res_and_pos=$( echo $1 | sed -E "s/.* connected [^0-9]*([0-9]+x[0-9]+\+[0-9]+\+[0-9]+).*/\1/" )
    # echo $2 | grep -q " $res_and_pos "

    # only position is equal
    # if monitors have different resolution seems that --auto option for xrandr
    # uses each output's hightest resolution and then pads the rest
    pos=$( echo $1 | sed -E "s/.* connected [^0-9]*[0-9]+x[0-9]+.([0-9]+).([0-9]+).*/.\1.\2/" )
    echo $2 | grep -Eq " connected [^0-9]*[0-9]+x[0-9]+$pos "
}

primary=$(status $PRIMARY)
extern=$(status $EXTERN)

echo primary status: "$primary"
echo extern status: "$extern"

echo -n "primary active: "; (is_active "$primary") && echo true || echo false
echo -n "extern active: "; (is_active "$extern") && echo true || echo false

echo -n "primary connected: "; (is_connected "$primary") && echo true || echo false
echo -n "extern connected: "; (is_connected "$extern") && echo true || echo false

echo -n "are same: "; (are_same "$primary" "$extern") && echo true || echo false

echo

if is_active "$primary"
then
    echo primary active

    if (is_connected "$extern") && ! (are_same "$primary" "$extern")
    then
        echo extern connected and not cloned
        echo cloning primary and extern
        xrandr --auto --output $PRIMARY --same-as $EXTERN
    else
        echo outputs are cloned or extern is not connected
        echo turning primary off
        xrandr --output $PRIMARY --off
    fi
else
    echo primary not active

    if is_connected "$extern"
    then
        echo extern connected
        echo turning primary on and left of extern
        xrandr --auto --output $EXTERN --right-of $PRIMARY
    else
        echo extern not connected
        echo turning primary on
        xrandr --auto
    fi
fi

