#!/bin/bash
#
# Copy files into ~/jupyter if they don't already exist
shopt -s nullglob
for src in jupyter/*; do
    dst=~/jupyter/$(basename "$src")
    if [[ ! -f $dst ]]; then
        cp -a "$src" "$dst"
    fi
done
shopt -u nullglob

# There is no way to list versions so you can use them programmatically
for venv in ~/.pyenv/versions/*; do
    (
        pyenv global "$(basename "$venv")"
        pip install -U pykern
        pip install -U 'git+git://github.com/radiasoft/rsbeams.git@master'
        if python -c 'import synergia' >& /dev/null; then
            pip install -U 'git+git://github.com/radiasoft/rssynergia.git@master'
        fi
    ) || true
done
