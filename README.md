# Preferences for jupyter.radiasoft.org

This repo provides customizations for end-user containers started on
jupyter.radiasoft.org. This repo is executed first then the user's
jupyter.radiasoft.org repo will be executed allowing overrides.

## radia-run.sh

The file `radia-run.sh` will be executed at every container start
as follows:

```bash
git clone https://github.com/radiasoft/jupyter.radiasoft.org
cd jupyter.radiasoft.org
bash radia-run.sh
```

Right now, it will execute in the `master` branch. Perhaps we'll
add channels at some point.

## Customization tips

Avoid hardwiring paths. Use `$HOME` or `~` in scripts.

You use `$RADIA_NOTEBOOK_DIR` and `$RADIA_RUN_DIR` for Jupyter notebook directory
and any configuration files.
