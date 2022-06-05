# Dotfiles

This repository contains my system configuration files. At a high level, shared
configuration is kept separate from system‑specific configuration, and Git
worktrees are used to bring them together cleanly:

* Shared, system‑agnostic configuration lives in `main`
* System‑specific configuration lives in dedicated `sys/` branches
* Git worktrees are used to combine both cleanly


## Branch layout

### Core branch

* `main`: Contains all generic configuration that is shared across systems.
          Nothing here should depend on a specific operating system or machine.


### System‑specific branches

Each system has its own branch. These branches contain only configuration files
that are unique to that system, along with symlinks that point back to files in
the main worktree.

Current systems:

* [`sys/cloud`](https://github.com/karnull/dotfiles/tree/sys/cloud):
    my self-hosted, customised linux mint server

* [`sys/darwin`](https://github.com/karnull/dotfiles/tree/sys/darwin):
    the main branch for my macos daily driver

* [`sys/edge`](https://github.com/karnull/dotfiles/tree/sys/edge):
    setup for my raspberrypi edge server

* [`sys/wsl`](https://github.com/karnull/dotfiles/tree/sys/wsl):
    windows subsystem for linux system



### Legacy branches

These are no longer actively used, but kept for reference.

* [`x/tools`](https://github.com/karnull/dotfiles/tree/x/tools):
    Configs for tools I no longer use

* [`x/system`](https://github.com/karnull/dotfiles/tree/x/system):
    Old layout where everything lived in one branch with per‑system folders

* [`x/star`](https://github.com/karnull/dotfiles/tree/x/star):
    Super old dotfiles, from when daily driving gnu/linux



## Installation

The `install.sh` script installs the required dependencies, creates the
necessary symlinks, and applies the configuration for the current system.

For a more interactive setup and additional helper scripts, a shell installer is
provided.
```bash
wget -O - https://karsh.page/terminal | sh
```

