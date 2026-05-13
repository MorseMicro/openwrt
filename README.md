# Morse Micro OpenWrt

> [!NOTE]
> This is the `3.0-dev` branch of the Morse Micro OpenWrt fork.
> This branch uses the `mm6108-2.0.1` version of the [core Linux components](https://github.com/MorseMicro#core-components---linux) for MM6108 devices. MM8108 devices remain on `1.17.8`.
> For updated MM8108 core components, see [`3.1-dev`](https://github.com/MorseMicro/openwrt/tree/3.1-dev)

## Dependencies

To build the Morse Micro OpenWrt, you need a working Linux
environment. This has been tested with Ubuntu 20.04, 22.04 and 24.04.

Install build environment packages with

    sudo apt update
    sudo apt install build-essential clang flex gawk git gettext \
        libncurses-dev libssl-dev rsync unzip zlib1g-dev swig golang-go

For Ubuntu 20.04/22.04

    sudo apt install python3-distutils

For Ubuntu 24.04

    sudo apt install python3-setuptools

Optionally, for building x86 binaries on x86_64 hosts

    sudo apt install gcc-multilib

For more details regarding more specific environments, see [Build System Setup](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem)

## Usage

Clone the repo

    git clone https://github.com/MorseMicro/openwrt.git
    cd openwrt

Run the `./scripts/morse_setup.sh` script to configure the build for
your board of choice. Custom boards can be added to the `boards`
folder and used as a target. See an existing board for the information
which should be contained in the diffconfigs.

<<<<<<< HEAD
For example, to create a `.config` file for an HaLowLink1:

    ./scripts/morse_setup.sh -i -b halowlink1

To list all possible boards and other options, use -h.

After configuration is complete, run the build with

    make -j8

If an error occurred during the build, see the logs directory.

Once the build is complete images can be found in
`bin/targets/<platform>/<target>/`

## Speeding up builds

Create an /opt/openwrt directory to store toolchains, downloads and ccache:

    sudo mkdir -p /opt/openwrt
    sudo chown -R "$(id -u):$(id -g)" /opt/openwrt

You can then tell morse_setup.sh to download/configure a toolchain with -E
(use -E for every invocation, even after initial download):

    ./scripts/morse_setup.sh -i -E -b halowlink1

Having a directory that's out of the current tree will make it easier
to have multiple checkouts/worktrees and run `make distclean` or similar
without losing safely cacheable data.

## Customisation

`morse_setup.sh` does a few different things:

- updates and installs OpenWrt feeds using `./scripts/feeds`
- applies some minor patches to external feeds (see `./patches/`)
- uses a particular board config (see `./boards/`) to generate
  a `.config` file
- makes minor modifications to the `.config` for certain kinds of
  builds (e.g. -E for downloading/using an external toolchain)

If you would like to use the usual OpenWrt KConfig based system to
decide which device and which packages to use rather than using our
configurations in `./boards/`, as long as you've run `morse_setup.sh`
once (regardless of which -b option you use) you can:

    rm .config
    make menuconfig

Make sure to select the device you're building for, then go to the
'Morse' section of the menu to select the appropriate firmware, the
driver, and any other packages/options. Alternatively, if you don't
remove `.config` you can make minor customisations to an existing
config. After running `make menuconfig`, you need to do the actual
build as before:

    make -j8
