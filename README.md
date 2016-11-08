# Preferences for jupyter.radiasoft.org

This repo provides customizations for end-user containers started on
jupyter.radiasoft.org. This repo's `radia-run.sh` is executed first
then the user's jupyter.radiasoft.org `radia-run.sh`, allowing
the user to customize the output of this customization.

## radia-run.sh

The file `radia-run.sh` will be executed at every container start
as follows:

```bash
. ~/.bashrc
git clone https://github.com/radiasoft/jupyter.radiasoft.org
cd jupyter.radiasoft.org
. ./radia-run.sh
cd ..
rm -rf jupyter.radiasoft.org
```

Since the script is run in a subshell, it has access to
all the functions in the
[RadiaSoft downloader](https://github.com/radiasoft/download).
For now, do not assume much about this context, but eventually
an API will be refined.

Right now, it executes in the `master` branch. We'll eventually
install on the channel, but you can expect that your personal
`juypter.radiasoft.org` repo will always install off of
`master`.

## Customization tips

Avoid hardwiring paths. Use `$HOME` or `~` in scripts. Don't assume
anything about `$USER`, because it may change.

You can assume `~/jupyter` is where the notebooks are stored and
where the terminal boots from. This directory persists across
container restarts so you should be careful not to stomp
existing files.
