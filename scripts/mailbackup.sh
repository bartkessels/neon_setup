#!/bin/bash

offlineimap

current_date=$(date +"%d-%m-%Y")
tar -cf $HOME/Backups/Mail/$current_date.tar.gz $HOME/Backups/Mail/bk-mail/*

rm -r $HOME/Backups/Mail/bk-mail

