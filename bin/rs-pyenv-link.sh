#!/bin/bash
#
# THIS FILE WILL BE OVERWRITTEN when your Jupyter server (re)starts.
#
# Link external persistent virtual environments into ~/.pyenv
#
# See _usage()
#
#
set -eou pipefail
shopt -s nullglob

_err() {
    _msg "$@"
    # errexit: support subshells
    exit 1
}

_log() {
    _msg $(date +%H%M%S) "$@"
}

_main() {
    declare -a external_dirs=( "$@" )
    if (( $# <= 0 )); then
        _usage 'must supply at least one <external-root>/<venv>/.pyenv directory'
    fi
    # Only works with mpich, which is what we use
    if (( ${PMI_RANK:-0} != 0 )); then
        return
    fi
    declare p=$(pyenv prefix py3)
    if [[ ! ${p:-} =~ /py3$ ]]; then
        _usage "pyenv prefix py3 failed, should not happen; output=$p"
    fi
    declare r=$(readlink $p)
    _link "${r%/py3}" "${p%/py3}" "${external_dirs[@]}"
}

_link() {
    declare real_dir=$1
    declare versions_dir=$2
    declare -a external_dirs=( "${@:3}" )
    declare d v
    for d in "${external_dirs[@]}"; do
        if [[ ! $d =~ /([-_a-zA-Z0-9]+)/.pyenv$ && ! -d $d ]]; then
            echo "external venv dirs must exist and end in /.pyenv: $d" 1>&2
            return 1
        fi
        v=${BASH_REMATCH[1]}
        _link_one "$d" "$real_dir/$v"
        _link_one "$real_dir/$v" "$versions_dir/$v"
    done

}

_link_one() {
    declare src=$1
    declare tgt=$2
    if [[ $(readlink "$src") != $tgt ]]; then
        rm -f "$tgt"
        ln -s "$src" "$tgt"
    fi
}

_msg() {
    if (( $# )); then
        echo "$*" 1>&2
    fi
}

_usage() {
    _msg ERROR: "$@"
    _err "usage: $0 <external-root1>/<venv1>/.pyenv <external-root2>/<venv2>/.pyenv ...

Link external persistent virtual environments into ~/.pyenv, which is
emphemeral in Jupyter.  The environments will be visible as regular
pyenv virtual environments, e.g. for rsmpi which are running in other
containers.

external-roots can be anything or all the same. venv1, venv2, ... have
to be globally unique and not be 'py3'. If they are all in the same
external root, put this in your ~/jupyter/bashrc:

$0 <external-root>/*/.pyenv"
}

_main "$@"
