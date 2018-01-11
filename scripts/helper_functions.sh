debug () {
  [ "$DEBUG" != "false" ] && echo $@
}

verbose () {
  [ "$VERBOSE" != "false" ] && echo $@
}

is_no_backup_needed () {
  # Checks whether the first file is a symlink and if it points to the second file,
  # if not so the function will have an exit code of 1 (failure),
  # thus advising to backup the first file.
  if [[ ( -L $1 ) && ( $(readlink -e $1) = $2 ) ]]; then
    return 0
  else
    return 1
  fi
}

askOnceYN () {
  # this way it runs both on BASH and ZSH (read behaves differently)
  echo -n "$1"
  read REPLY
  [[ $REPLY =~ ^[Yy] ]] && return 0 || return 1
}
