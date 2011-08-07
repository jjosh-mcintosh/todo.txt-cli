#! /bin/bash

# === HEAVY LIFTING ===
shopt -s extglob extquote

# NOTE:  Todo.sh requires the ~/.todo/config configuration file to run.

. ./functions/version.fn

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

. ./defaults/ovr_vars.fn

# == PROCESS OPTIONS ==
. ./functions/process.fn

# defaults if not yet defined
. ./defaults/defaults.fn


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
