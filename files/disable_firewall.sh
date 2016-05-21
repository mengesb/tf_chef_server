#!/usr/bin/env bash

[ $EUID -ne 0 ] && PREPEND="sudo" || PREPEND=""
$PREPEND service iptables stop
$PREPEND chkconfig iptables off
$PREPEND ufw disable

echo "Attempted to stop iptables/ufw"
exit 0
