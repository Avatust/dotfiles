#!/bin/zsh

USAGE=\
"Usage: $0 [-i] [-r] [-q] [-d] SOURCE_DIR DEST_DIR

    -i  interactive mode (ask about every file)

    -r  uses relative paths, absolute otherwise

    -q  quiet, does not comment progress

    -d  debugging mode, prints a lot of stuff

    SOURCE_DIR the top of the directory whose contents will symlinked to
               the DEST_DIR while preserving the structure

    DEST_DIR   the directory which will receive the symlinks (and backups);
               this directory must also exist but its contents need not"

source "$(dirname $0)"/helper_functions.sh

DEBUG='false'
VERBOSE='true'
ASK='false'
REL= # empty if absolute paths are to be used, for relative, the appropriate option for the ln command

SRCDIR="${@:(-2):1}" # second to last argument
DSTDIR="${@:(-1):1}" # last argument

# the directories must exist
if [ ! -e "$SRCDIR" ] || [ ! -e "$DSTDIR" ]
then
  echo "Invalid directories!\n" 1>&2
  echo $USAGE 1>&2
  exit 1
fi

# convert to absolute paths (just for convenience)
DSTDIR="$(cd $DSTDIR && pwd)" 
cd "$SRCDIR"
SRCDIR="$(pwd)"
debug "soure dir is $SRCDIR"
debug "destination dir is $DSTDIR"


# parse options
while getopts ":diqr" opt; do
  case ${opt} in
    d ) DEBUG='true';;
    i ) ASK='true';;
    q ) VERBOSE='false';;
    r ) REL='--relative';;
    \? ) echo $USAGE 1>&2
         exit 1
      ;;
  esac
done


for fn in **/*(D) ; do # **/*(D) - search recursively for any files (including dotfiles (D))

  debug "\nprocessing '$fn'"

  if [ -f "$fn" ] ; then # if is a regular file
    debug "'$fn' is a file"

    if [ "$ASK" != 'true' ] || askOnceYN "Proceed with '$fn'? " ; then

      srcpath="$SRCDIR/$fn"
      dstpath="$DSTDIR/$fn"
      dstdir="$(dirname $dstpath)" # strips the filename from the path

      debug "\tsrcpath is '$srcpath'"
      debug "\tdstpath is '$dstpath'"
      debug "\tdstdir is '$dstdir'"


      # first line checks if the link is pointing to the same file already
      # second and third check for the desired link path type (absolute/relative)
      if [ "$(readlink -e $dstpath)" != "$srcpath" ] \
         || ( \
              ( [ $REL ] && [ "${$(readlink $dstpath):0:1}" = '/' ] ) || \
              ( [ ! $REL ] && [ "${$(readlink $dstpath):0:1}" != '/' ] ) \
            ) ; then
        debug "'$dstpath' does not yet exist, point to '$srcpath' or is not of desired type of path"

        if [ ! -e "$dstdir" ] ; then # if the parent does not exist
          verbose "Directory '$dstdir' does not exist, creating it..."
          mkdir --parents "$dstdir"  # create the parent(s)
        fi

        verbose "Linking '$dstpath' to '$srcpath'"
        ln --symbolic --backup=numbered $REL $srcpath $dstpath
      else
        verbose "Link from '$dstpath' to '$srcpath' already exists, skipping"
      fi

      debug "done with '$fn'"
      verbose "" # new line...
    fi
  else
    debug "'$fn' is not a regular file, skipping"
  fi

done
