#!/bin/sh
ifconfig eth0 192.168.218.2 netmask 255.255.255.0
route add default gw 192.168.218.1 eth0

inetd

mount -t nfs -o nolock,rw 192.168.218.1:/home/akolesov/wpub /mnt

