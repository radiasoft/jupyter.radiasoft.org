#!/bin/bash
#
# Setup
#
# Copy template files into ~/jupyter if they don't already exist

# Fix up beamsim issue temporarily
pyenv global 2.7.10

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
for venv in ~/.pyenv/versions/*; do
    (
        export PYENV_VERSION="$(basename "$venv")"
        _pip_upgrade 'git+git://github.com/radiasoft/rsbeams.git@master'
        if python -c 'import synergia' >& /dev/null; then
            _pip_upgrade 'git+git://github.com/radiasoft/rssynergia.git@master'
        fi
    ) || true
done

git clone https://github.com/radiasoft/rsbeams
for src in rsbeams/rsbeams/matplotlib/stylelib/*; do
    dst=~/.config/matplotlib/$(basename "$src")
    # Always overwrite, b/c
    cp -a "$src" "$dst"
done
