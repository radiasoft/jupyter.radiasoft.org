#!/bin/bash
#
# Setup
#
# Copy template files into ~/jupyter if they don't already exist
shopt -s nullglob
for src in jupyter/*; do
    dst=~/jupyter/$(basename "$src")
    if [[ ! -f $dst ]]; then
        cp -a "$src" "$dst"
    fi
done

# Workaround $PYENV_VERSION being set in
# radiasoft/containers/radiasoft/beamsim-jupyter/radia-run.sh
#TODO(robnagler) Need to find a cleaner fix, which will start
# terminado without $PYENV_VERSION.
if ! grep -s -q RS_TERMINADO_INIT ~/.post_bivio_bashrc; then
    cat >> ~/.post_bivio_bashrc <<'EOF'
if [[ $JPY_USER && $PYENV_VERSION && -z $RS_TERMINADO_INIT ]]; then
    export RS_TERMINADO_INIT=1
    pyenv deactivate >&/dev/null || true
    unset PYENV_VERSION PYENV_VIRTUAL_ENV VIRTUAL_ENV
fi
EOF
fi

if [[ $TERM = xterm ]]; then
    # WORKAROUND: https://github.com/radiasoft/jupyter.radiasoft.org/issues/15
    export TERM=ansi
fi
if [[ $(git config --get --global user.name 2>/dev/null) = '<git-user>' ]]; then
    git config --global user.name "$JPY_USER"
    git config --global user.email "$JPY_USER@users.noreply.github.com"
    git config --global credential.helper 'cache --timeout=3600'
    cat /dev/null > ~/.netrc
fi

#TODO(robnagler) remove after beamsim installed from 8/29/17 or later
rm -f ~/.pre_bivio_bashrc
