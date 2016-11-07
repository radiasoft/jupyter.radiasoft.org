#!/bin/bash
#
# Copy files into ~/jupyter if they don't already exist
for src in jupyter/*; do
    dst=~/jupyter/$(basename "$src")
    if [[ ! -f $dst ]]; then
        cp -a "$src" "$dst"
    fi
done

(
    # There is no way to list versions so you can use them programmatically
    for venv in ~/.pyenv/versions/*; do
        pyenv activate "$(basename "$venv")"
        pip install -U 'git+git://github.com/radiasoft/rssynergia.git@master'
    done
)
