#! /bin/bash

# === HEAVY LIFTING ===
shopt -s extglob extquote

# NOTE:  Todo.sh requires the .todo/config configuration file to run.
# Place the .todo/config file in your home directory or use the -d option for a custom location.

. ./functions/version.fn

# Set script name and full path early.
TODO_SH=$(basename "$0")
TODO_FULL_SH="$0"
export TODO_SH TODO_FULL_SH

oneline_usage="$TODO_SH [-fhpantvV] [-d todo_config] action [task_number] [task_description]"

. ./functions/helpfuncs.fn

die() { 
    echo "$*" 
    exit 1 
}

cleanup() { 
    [ -f "$TMP_FILE" ] && rm "$TMP_FILE"
    return 0 
}

. ./functions/cleaninput.fn

. ./functions/archive.fn

. ./functions/replaceprepend.fn

#Preserving environment variables so they don't get clobbered by the config file
OVR_TODOTXT_AUTO_ARCHIVE="$TODOTXT_AUTO_ARCHIVE"
OVR_TODOTXT_FORCE="$TODOTXT_FORCE"
OVR_TODOTXT_PRESERVE_LINE_NUMBERS="$TODOTXT_PRESERVE_LINE_NUMBERS"
OVR_TODOTXT_PLAIN="$TODOTXT_PLAIN"
OVR_TODOTXT_DATE_ON_ADD="$TODOTXT_DATE_ON_ADD"
OVR_TODOTXT_DISABLE_FILTER="$TODOTXT_DISABLE_FILTER"
OVR_TODOTXT_VERBOSE="$TODOTXT_VERBOSE"
OVR_TODOTXT_DEFAULT_ACTION="$TODOTXT_DEFAULT_ACTION"
OVR_TODOTXT_SORT_COMMAND="$TODOTXT_SORT_COMMAND"
OVR_TODOTXT_FINAL_FILTER="$TODOTXT_FINAL_FILTER"

# == PROCESS OPTIONS ==
. ./functions/process.fn

# defaults if not yet defined
. ./defaults/defaults.fn

# === APPLY OVERRIDES
if [ -n "$OVR_TODOTXT_AUTO_ARCHIVE" ] ; then
  TODOTXT_AUTO_ARCHIVE="$OVR_TODOTXT_AUTO_ARCHIVE"
fi
if [ -n "$OVR_TODOTXT_FORCE" ] ; then
  TODOTXT_FORCE="$OVR_TODOTXT_FORCE"
fi
if [ -n "$OVR_TODOTXT_PRESERVE_LINE_NUMBERS" ] ; then
  TODOTXT_PRESERVE_LINE_NUMBERS="$OVR_TODOTXT_PRESERVE_LINE_NUMBERS"
fi
if [ -n "$OVR_TODOTXT_PLAIN" ] ; then
  TODOTXT_PLAIN="$OVR_TODOTXT_PLAIN"
fi
if [ -n "$OVR_TODOTXT_DATE_ON_ADD" ] ; then
  TODOTXT_DATE_ON_ADD="$OVR_TODOTXT_DATE_ON_ADD"
fi
if [ -n "$OVR_TODOTXT_DISABLE_FILTER" ] ; then
  TODOTXT_DISABLE_FILTER="$OVR_TODOTXT_DISABLE_FILTER"
fi
if [ -n "$OVR_TODOTXT_VERBOSE" ] ; then
  TODOTXT_VERBOSE="$OVR_TODOTXT_VERBOSE"
fi
if [ -n "$OVR_TODOTXT_DEFAULT_ACTION" ] ; then
  TODOTXT_DEFAULT_ACTION="$OVR_TODOTXT_DEFAULT_ACTION"
fi
if [ -n "$OVR_TODOTXT_SORT_COMMAND" ] ; then
  TODOTXT_SORT_COMMAND="$OVR_TODOTXT_SORT_COMMAND"
fi
if [ -n "$OVR_TODOTXT_FINAL_FILTER" ] ; then
  TODOTXT_FINAL_FILTER="$OVR_TODOTXT_FINAL_FILTER"
fi

ACTION=${1:-$TODOTXT_DEFAULT_ACTION}

[ -z "$ACTION" ]    && usage
[ -d "$TODO_DIR" ]  || die "Fatal Error: $TODO_DIR is not a directory"
( cd "$TODO_DIR" )  || die "Fatal Error: Unable to cd to $TODO_DIR"

[ -w "$TMP_FILE"  ] || echo -n > "$TMP_FILE" || die "Fatal Error: Unable to write to $TMP_FILE"
[ -f "$TODO_FILE" ] || cp /dev/null "$TODO_FILE"
[ -f "$DONE_FILE" ] || cp /dev/null "$DONE_FILE"
[ -f "$REPORT_FILE" ] || cp /dev/null "$REPORT_FILE"

if [ $TODOTXT_PLAIN = 1 ]; then
    for clr in ${!PRI_@}; do
        export $clr=$NONE
    done
    PRI_X=$NONE
    DEFAULT=$NONE
    COLOR_DONE=$NONE
fi

. ./functions/_addto.fn

. ./functions/_list.fn

export -f cleaninput _list die

# == HANDLE ACTION ==
. ./functions/handle.fn
cleanup
