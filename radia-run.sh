#!/bin/bash
#
# Setup jupyter container
#
# Copy template files into ~/jupyter if they don't already exist
echo 'START https://github.com/radiasoft/jupyter.radiasoft.org/radia-run.sh'
shopt -s nullglob
for src in jupyter/*; do
    dst=~/jupyter/$(basename "$src")
    if [[ ! -f $dst ]]; then
        cp -a "$src" "$dst"
    fi
done
mkdir -p ~/jupyter/bin
for src in bin/*.sh; do
    install -m 550 "$src" ~/jupyter/bin/"$(basename "$src" .sh)"
done
# if alpha or beta: ${JUPYTERHUB_ACTIVITY_URL:-} =~ 10.1.2.[56]
u=${JUPYTERHUB_USER:-${JPY_USER:-}}
if [[ $u && $(git config --get --global user.name 2>/dev/null) = '<git-user>' ]]; then
    git config --global user.name "$u"
    git config --global user.email "$u@users.noreply.github.com"
    git config --global credential.helper 'cache --timeout=3600'
    cat /dev/null > ~/.netrc
fi
echo 'END https://github.com/radiasoft/jupyter.radiasoft.org/radia-run.sh'
