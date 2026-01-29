#!/bin/bash
USAGE="
$0 - Build OpenWrt image

This is currently a thin wrapper around make. It was previously used
to control the signing process, but we now sign outside the main CI jobs.

However, this does allow us to pin future setup modifications to this
script, tying them to a particular version of this repository. This avoids
having to make changes to CI which would be incompatible with older jobs.

WARNING: currently the CI jobs still pass other arguments
(mode and --image/--pubkey). These are ignored and should continue
to be ignored.
"

die()  { echo "ERROR: $*" >&2; exit 1; }
note() { echo "[morse-build] $*"; }

# 1) Mode (positional)
if [[ $# -gt 0 ]]; then
	case "$1" in
		--*)       : ;;
		*)         shift ;;
	esac
fi

# Options
while [[ $# -gt 0 ]]; do
	case "$1" in
		--image)   IMG_NAME="${2:-}"; [[ -n "$IMG_NAME" ]] || die "--image requires a filename"; shift 2 ;;
		--key)     PRIV_KEY="${2:-}"; [[ -n "$PRIV_KEY" ]] || die "--key requires a file path"; shift 2 ;;
		--pubkey)  PUB_KEY="${2:-}";  [[ -n "$PUB_KEY"  ]] || die "--pubkey requires a file path"; shift 2 ;;
		--jobs)    JOBS="${2:-}"; [[ "$JOBS" =~ ^[0-9]+$ ]] || die "--jobs requires a number"; shift 2 ;;
		--verbose) VERBOSE=1; shift ;;
		-h|--help) echo "$USAGE"; exit 0 ;;
		*)         note "Unknown option: $1 (see --help)";;
	esac
done

if ! [ -f Makefile -a -f feeds.conf.default ]; then
	die "Run from the OpenWrt top directory (with Makefile and feeds config)."
fi

if ! [ -f .config ]; then
	die "No .config found. Run 'scripts/morse_setup.sh' or 'make menuconfig' first."
fi

note "Starting build... (logs at logs/build.log; view with: tail -f ./logs/build.log)"
mkdir -p ./logs
MAKE_ARGS=(-j"${JOBS:-6}")
if [[ ${VERBOSE:-0} -eq 1 ]]; then
	MAKE_ARGS+=("V=sc")
else
	MAKE_ARGS+=("-s")
fi

make "${MAKE_ARGS[@]}" 2>&1 | tee logs/build.log

note "Build complete."