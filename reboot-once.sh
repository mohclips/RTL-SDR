#!/bin/bash

BOOT_ME=~/.vagrant_reboot_once

# have to reboot for drivers to kick in, but only the first time of course
if [ ! -f $BOOT_ME ] ; then
	sudo reboot
	touch $BOOT_ME
fi

