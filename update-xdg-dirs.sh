#!/bin/bash

printf 'XDG_DESKTOP_DIR="$HOME/Desktop"\n
XDG_DOWNLOAD_DIR="$HOME/Downloads"\n
XDG_TEMPLATES_DIR="$HOME/Templates"\n
XDG_PUBLICSHARE_DIR="$HOME/Public"\n
XDG_DOCUMENTS_DIR="$HOME/Documents"\n
XDG_MUSIC_DIR="$HOME/Music"\n
XDG_PICTURES_DIR="$HOME/Pictures"\n
XDG_VIDEOS_DIR="$HOME/Videos"\n' > ~/.config/user-dirs.dirs

xdg-user-dirs-update
