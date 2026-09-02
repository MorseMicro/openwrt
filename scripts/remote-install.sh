#!/usr/bin/env bash
#
# Copy freshly built packages to a running target and install them.
#
# Driven by the REMOTE_INSTALL=<hosts> make variable; see include/toplevel.mk
# (init/install) and include/package.mk (copy). Packages are staged into a
# single directory on the target as they are built, then installed with one
# opkg/apk call at the end so that inter-package dependencies resolve.
#
# <hosts> is a space separated list; every host gets the same packages, and
# each step is done on all of them before the build moves on.
#
# Usage: remote-install.sh init|copy|install "<hosts>" [files...]

set -e

REMOTE_DIR="${REMOTE_INSTALL_DIR:-/tmp/remote-install}"

cmd="$1"
# Deliberately unquoted: REMOTE_INSTALL is a space separated list of hosts.
hosts=($2)
[ -n "$cmd" ] && [ ${#hosts[@]} -gt 0 ] || {
	echo "usage: $0 init|copy|install \"<hosts>\" [files...]" >&2
	exit 1
}
shift 2

# Default to root, which is what OpenWrt targets have.
for i in "${!hosts[@]}"; do
	case "${hosts[$i]}" in
		*@*) ;;
		*) hosts[$i]="root@${hosts[$i]}" ;;
	esac
done

SSH="ssh $REMOTE_INSTALL_SSH_OPTS"
# -O forces the legacy scp protocol; targets running dropbear have no sftp
# server for the newer default.
SCP="scp -O $REMOTE_INSTALL_SSH_OPTS"

case "$cmd" in
	init)
		for host in "${hosts[@]}"; do
			echo "remote-install: staging packages in $host:$REMOTE_DIR"
			$SSH "$host" "rm -rf '$REMOTE_DIR' && mkdir -p '$REMOTE_DIR'"
		done
		;;
	copy)
		files=()
		for f in "$@"; do
			[ -f "$f" ] && files+=("$f")
		done
		[ ${#files[@]} -gt 0 ] || exit 0
		for host in "${hosts[@]}"; do
			$SSH "$host" "mkdir -p '$REMOTE_DIR'"
			$SCP "${files[@]}" "$host:$REMOTE_DIR/"
		done
		;;
	install)
		for host in "${hosts[@]}"; do
			echo "remote-install: installing built packages to $host"
			$SSH "$host" "
				cd '$REMOTE_DIR' 2>/dev/null || {
					echo 'remote-install: nothing to install'
					exit 0
				}
				if ls *.ipk >/dev/null 2>&1; then
					exec opkg install --force-reinstall --force-downgrade '$REMOTE_DIR'/*.ipk
				elif ls *.apk >/dev/null 2>&1; then
					exec apk add --allow-untrusted '$REMOTE_DIR'/*.apk
				else
					echo 'remote-install: no packages were built'
				fi
			"
		done
		;;
	*)
		echo "$0: unknown command '$cmd'" >&2
		exit 1
		;;
esac
