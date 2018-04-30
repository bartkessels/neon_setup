#!/bin/bash

# Folders
cp -r $HOME/.config skel/.
cp -r $HOME/.local skel/.

# Files
cp -r $HOME/.bashrc skel/.
cp -r $HOME/.gtkrc-2.0 skel/.
cp -r $HOME/.vimrc skel/.
cp -r $HOME/.zshrc skel/.

# Remove trashed files
rm -rf skel/.local/share/Trash/files/*
rm -rf skel/.local/share/Trash/info/*

# Remove kwallet
rm -rf skel/.kde/share/apps/kwallet/*
rm -rf skel/.local/share/kwalletd/*
rm skel/.config/kwallet*

# Remove cache folder
rm -rf skel/.kde/cache-*

# Remove evolution data
rm -rf skel/.local/share/evolution
rm -rf skel/.config/evolution
