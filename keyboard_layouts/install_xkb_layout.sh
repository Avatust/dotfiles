#!/bin/zsh

USAGE="\
USAGE: $0 [-r] [-h] [-s xkb_source] [-d xkb_destination]
          [-S layout] [-R rule]

    -r  uses relative path links, absolute otherwise

    -h  shows this message

    -s  takes a path to an xkb directory, it has to contain:
          symbols/  with layouts to be copied
          rules/{base,evdev}.xml
        if not provided, tries to use ./xkb or ../keyboard_layouts/xkb

    -d  place where to install layouts and descriptions
        normally /usr/share/X11/xkb

    -S  if specified, does link contents of the xkb_source and
        copies this file into xkb_destination/symbols/

    -R  if specified, does link contents of the xkb_source and
        copies this file into xkb_destination/rules/
"

# defaults
XKB_SRC=$( ([ -d './xkb' ] && echo "$(pwd)/xkb") ||
           ([ -d '../keyboard_layouts' ] && echo "$(cd .. && pwd)/keyboard_layouts/xkb"))
XKB_DST="/usr/share/X11/xkb/"
REL=
LAYOUT=
RULE=

# parse options
while getopts ":rhs:d:S:R:" opt; do
  case ${opt} in
    r ) REL='--relative';;
    h ) echo $USAGE
        exit 0;;

    s ) XKB_SRC="$OPTARG";;
    d ) XKB_DST="$OPTARG";;

    S ) LAYOUT="$OPTARG";;
    R ) RULE="$OPTARG";;

    \?) echo $USAGE 1>&2
        exit 1;;
    : ) echo "Option -$OPTARG requires an argument." >&2
        exit 1;;
  esac
done

# checks
[ -d "$XKB_DST"         ] || (echo "Destination '$XKB_DST' does not exist!" >&2         && exit 1)
[ -d "$XKB_DST/symbols" ] || (echo "Destination '$XKB_DST/symbols' does not exist!" >&2 && exit 1)
[ -d "$XKB_DST/rules"   ] || (echo "Destination '$XKB_DST/rules' does not exist!" >&2   && exit 1)


[ -n "$LAYOUT" ] && ([ -f "$LAYOUT" ] || (echo "'$LAYOUT' is not a regular file!" >&2 && exit 1 ))
[ -n "$RULE"   ] && ([ -f "$RULE"   ] || (echo "'$RULE' is not a regular file!" >&2   && exit 1 ))
# checks for XKB_SRC left for later

# implementation
if [ -f "$LAYOUT" ] || [ -f "$RULE" ]; then
  [ -f "$LAYOUT" ] && ln --symbolic --backup=numbered $REL "$(realpath $LAYOUT)" "$XKB_DST/symbols/$(basename $LAYOUT)"
  [ -f "$RULE" ] && ln --symbolic --backup=numbered $REL "$(realpath $RULE)" "$XKB_DST/rules/$(basename $RULE)"
else
  # checks
  [ -d "$XKB_SRC" ] || (echo "'$XKB_SRC' is an invalid path to xkb source directory!" >&2 && exit 1)
  [ -d "$XKB_SRC/symbols" ] || (echo "'$XKB_SRC/symbols' does not exist!" >&2 && exit 1)
  [ -f "$XKB_SRC/rules/base.xml"  ] || (echo "'$$XKB_SRC/rules/base.xml' does not exist!" >&2 && exit 1)
  [ -f "$XKB_SRC/rules/evdev.xml" ] || (echo "'$$XKB_SRC/rules/evdev.xml' does not exist!" >&2 && exit 1)

  for layout in "$XKB_SRC"/symbols/*; do
    ln --symbolic --backup=numbered $REL "$(realpath $layout)" "$XKB_DST/symbols/$(basename $layout)"
  done

  for rule in "$XKB_SRC"/rules/{base,evdev}.xml; do
    ln --symbolic --backup=numbered $REL "$(realpath $rule)" "$XKB_DST/rules/$(basename $rule)"
  done
fi
