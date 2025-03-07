# mesa-25-me

Super short script to hack-fix some Mesa dependencies in Debian/sid (unstable), to allow installing both amd64 and i386 packages at the same time.

This is needed for Steam.

![screenshot of code](https://github.com/rektide/mesa-25-me/blob/main/.code.png)

Note that this hack only allows your 25.0.0-1 packages to _masquerade_ as 25.0.1-1 packages. This probably isn't super critical, but it's worth emphasizing that we're not really doing the right thing with this script.

This should not be a long term problem, and you probably won't need this script after a couple days or so. But for folks wanting to get Steam running on their Debian systems with brand new Debian AMD RX 9070 XT video cards, well, this is the way, I guess. This script also serves as a reference for monkeying with Debian versioning dependencies in bulk.

# Problem Statement

At the time of writing, Debian has the following different versions specified:

| architecture | version  |
| ------------ | -------- |
| i386         | 25.0.0-1 |
| amd64        | 25.0.1-1 |

Unfortunately, these packages are written to require only exact versions of related packages. Thus, trying to install i386 packages creates a conflict with amd64 packages.

# Usage

1. First, we advise removing all affected i386 packages. This will force your Steam to uninstall, but you can reinstall it latter with no impact. There will probably be some other dependencies you will have to temporarily remove.
2. The run `./mesa25me.zsh` to reprocess all the affected packages

- This will prompt you for the sudo password, which is needed to maintain permissions when extracting and modifying packages.
- new packages will show up, with the newer `25.0.1-1` version.

3. Install the new packages with `sudo dpkg -i *25.0.1*deb`
4. Optionall, go reinstall Steam. Consider looking at steam-libs packages & reinstalling optional dependencies there; unknown how useful these are but maybe good to have?

# Script Description

The included `mesa25me.zsh` script will, for all affected mesa i386 packages:

1. Download the package
2. Extract under `./tmp`
3. Modify the `DEBIAN/control` file to change the versions
4. Package a new deb version
