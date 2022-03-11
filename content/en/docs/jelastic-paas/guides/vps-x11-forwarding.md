---
title: "Enable X11-Forwarding on VPS"
description: "How to enable X11-Forwarding on a Jelastic VPS"
weight: 1
alwaysopen: true
---

## CentOS

_Note: This was tested on CentOS 7.9 but should apply to all available versions. Some minor differences may be present._

1. Install Xauth with `yum install xorg-x11-xauth`
2. Make sure X11Forwarding is enabled by running `grep X11Forwarding /etc/ssh/sshd_config`, the output should look like: `X11Forwarding yes`
	If the output is `X11Forwarding no`, edit the value in the sshd config with `vim /etc/ssh/sshd_config` and restart sshd `service sshds restart`
3. Connect to the VPS `ssh -X user@ip`
4. Install an X application to verify that it works (for example: `yum install xclock` and then run it with `xclock`)

## Ubuntu

_Note: This was tested on Ubuntu 20.04 but should apply to all available versions. Some minor differences may be present._

On a Ubuntu 20.04 VPS the package xauth is already installed by default.

1. Make sure X11Forwarding is enabled by running `grep X11Forwarding /etc/ssh/sshd_config`, the output should look like: `X11Forwarding yes`
	If the output is `X11Forwarding no`, edit the value in the sshd config with `vim /etc/ssh/sshd_config` and restart sshd `service sshds restart`
2. Connect to the VPS `ssh -X user@ip`
3. Install an X application to verify that it works (for example: `apt install xarclock` and then run it with `xarclock`)

## Debian

_Note: This was tested on Debian 11.2 but should apply to all available versions. Some minor differences may be present._

On a Debian 11.2 VPS the package xauth is already installed by default.

1. Make sure X11Forwarding is enabled by running `grep X11Forwarding /etc/ssh/sshd_config`, the output should look like: `X11Forwarding yes`
	If the output is `X11Forwarding no`, edit the value in the sshd config with `vim /etc/ssh/sshd_config` and restart sshd `service sshds restart`
2. Connect to the VPS `ssh -X user@ip`
3. Install an X application to verify that it works (for example: `apt install xarclock` and then run it with `xarclock`)
