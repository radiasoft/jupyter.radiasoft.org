# Radiasoft Public JupyterHub

__[Watch this repository](https://help.github.com/en/articles/watching-and-unwatching-repositories)
for changes to the public RadiaSoft Jupyter server.__

# FAQ

## Error 429: Too Many Requests

You may get this error if our cluster has too many active users:

> 429 : Too Many Requests
> Failed to start your server on the last attempt. Please contact admin if the issue persists.
> You can try restarting your server from the [home page](https://jupyter.radiasoft.org/hub/home).

You can only retry by clicking on
[the home page](https://jupyter.radiasoft.org/hub/home link) and then
clicking on
[Start My Server](https://jupyter.radiasoft.org/hub/spawn). Refreshing
your browser page will not allow you to retry.

You can also [submit an Issue](https://github.com/radiasoft/jupyter.radiasoft.org/issues/new)
so that we know you are waiting for a free server.

# Preferences

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

### Importing the Warp code in an IPython Notebook

Simply trying 'import warp' or 'from warp import *' will generate errors. Instead, use the following:
```bash
import sys
del sys.argv[1:]
from warp import *
```

### European XFEL: the WaveProperGator (WPG) notebooks for running SRW

1) Point your browser to the following address:

https://jupyter.radiasoft.org

2) Login with your GitHub credentials.

3) Click green button, "My Server"

4) Near the upper right, click "New" and then select "Terminal"

5) In the new terminal window, type the following command:

```bash
jupyter$ git clone https://github.com/samoylv/WPG.git ./WPG
```

6) Return to browser tab where you originally logged in to the server.

Or alternatively, click the 'Jupyter' logo near the upper left.

7) Browse to a notebook, by doing (for example) the following:

Click "WPG"

Click "samples"

Click "Tutorials"

Click "Tutorial_case_1.ipynb"
