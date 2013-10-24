# webdevctl

A simple shell script for managing virtualbox (web) development environments.

## Requirements & Compatibility

* [Virtualbox](http://virtualbox.org)
* [sshfs](http://fuse.sourceforge.net/sshfs.html)
* Standard UNIX tools: ping, grep and of course sh.

Tested on Linux. Should work on OS X too.

## Installation

Just copy the script somewhere in your `PATH` and make it executable.

## Usage

I use this script as an over-simplified and lightweight alternative to Vagrant for managing my (web) development virtual machine (VM).

The script accepts only three arguments: up, down and status:

* `webdevctl.sh up`: start the VM, wait till it boots and then mount a directory from the VM to the host using `sshfs`.
* `webdevctl.sh down`: unmount the VM share from the host and suspend the VM.
* `webdevctl.sh status`: print the current state of the VM.

## License

This script is licensed under the [ISC license](http://opensource.org/licenses/ISC).
