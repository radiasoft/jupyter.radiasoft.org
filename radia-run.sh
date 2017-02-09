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

_pip_upgrade() {
    local pkg=$1
    pip install --upgrade --no-deps "$pkg"
    # Brings in dependencies if needed
    pip install "$pkg"
}

# There is no way to list versions so we have to break the abstraction
for venv_path in ~/.pyenv/versions/*/envs/*; do
    (
        venv=$(basename "$venv_path")

        if echo $venv_path | grep -q 'pyenv/versions/2.7'; then # Only Python 2.7 has the codes
            pyenv activate "$venv"
            _pip_upgrade 'git+git://github.com/radiasoft/rsbeams.git@master'
            if python -c 'import synergia' >& /dev/null; then
                _pip_upgrade 'git+git://github.com/radiasoft/rssynergia.git@master'
            fi
        fi
    ) || true
done

git clone https://github.com/radiasoft/rsbeams
for src in rsbeams/rsbeams/matplotlib/stylelib/*; do
    dst=~/.config/matplotlib/$(basename "$src")
    # Always overwrite, b/c
    cp -a "$src" "$dst"
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
