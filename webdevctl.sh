#!/bin/sh
#
# webdevctl.sh: a simple virtualbox guest host manager for
#               (web) development environments.
#
# Copyright (c) 2013-2014 Manolis Tzanidakis <mtzanidakis@gmail.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

## configuration: start

# guest machine's name (as set in VirtualBox)
_vm="webdev"

# guest's hostname (default: same as _vm's value)
_vhost="${_vm}"

# switch to zeroconf on OS X
[ "$(uname -s)" = "Darwin" ] && _vhost="${_vhost}.local"

# the remote mount point (absolute path in guest)
_rmnt="/var/www/vhosts"

# the local mount point (absolute path in host)
_lmnt="$HOME/Sites"

## configuration: end

## actual script: stop editing here

# guest status checking function
_is_on() {
	VBoxManage list runningvms | grep -q ${_vm}
	return $?
}

# error reporting function
_error() {
	echo "error: ${@}."
	exit 1
}

# check if all requirements are available
for _cmd in VBoxHeadless VBoxManage sshfs grep; do
	which ${_cmd} >/dev/null 2>&1 || \
		_error "${_cmd} is not installed or accessible"
done

case "$1" in
	u|up)
		_is_on && _error "${_vm} is already running"

		# start the vm
		VBoxHeadless -s ${_vm} &

		# wait for the guest to come up and listen for 
		# ssh connections
		while true; do
			ssh -q -o ConnectTimeout=1 ${_vhost} exit 2>&1 \
				&& break || sleep 1
		done

		# create local mountpoint if unavailable
		test -d ${_lmnt} || mkdir -p ${_lmnt}

		# mount remote path
		sshfs ${_vhost}:${_rmnt} ${_lmnt} || \
			_error "cannot mount ${_lmnt}"
		;;
	d|down)
		_is_on || _error "${_vm} is not running"

		# unmount local path: try fusermount first (Linux)
		# or umount as fallback (OS X)
		fusermount -u  ${_lmnt} >/dev/null 2>&1 || \
			umount ${_lmnt}                 || \
			_error "cannot unmount ${_lmnt}"

		# let the vm sleep
		VBoxManage controlvm ${_vm} savestate || \
			_error "cannot stop ${_vm}"
		;;
	s|status)
		_is_on && _state="on" || _state="off"
		echo "${_vm} is ${_state}."
		;;
	*)
		echo "usage: $(basename $0) up|down|status"
		exit 0
		;;
esac
