# MorseMicro OpenWrt
## Dependencies

To build the Morse Micro OpenWrt, you need a working Linux
environment. This has been tested with Ubuntu 20.04 and higher.

Install build environment packages with
```
> sudo apt update
> sudo apt install build-essential clang flex g++ gawk gcc-multilib git gettext \
  libncurses5-dev libssl-dev python3-distutils rsync unzip zlib1g-dev swig
```

## Usage

Run the `./scripts/morse_setup.sh` script to configure the build for
your board of choice. Custom boards can be added to the `boards`
folder and used as a target. See an existing board for the
information which should be contained in the diffconfigs.

For example, to create a .config file for a HaLowLink1
```
> ./scripts/morse_setup.sh -i -b halowlink1
```

To list all possible targets and other options, use -h.

After configuration is complete, run the build with
```
> make -j8
```

If an error occurred during the build, see the logs directory.

Once the build is complete images can be found in
`bin/target/<platform>/<target>/`
