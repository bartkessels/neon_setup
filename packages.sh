#!/bin/bash

# Make sure script is only run as root
if [[ $EUID -ne 0 ]]; then
    echo 'This script must be run as root!'
    exit 0;
fi

#####################################################################################
#####################################################################################

#		VARIABELS

#####################################################################################
#####################################################################################

# Default variables
export USER='bkessels'
export HOME=/home/$USER

# Other variables
full_name=$(getent passwd $USER | cut -d: -f5 | cut -d, -f1)
sync_folder=$HOME/bk-cloud

# Ask for user input
echo 'What is you GIT e-mail address?'
read git_mail

echo 'What is the computer name? [BKlaptop/BKcomputer]'
read computer_name

#####################################################################################
#####################################################################################

#		FOLDERS

#####################################################################################
#####################################################################################

# Remove default dirs
rmdir $HOME/Documents
rmdir $HOME/Downloads
rmdir $HOME/Music
rmdir $HOME/Pictures
rmdir $HOME/Videos

# Create extra dirs
mkdir $HOME/Git-projects
mkdir $sync_folder

# Symlink default dirs to the corresponding dir in the sync_folder
ln -sf $sync_folder/Documenten $HOME/Documents
ln -sf $sync_folder/Muziek $HOME/Music
ln -sf $sync_folder/Afbeeldingen $HOME/Pictures
ln -sf $sync_folder/Videos $HOME/Videos
ln -sf $sync_folder/Backups $HOME/Backups
ln -sf $sync_folder/Boeken $HOME/Books
ln -sf $sync_folder/ISOs $HOME/ISOs
ln -sf $sync_folder/Notities $HOME/Notes
ln -sf $sync_folder/School $HOME/School
ln -sf $sync_folder/Software $HOME/Software
ln -sf $sync_folder/Tabs $HOME/Tabs
ln -sf $sync_folder/Werk $HOME/Work

#####################################################################################
#####################################################################################

#		REPOS

#####################################################################################
#####################################################################################

# Add PPA's
add-apt-repository -y ppa:wereturtle/ppa
add-apt-repository -y ppa:libreoffice/ppa

# Visual Studio Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

# Refresh packages
apt update

#####################################################################################
#####################################################################################

#		SETTINGS

#####################################################################################
#####################################################################################

# Git
printf "[user]\nemail=$git_mail\nname=$full_name\n[diff]\ntool=meld\n[push]\ndefault=simple" > $HOME/.gitconfig

# Shell / Plugins
dnf install -y zsh
usermod -s /bin/zsh $USER

git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh

# Inotify
printf '# Increase inofity watch limit\nfs.inotify.max_user_watches = 100000000' > /etc/sysctl.d/90-inotify.conf
printf '\n\n# Increase inofity watch limit\nfs.inotify.max_user_watches = 100000000' >> /usr/lib/sysctl.d/50-default.conf

# Audio
printf '* hard rtprio 0\n* soft rtprio 0\n@realtime hard rtprio 20\n@realtime soft rtprio 10\n@audio - rtprio 95\n@audio - memlock unlimited' >> /etc/security/limits.conf

# Create groups
groupadd realtime
groupadd docker

# Hostname
hostnamectl set-hostname --static $computer_name

#####################################################################################
#####################################################################################

#		SOFTWARE

#####################################################################################
#####################################################################################

# Utilities
apt install -y ghostwriter whois pandoc luckybackup ffmpeg

# LaTeX editors
apt install -y kile

# Audio editors / Players
apt install -y audacity ardour
apt install -y juk

# Image editors
apt install -y gimp krita

# Video editors
apt install -y --install-suggests kdenlive

# Development editors / Tools / Libraries / Documentation / Other
apt install --install-suggests -y qtcreator kdevelop code
apt install --install-suggests -y build-essential git cmake clang
apt install --install-suggests -y qtdeclarative5-dev
apt install --install-suggests -y qttools5-dev
apt install --install-suggests -y umbrello

# Web
apt install --install-suggests -y falkon filezilla youtube-dl offlineimap qbittorrent

# Office / Office language packs
apt install -y libreoffice kile kontact
apt install -y aspell-nl libreoffice-l10n-nl

# Containers
apt install --install-suggests -y docker docker-compose

# Password management
apt install --install-suggests -y keepassx

# Other
apt install --install-suggests -y tuxguitar

#####################################################################################
#####################################################################################

#		FLATPAK PACKAGES

#####################################################################################
#####################################################################################

# Install flatpak
apt install --install-suggests -y flatpak

# Add default flatpak remotes
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists kdeapps --from https://distribute.kde.org/kdeapps.flatpakrepo

# Video editors
flatpak install -y flathub org.blender.Blender
flatpak install -y flathub org.shotcut.Shotcut

# Screen recorders
flatpak install -y flathub com.obsproject.Studio

# Development editors
flatpak install flathub com.google.AndroidStudio

#####################################################################################
#####################################################################################

#		SERVICES

#####################################################################################
#####################################################################################

# Add user to service groups
usermod -aG docker $USER
usermod -aG audio $USER
usermod -aG realtime $USER
usermod -aG mock $USER

#####################################################################################
#####################################################################################

#		COPY FILES / SETTINGS

#####################################################################################
#####################################################################################

# Settings
cp -r skel/. $HOME/.
cp -r skel/. /etc/skel/.

# Set right ownership
chown -R $USER:$USER $HOME

#####################################################################################
#####################################################################################

#		COPY BINARIES

#####################################################################################
#####################################################################################

# Markdown to PDF
cp scripts/md2pdf.sh /usr/bin/md2pdf
chmod +x /usr/bin/md2pdf

# Mail backup
cp scripts/mailbackup.sh /usr/bin/mailbackup
chmod +x /usr/bin/mailbackup

#####################################################################################
#####################################################################################

#		FINISH

#####################################################################################
#####################################################################################

clear
echo 'Your computer is set up! The system will reboot within one minute...'
shutdown -r +1
