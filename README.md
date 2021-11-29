# Radiasoft Public JupyterHub

# FAQ

## Spawn Failed: There are no more servers available.

You may get this error if our cluster has too many active users:

>  Spawn failed
>
> The latest attempt to start your server has failed. There are no more servers available. Please wait a few minutes before trying again. Would you like to retry starting it?


You can only retry by clicking on
[the home page link](https://jupyter.radiasoft.org/hub/home) and then
clicking on
[Start My Server](https://jupyter.radiasoft.org/hub/spawn). Refreshing
your browser page will not allow you to retry.

You can also [submit an Issue](https://github.com/radiasoft/jupyter.radiasoft.org/issues/new)
so that we know you are waiting for a free server.

# Customizations

## pre_jupyter_bashrc

The file in `~/jupyter/pre_jupyter_bashrc`, and it will be run once at
container start. This will allow you to customize your server
environment such as running `pip install`. `~/.bashrc` will run before
this runs so `pyenv` is setup.

## bashrc

You can create a file in `~/jupyter/bashrc`, and it will be read each
time a terminal window starts. This will allow you to customize your
shell environment. It will also be read when your server starts so if
you would like a change to show up in notebooks, you will need to restart
your server.

## programs

The directory `~/jupyter/bin` is automatically inserted in your `$PATH`
so you can create programs/scripts and `chmod +x <file>` in order to make
them executable. You may need to type `hash -r` after you type a new
commands.

## radia-run.sh

This repo provides customizations for end-user containers started on
jupyter.radiasoft.org. This repo's `radia-run.sh` is executed first
then the user's jupyter.radiasoft.org `radia-run.sh`, allowing
the user to customize the output of this customization.

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

### Importing the Warp code in an IPython Notebook

Simply trying 'import warp' or 'from warp import *' will generate errors. Instead, use the following:
```bash
import sys
del sys.argv[1:]
from warp import *
```

### European XFEL: the WaveProperGator (WPG) notebooks for running SRW

1) Point your browser to the [RadiaSoft JupyterHub server](https://jupyter.radiasoft.org)

2) Login with your GitHub credentials.

3) Click the "Terminal" button in the "Launcher" tab.

4) In the new terminal window, type the following command:

```bash
jupyter$ git clone https://github.com/samoylv/WPG.git ./WPG
```

5) Browse to a notebook, by doing (for example) the following:

Double click "WPG"

Double click "samples"

Double click "Tutorials"

Double click "Tutorial_case_1.ipynb"

6) In the "Select Kernel" popup window, you can keep the default choice of "Python 2" by clicking the "SELECT" button.
