# webdevctl

A simple shell script for managing virtualbox (web) development environments.

## Requirements & Compatibility

* [Virtualbox](http://virtualbox.org)
* [sshfs](http://fuse.sourceforge.net/sshfs.html)
* Standard UNIX tools: grep and of course sh.

Tested on Linux, OS X. On OS X Zeroconf is used for ssh connections.

## Installation

Just copy the script somewhere in your `PATH` and make it executable.

## Usage

I use this script as an over-simplified and lightweight alternative to Vagrant for managing my (web) development virtual machines (VM).

To setup the script set the four variables (`_vm`, `_vhost`, `_rmnt`, `_lmnt`) in the script, in the section between `## configuration: start` and `## configuration: end`. Future versions of the script will support external configuration files or command arguments.

The script accepts only three arguments: up, down and status:

* `webdevctl.sh up`: start the VM, wait till it boots and then mount a directory from the VM to the host using `sshfs`.
* `webdevctl.sh down`: unmount the VM share from the host and suspend the VM.
* `webdevctl.sh status`: print the current state of the VM.

## License

This script is licensed under the [ISC license](http://opensource.org/licenses/ISC).
