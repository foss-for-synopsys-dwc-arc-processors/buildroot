#!/bin/sh
ifconfig eth0 up

sleep 4

udhcpc eth0
inetd

mount -t nfs -o nolock,rw 192.168.218.1:/home/akolesov/wpub /mnt

