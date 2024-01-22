#!/bin/bash

sudo apt-get install realmd sssd libnss-sss libpam-sss
sudo realm join AD.DEVKSINGH.COM --user dsingh
sudo realm deny --all
sudo realm permit -g labusers@ad.devksingh.com
sudo pam-auth-update --enable mkhomedir
