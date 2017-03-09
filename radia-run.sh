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
if [[ $JPY_USER && $PYENV_VERSION && ! $RS_TERMINADO_INIT ]]; then
    export RS_TERMINADO_INIT=1
    unset PYENV_VERSION PYENV_VIRTUAL_ENV
fi
EOF
fi
