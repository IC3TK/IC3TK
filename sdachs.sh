#!/bin/sh
# @(#) $Id$ GitHub workshop
# only if geometry */255/63
sudo fdisk -l /dev/sda | awk '/^\/dev\//{ printf "%s %d/%d/%d\n", $1, $2/(255*63), $2%(255*63)/63, $2%(255*63)%63+1 }'
