#!/bin/bash
###################################################################################
# Name:			finishbuild.sh
# Author:		Romano Woodfolk
# Created:		October 08, 2015 		(Original firstbuild.sh modified)
# Modified:		November 21, 2018 	(110100100)
# Version:		v1.0
#---------------------------------------------------------------------------------#
# Comments: This script contains the installation commands for debian based and 
# ubuntu based distributions i.e. Ubuntu (proper), Ubuntu-Mate, Xubuntu, Kubuntu, 
# Ubuntu Budgie, Lubuntu and Ubuntu Studio.
#
# This script is designed for Ubuntu/Ubuntu-Mate and Linux Mint (LMDE, Cinnamon, 
# Mate and XFCE) will be modified to support Debian and Debian-based distributions,
# Kali Linux and ParrotOS.
#
# Below are the software packages being installed via this script:
#
#---------------------------------------------------------------------------------#
#               ****** Global Variable Definitions ******
#---------------------------------------------------------------------------------#
# varibles
    NOW=`date +%Y%m%d%H%M%S`                    # Current Date & Time Suffix
    LOGFILE=/var/log/instlog$NOW.log         	# Script Log File
    ERRORFILE=/var/log/errlog$NOW.log         	# Error Log File
    OSTYPE="Default"                            # Default OS Ubuntu
    DIST="UNKNOWN"										# Distrobution
    VER="UNKNOWN"											# Version
    NAME=""													# User's Name
    USERNAME=""											# username
    OSINSTALL=$1                                # OS Installation Choice
    INSTALLFILE=$2                              # External Install List
    APPLIST=$3                               	# External Apps List
# colors
    NORMAL=`echo "\033[m"`								# 					${NORMAL}
    MENU=`echo "\033[36m"`								# blue 			${NORMAL}
    NUMBER=`echo "\033[33m"`							# yellow 		${NORMAL}
    FGRED=`echo "\033[41m"`							# red  			${FGRED}
    RED_TEXT=`echo "\033[31m"`						# 					${RED_TEXT}
    ENTER_LINE=`echo "\033[33m"`						# 					${COLOR}
    COLOR='\033[01;31m' 								# bold red 		${NORMAL}
    RESET='\033[00;00m' 								# normal white ${RESET}

#=================================================================================#
#                                                                                 #
#               ****** Function Definitions ******                                #
#                                                                                 #
#=================================================================================#
#---------------------------------------------------------------------------------#
#	Check for root/sudo                                                            #
#---------------------------------------------------------------------------------#
funcAreYouRoot () {
    echo ""
    clear
    echo ""    																		# clear Screen
    echo "Elevated rights are needed to run installs"
    sleep 1
    echo ""
    clear		 																		# clear Screen
    echo ""    																		# clear Screen
    if [ $USER != 'root' ]
    then
        echo "YOU ARE NOT root... This script REQUIRES root access"
        echo ""
        echo "You will be prompted to enter a your root password to proceed!!!"
        #  exit 0
    else
        echo ""
        clear																			# clear Screen
        echo ""    																	# clear Screen
        echo "Your are root or have issued \sudo to run this script... Let's began "
        echo "building your new system..."
        echo ""
        echo ""
        echo "You will be prompt to enter Elevated Rights to continue running this script"
        echo "Do you want to continue running this script? yes (Y) or no (N)"
        echo ""
        clear																			# clear Screen
        echo ""    																	# clear Screen
    fi
sleep 2
}
#---------------------------------------------------------------------------------#
#  User Information                                                               #
#---------------------------------------------------------------------------------#
funcUserInfo () {
 echo -e "Enter Your Name: \"i.e. First Last\" "
 read NAME
 echo -e "Enter usernam: "
 read USERNAME  
 echo -e ""
 clear
 echo -e ""
 echo -e "Your Name is: ${MENU}$NAME${RESET} "
 echo -e "Your Username: ${MENU}$USERNAME${RESET} "
 echo -e "This will be the name and user account used to configure applications, " 
 echo -e "profiles and accounts. Do you want to continue using:"
 echo -e "${MENU}$NAME${RESET} and ${MENU}$USERNAME${RESET}? \"${RED_TEXT}Y${RESET}\" = Continue \"${RED_TEXT}N${RESET}\" = Re-Enter"
 read A
    if [[ "$A" == "Y"  ||  "$A" == "y"||  "$A" == "Yes" ||  "$A" == "yes"  ]] ;
    then
        echo -e ""
        clear
        echo -e ""
        echo -e "Great, I will be using ${MENU}$NAME${RESET} as your  name and"
        echo -e "${MENU}$USERNAME${RESET} as your account for all configurations..."	 
    else
        echo -e ""
        funcUserInfo
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Installation Menu                                                              #
#---------------------------------------------------------------------------------#
funcInstalMenu () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "...Placeholder for Future Menu"
    else
        echo ""
        clear
        echo ""
        echo "Sub-Menu are to follow..."													# Menu Install 
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Distrobution and Version Check
#---------------------------------------------------------------------------------#
funcOsVersion () {
if [ -f /etc/os-release ]; then		   			# freedesktop.org and systemd
    . /etc/os-release
    DIST=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then		# linuxbase.org
    DIST=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then					# For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    DIST=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then				# Older Debian/Ubuntu/etc.
    DIST=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then		   		# Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then				# Older Red Hat, CentOS, etc.
    ...
else															# Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    DIST=$(uname -s)
    VER=$(uname -r)
fi
}
#---------------------------------------------------------------------------------#
#  Check and Enable Ubuntu Repositories 
#---------------------------------------------------------------------------------#
# The Four Main Repositories:
# 	1) Main - Canonical-supported free and open-source software.
# 	2) Universe - Community-maintained free and open-source software.
# 	3) Restricted - Proprietary drivers for devices.
# 	4) Multiverse - Software restricted by copyright or legal issues.
# 
# For a detailed description of these repositories, 
# see https://help.ubuntu.com/community/Repositories.
#---------------------------------------------------------------------------------#
funcRepoCheck () {
	# Enable All
		#sudo add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main universe restricted multiverse partner"
	# Enable main		
		grep -Erh ^deb /etc/apt/sources.list | grep -qw main || 
		sudo add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main"
	# Enable Universe		
		grep -Erh ^deb /etc/apt/sources.list | grep -qw universe || 
		sudo add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"			 
	# Enable restricted		
		grep -Erh ^deb /etc/apt/sources.list | grep -qw restricted || 
		sudo add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) restricted"
	# Enable multiverse		
		grep -Erh ^deb /etc/apt/sources.list | grep -qw multiverse || 
		sudo add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) multiverse"
	# Enable partner		
		grep -Erh ^deb /etc/apt/sources.list | grep -qw partner || 
		sudo add-apt-repository -y "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"
	# Enable backports		
		grep -Erh ^deb /etc/apt/sources.list | grep -qw bionic-backports || 
		sudo add-apt-repository -y "deb http://in.archive.ubuntu.com/ubuntu/ bionic-backports main restricted universe multiverse"
}
#---------------------------------------------------------------------------------#
#	System Update/System Upgrade                                                   #
#---------------------------------------------------------------------------------#
funcSysUpdates () {
	# sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove
	# sudo apt-get - f install
	 sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y && 
	 sudo apt-get autoremove -y && sudo apt-get -f install
	 echo ""
	 clear
	 echo ""
sleep 2
}
#---------------------------------------------------------------------------------#
#  Package Management Tools                                                       #
#---------------------------------------------------------------------------------#
funcPackMans () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "...installing Package Management Tools"
        sudo apt update
        sudo apt install -y synaptic gdebi snapd flatpak gnome-software-plugin-flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    else
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "Intalling Parrot Package Manager"								# For Furture Use
        sudo apt-get install -y synaptic gdebi snapd flatpak
        sudo add-apt-repository ppa:alexlarsson/flatpak
        sudo apt update
        sudo apt install -y synaptic gdebi snapd flatpak gnome-software-plugin-flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi
#---------------------------------------------------------------------------------#
## https://www.techrepublic.com/article/how-to-install-and-use-flatpak-on-ubuntu/
# sudo add-apt-repository ppa:alexlarsson/flatpak
# sudo apt update
# sudo apt install flatpak
# sudo apt install gnome-software-plugin-flatpak
# flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
# sudo apt-get install -y synaptic 				  								# Synaptic Package Manager
# sudo apt-get install -y gdebi                    				   	# graphical Deb Package manager
# sudo apt-get install -y snapd													# Snap Packages
# sudo apt-get install -y ubuntu-mate-welcome --classic					# ubuntu-mate-welcome
# sudo apt-get install -y software-boutique --classic						# Software Boutique
# sudo apt-get install -y parrot-package-manager 							# Parrot Package Manager
#---------------------------------------------------------------------------------#
sleep 2
}
#---------------------------------------------------------------------------------#
#  AuDIO & Video                                                                  #
#---------------------------------------------------------------------------------#
funcAudioVideo () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "...installing AuDIO & Video Applications"
        sudo apt-get install -y audacity cheese dvdrip easytag gtkpod handbrake kazam kino
        sudo apt-get install -y mplayer mplayer-gui mplayer-skins obs-studio openshot
        sudo apt-get install -y simplescreenrecorder smplayer smplayer-themes sound-juicer
        sudo apt-get install -y xmms2-plugin-all libdvdcss2 libavcodec-extra
    else
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
#	sudo apt-get install -y banshee												# Banshee Music Player
#  sudo apt-get install -y clementine											# Clementine Music Player
#  sudo apt-get install -y k3b													# K3B CD/DVD Burner
#  sudo apt-get install -y pavucontrol											# PulseAudio Volume Control
#  sudo apt-get install -y rhtyhbox												# Rhythbox Music Management Player
#  sudo apt-get install -y smplayer-skins 									# SMPlayer Skins (Broken)
#  sudo apt-get install -y totem 												# Totem (Video) Media Player
#---------------------------------------------------------------------------------#
sleep 2
}
#---------------------------------------------------------------------------------#
#  Communication & News (INTERNET/Networking)                                     #
#---------------------------------------------------------------------------------#
# Reference the follow website:
# https://remmina.org/how-to-install-remmina/
#
funcCommNetwork () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "..installing Communications, Internet and Networking Applications..."
        sudo apt-get install -y etherape etherape-data filezilla hexchat liferea 
        sudo apt-get install -y pidgin putty putty-doc putty-tools pterm
        sudo apt-get install -y remmina remmina-common remmina-plugin-rdp 
        sudo apt-get install -y remmina-plugin-secret remmina-plugin-vnc  
        sudo apt-get install -y remmina-plugin-exec remmina-plugin-nx  
        sudo apt-get install -y remmina-plugin-spice remmina-plugin-telepathy  
        sudo apt-get install -y remmina-plugin-xdmcp libfreerdp-plugins-standard 
        sudo apt-get install -y telegram-desktop vinagre wicd wireshark xchat zenmap
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "  ********* Removing the following packages *********"
        echo "    network-manager-gnome" 
        echo "    network-manager"
		  sudo apt-get remove -y network-manager-gnome network-manager 
    else
        echo ""
        clear
        echo ""    																	# clear Screen
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
#  sudo apt-get install -y empathy												# Empathy
#  sudo apt-get install -y flashplugin-installer							# Flash Player
#  sudo apt-get install -y firefox 												# Firefox Web Browser
#  sudo apt-get install -y evolution											# Evolution
#  sudo apt-get install -y transmission										# Transmission
#---------------------------------------------------------------------------------#
sleep 2
}
#---------------------------------------------------------------------------------#
#  Productivity (Office)                                                          #
#---------------------------------------------------------------------------------#
funcProductivity () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Office and Productivity Applications..."
        sudo apt-get install -y calibre glabels gnucash gnucash-doc gramps homebank
        sudo apt-get install -y homebank libreoffice   
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
# sudo apt-get install -y gnome-calendar										# GNOME Calendar
# sudo apt-get install -y libreoffice          								# LibreOffice
# sudo apt-get install -y libreoffice-base									# LibreOffice Base
# sudo apt-get install -y libreoffice-calc									# LibreOffice Calc
# sudo apt-get install -y libreoffice-draw									# LibreOffice draw**
# sudo apt-get install -y libreoffice-impress								# LibreOffice Impress
# sudo apt-get install -y libreoffice-math									# LibreOffice Math
# sudo apt-get install -y libreoffice-writer									# LibreOffice Writer
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Games                                                                          #
#---------------------------------------------------------------------------------#
funcGames () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Games..."
        sudo apt-get install -y gnome-mahjongg gnome-mines gnome-sudoku
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
# sudo apt-get install -y gnome-mahjongg										# GNOME Mahjongg
# sudo apt-get install -y gnome-mines            							# GNOME Mines
# sudo apt-get install -y gnome-sudoku											# GNOME Sudoku
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Graphics and Photography (GRAPHICS)                                            #
#---------------------------------------------------------------------------------#
funcGraphics () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Graphics and Photography Applications..."
        sudo apt-get install -y blender darktable dia gimp gimp-cbmplugs gimp-data-extras
        sudo apt-get install -y gimp-dcraw gimp-dds gimp-gap gimp-gluas gimp-gmic
        sudo apt-get install -y gimp-gutenprint gimp-help-en gimp-lensfun gimp-normalmap
        sudo apt-get install -y gimp-plugin-registry gimp-texturize gimp-ufraw gpick
        sudo apt-get install -y inkscape inkscape-open-symbols krita librecad scribus
        sudo apt-get install -y scribus-doc scribus-template sweethome3d
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
# sudo apt-get install -y calibre												# calibre - E-book Viewer
# sudo apt-get install -y evince            								   # Document Viewer - Evince
# sudo apt-get install -y libreoffice-draw 									# LibreOffice Draw
# sudo apt-get install -y shotwell												# Shotwell
# sudo apt-get install -y simple-scan											# Simple Scan
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Add-ons                                                                        #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://gstreamer.freedesktop.org/documentation/installing/on-linux.html
#
funcAddOns () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing GStreamer plugins and libraries..."
        sudo apt-get install -y libgstreamer1.0-0 							# GStreamer library
        sudo apt-get install -y gstreamer1.0-plugins-base				# GStreamer plugins from the "base" set
        sudo apt-get install -y gstreamer1.0-plugins-good				# GStreamer plugins from the "good" set
        sudo apt-get install -y gstreamer1.0-plugins-bad		   		# GStreamer plugins from the "bad" set
        sudo apt-get install -y gstreamer1.0-plugins-ugly				# GStreamer plugins from the "ugly" set
        sudo apt-get install -y gstreamer1.0-libav							# libav plugin for GStreamer"
        sudo apt-get install -y gstreamer1.0-gtk3 							# GStreamer plugin for GTK+3
        sudo apt-get install -y gstreamer1.0-x								# GStreamer plugins for X11 and Pango
        sudo apt-get install -y gstreamer1.0-pulseaudio					# GStreamer plugin for PulseAudio
        sudo apt-get install -y gstreamer1.0-gl								# GStreamer plugins for GL
        sudo apt-get install -y gstreamer1.0-alsa							# GStreamer plugin for ALSA
        sudo apt-get install -y gstreamer1.0-doc 							# GStreamer documentation
        sudo apt-get install -y gstreamer1.0-tools							# GStreamer tools
        echo ""
        clear
        echo ""    																	# clear Screen
        echo " Removeing the fluendo-mp3 codec for better MP3 play back"
        echo " sudo apt-get remove -y gstreamer1.0-fluendo-mp3"
        sudo apt-get remove -y gstreamer1.0-fluendo-mp3  				#removing fluendo-mp3
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Developer Tools (PROGRAMMING)                                                  #
#---------------------------------------------------------------------------------#
funcDevTools () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Developer Tools..."
        sudo apt-get install -y anjuta arduino arduino-mk bluefish kicad
        sudo apt-get install -y fritzing fritzing-parts geany gnuradio
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Education and Science (Education/Science)
#---------------------------------------------------------------------------------#
funcSciEdu () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo "..installing Educational and Science Applications..."
        sudo apt-get install -y stellarium
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
# sudo apt-get install -y libreoffice-math									# LibreOffice Math
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Utilities (System Tools/Accessories)                                           #
#---------------------------------------------------------------------------------#
funcUtilities () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Utilities and System Tools..."
		  sudo apt-get install -y gcc make linux-headers-$(uname -r) dkms
        sudo apt-get install -y convertall gip keepassxc gnome-boxes gnome-nettool
        sudo apt-get install -y putty putty-tools redshift sirikali terminator tilda
        sudo apt-get install -y upnp-router-control virtualbox virtualbox-ext-pack
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
# sudo apt-get install -y deja-dup												# Backup - Déjà Dup Backup Tool
# sudo apt-get install -y file-roller           							# File Roller
# sudo apt-get install -y gnome-disk-utility									# GNOME Disks
# sudo apt-get install -y seahorse			 									# Seahore
# sudo apt-get install -y gnome-todo		 									# To Do
# sudo apt-get install -y vim					 									# Vim
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Miscellaneous                                                                  #
#---------------------------------------------------------------------------------#
funcMiscellaneous () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Miscellaneous Applications..."
        sudo apt-get install -y libavcodec-extra
        sudo apt-get install -y chirp clamav dropbox caja-dropbox nautilus-dropbox
        sudo apt-get install -y git git-core git-doc imagemagick gpa gparted grsync gufw
        sudo apt-get install -y imagemagick-common menulibre ntfs-3g ntfs-config openconnect
        sudo apt-get install -y rar unrar ttf-mscorefonts-installer unetbootin xrdp zip unzip
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
#---------------------------------------------------------------------------------#
# For Ubuntu, this PPA provides the latest stable upstream Git version
# sudo add-apt-repository ppa:git-core/ppa 
# sudo apt update && sudo apt install git
# Suggested packages:
# sudo apt-get install -y git-cvs												# import changesets from CVS
# sudo apt-get install -y git-svn												# operation between a Subversion
# sudo apt-get install -y git-email												# send a collection of patches as emails
# sudo apt-get install -y gitk													# git repository browser
# sudo apt-get install -y gitweb													# git web interface (web frontend to Git)
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Etcher                                                                         #
#---------------------------------------------------------------------------------#
# Reference the follow website:
# https://www.omgubuntu.co.uk/2017/05/how-to-install-etcher-on-ubuntu
#
# deb https://dl.bintray.com/resin-io/debian stable etcher
# sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61
# sudo apt update && sudo apt install etcher-electron
# 
funcEtcher () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Etcher..."
        echo "deb https://dl.bintray.com/resin-io/debian stable etcher" | sudo tee /etc/apt/sources.list.d/etcher.list
        # add the repository key
        sudo apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 379CE192D401AB61
        sudo apt-get update
        sudo apt-get install -y etcher-electron
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Google Chrome                                                                  #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://www.linuxbabe.com/ubuntu/install-google-chrome-ubuntu-18-04-lts
#
funcGoogleChrome () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Google Chrome Web Browser..."
		  cd /tmp && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		  sudo dpkg -i google-chrome-stable_current_amd64.deb
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
		  sudo touch /etc/apt/sources.list.d/google-chrome.list
		  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
		  # echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
		  # wget https://dl.google.com/linux/linux_signing_key.pub
		  # sudo apt-key add linux_signing_key.pub
		  # sudo apt update
		  # sudo apt install -y google-chrome-stable
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  PowerShell                                                                     #
#---------------------------------------------------------------------------------#
# Reference the follow website:
# https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-powershell-core-on-linux?view=powershell-6
#
funcPowerShell () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing PowerShell ..."
        # Download the Microsoft repository GPG keys
        wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
        # Register the Microsoft repository GPG keys
        sudo dpkg -i packages-microsoft-prod.deb
        # Update the list of products
        sudo apt-get update
        # Install PowerShell
        sudo apt-get install -y powershell
        # Start PowerShell
        #pwsh
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Skype                                                                          #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://www.linuxbabe.com/ubuntu/install-skype-ubuntu-18-04-lts-desktop
#
funcSkype () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Skype..."
        sudo dpkg --add-architecture i386 									# enable multiarch for better 64-bit compatibility
		  cd /tmp && wget https://repo.skype.com/latest/skypeforlinux-64.deb
		  sudo dpkg -i skypeforlinux-64.deb
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
		  echo "deb [arch=amd64] https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skype-stable.list
		  wget https://repo.skype.com/data/SKYPE-GPG-KEY
		  sudo apt-key add SKYPE-GPG-KEY
		  sudo apt install -y apt-transport-https
		  sudo apt update
		  sudo apt install -y skypeforlinux
		  # skypeforlinux
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Stacer                                                                         #
#---------------------------------------------------------------------------------#
funcStacer () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Stacer..."
        cd /tmp && wget -q https://github.com/oguzhaninan/Stacer/releases/download/v1.0.9/stacer_1.0.9_amd64.deb
        sudo dpkg -i stacer*.deb
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
        sudo add-apt-repository ppa:oguzhaninan/stacer
        sudo apt-get update && sudo apt-get install stacer
        # For Debian x64"
        # cd /tmp && wget -q https://github.com/oguzhaninan/Stacer/releases/download/v1.0.9/stacer_1.0.9_amd64.deb
        # sudo dpkg -i stacer*.deb
        # stacer
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Synology Assistant                                                             #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://www.virtono.com/community/tutorial-how-to/installing-synology-assistant-on-ubuntu/
#
funcSynolAssist () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Synology Assistant..."
		  cd /tmp && wget https://global.download.synology.com/download/Tools/Assistant/6.2-23733/Ubuntu/x86_64/synology-assistant_6.2-23733_amd64.deb
		  sudo dpkg -i synology-assistant_6.2-23733_amd64.deb
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
		  wget https://global.download.synology.com/download/Tools/Assistant/6.2-23733/Ubuntu/x86_64/synology-assistant_6.2-23733_amd64.deb
		  sudo dpkg -i Downloads/synology-assistant_6.2-23733_amd64.deb
		  # /opt/Synology/SynologyAssistant/SynologyAssistant
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
# Teamviewer                                                                      #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://websiteforstudents.com/installing-teamviewer-on-ubuntu-16-04-17-10-18-04/
#
funcTeamviewer () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Teamviewer..."
		  cd /tmp && wget https://download.teamviewer.com/download/linux/version_14x/teamviewer_amd64.deb # TeamViewer Preview
		  cd /tmp && wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
		  sudo dpkg -i teamviewer_amd64.deb
		  sudo apt-get install -f
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
        cd /tmp && wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
        sudo apt-key add TeamViewer2017.asc
        sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" > /etc/apt/sources.list.d/teamviewer.list'
        sudo sh -c 'echo "deb http://linux.teamviewer.com/deb preview main" > /etc/apt/sources.list.d/teamviewer.list'
        sudo apt update
        sudo apt install -y teamviewer
        # teamviewer
    fi
sleep 2
}
#---------------------------------------------------------------------------------#
#  UNetbootin                                                                     #
#---------------------------------------------------------------------------------#
# Reference the follow website:
# https://blog.programster.org/ubuntu-18-04-install-unetbootin
# https://unetbootin.github.io/linux_download.html
#
funcUNetbootin () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Unetbootin..."
        sudo add-apt-repository ppa:gezakovacs/ppa -y
        sudo apt-get update
        sudo apt-get install -y unetbootin 
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  VeraCrypt                                                                      #
#---------------------------------------------------------------------------------#
# Reference the follow website:
# https://www.linuxbabe.com/ubuntu/install-veracrypt-ubuntu-16-04-16-10
#
funcVeraCrypt () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo " ****** DO NOT INSTALL VeraCrypt UNTIL TESTED ****** "
        echo ""
    else
        echo ""
        clear
        echo ""
        echo "Intalling VeraCrypt..."										# For Furture Use
        echo ""
        # ****** DO NOT INSTALL UNTIL TESTED ******
        sudo add-apt-repository ppa:unit193/encryption
        sudo apt-get update
        sudo apt install veracrypt
        #
    fi
sleep 2    
}
#---------------------------------------------------------------------------------#
#  VirtualBox                                                                     #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://websiteforstudents.com/installing-virtualbox-5-2-ubuntu-17-04-17-10/
#
funcVirtualBox () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing VirtualBox..."
		  sudo apt-get update
		  sudo apt-get install -y virtualbox virtualbox-ext-pack
		  # Suggested packages:
		  # VDE is a virtual switch that can connect multiple virtual machines together, both local and remote
		  # VirtualBox Guest Additions ISO guest additions iso image for VirtualBox
		  sudo apt-get install -y vde2 virtualbox-guest-additions-iso
		  sudo adduser $USERNAME vboxusers
    else
        echo ""
        clear
        echo ""
        echo "Intalling VirtualBox from Oracle repositories" 		# For Furture Use
		  cd /tmp && wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
		  cd /tmp && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
		  sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
		  sudo apt update
		  sudo apt install virtualbox-5.2
		  cd /tmp && wget https://download.virtualbox.org/virtualbox/5.2.20/Oracle_VM_VirtualBox_Extension_Pack-5.2.20.vbox-extpack	
		  sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.20.vbox-extpack
		  sudo adduser $USERNAME vboxusers
    fi
#---------------------------------------------------------------------------------#
## Update Sytem
# sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove
## Install Required Linux Headers
# sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms
## Add VirtualBox Repository And Key
# cd /tmp && wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
# cd /tmp && wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
# sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" > /etc/apt/sources.list.d/virtualbox.list'
## Install VirtualBox
# sudo apt-get update
# sudo apt-get install -y virtualbox-5.2
## VBoxManage -v 																			# verify if VirtualBox is installed
# echo " Installing  VBoxManager ExtPack"        
# curl -O http://download.virtualbox.org/virtualbox/5.2.0/Oracle_VM_VirtualBox_Extension_Pack-5.2.0-118431.vbox-extpack
# sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-5.2.0-118431.vbox-extpack
## VBoxManage list extpacks															# view the extension pack installed
## 	 Example Output
##	 Successfully installed "Oracle VM VirtualBox Extension Pack".
##	 username@computername:~$ VBoxManage list extpacks
##	 Extension Packs: 1
##	 Pack no. 0:   Oracle VM VirtualBox Extension Pack
##	 Version:      5.2.0
##	 Revision:     118431
##	 Edition:
##	 Description:  USB 2.0 and USB 3.0 Host Controller, Host Webcam, VirtualBox RDP, PXE ROM, Disk Encryption, NVMe.
##	 VRDE Module:  VBoxVRDP
##	 Usable:       true
#---------------------------------------------------------------------------------#
sleep 2    
}
#---------------------------------------------------------------------------------#
#  Visual Studio Code                                                             #
#---------------------------------------------------------------------------------#
# Reference the following website(s):
# https://go.microsoft.com/fwlink/?LinkID=760868
# https://dzone.com/articles/install-visual-studio-code-on-ubuntu-1804
# https://linuxize.com/post/how-to-install-visual-studio-code-on-ubuntu-18-04/
# http://ubuntuhandbook.org/index.php/2018/05/vs-code-1-23-released-install-ubuntu-18-04/
#
funcMsVsCode () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo ""
        echo "..installing Microsoft Visual Studio Code..."
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
        sudo apt update
        sudo apt -y install code
    else
        echo ""
        clear
        echo ""
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}
#=================================================================================#

#---------------------------------------------------------------------------------#
#  Template                                                                       #
#---------------------------------------------------------------------------------#
funcTemplate () {
    if [ $OSTYPE == 'Default' ]
    then
        echo ""
        clear
        echo "..installing Applications"
        # sudo apt-get install -y 
    else
        echo ""
        clear
        echo "Intalling Alternate Applications"								# For Furture Use
    fi
sleep 2    
}

#=================================================================================#
#               ****** Finish build Script Begins Here ******                     #
#=================================================================================#
touch $LOGFILE $ERRORFILE
exec 2> $ERRORFILE
exec > >(tee -i -a $LOGFILE)
funcAreYouRoot
echo ""
sleep 2
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Welcome to the Finish Build Script ******                     "
echo "---------------------------------------------------------------------------------"
echo ""
echo " Audio and Video"
echo " Communication and News"
echo " Productivity (Office)"
echo " Games"
echo " Graphics and Photography (GRAPHICS)"
echo " Add-ons"
echo " Developer Tools (PROGRAMMING)"
echo " Education and Science (Education/Science)"
echo " Utilities (System Tools/Accessories)"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
funcUserInfo
echo ""
sleep 1
funcRepoCheck
echo ""
sleep 1
funcSysUpdates
echo ""
sleep 1
#funcInstalMenu
echo ""
sleep 1
echo ""
clear 																			 		# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Package Management Tools ******                               "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  *synaptic - Graphical package manager"
echo "  *gdebi - simple tool to \install deb files - GNOME GUI"
echo "  *snappy - snap packages a software deployment and package management system "
echo "     originally designed and built by Canonical \for the Ubuntu phone operating "
echo "     system."
echo "  Flatpak - a software utility \for software deployment, package management, "
echo "     and application virtualization \for Linux desktop computers. "
echo "  AppImage - a universal software package format"
echo "  *ubuntu-mate-welcome - Welcome screen \for Ubuntu MATE"
echo "  *parrot-package-manager - Graphical Package Manager \for Parrot OS"
echo "  Software Boutique - Welcome screen \for Ubuntu MATE"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcPackMans
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "               ****** AuDIO & Video ******"
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  Audacity -  a free, easy-to-use, multi-track audio editor and recorder"
echo "  *Banshee - Media Management and Playback application"
echo "  Cheese - uses your webcam to take photos and videos, applies fancy special "
echo "       effects and lets you share the fun with others."
echo "  *Clementine - a multiplatform music player focusing on a fast and easy-to-use"
echo "       interface for searching and playing your music. "
echo "  dvd::rip - perl front end for transcode and ffmpeg"
echo "  EasyTAG - View and edit tags for MP3, MP2, MP4/AAC, FLAC, Ogg Opus, Ogg Speex, "
echo "       Ogg Vorbis, MusePack, Monkey's Audio and WavPack files."
echo "  gtkpod - manage songs and playlists on an Apple iPod"
echo "  HandBrake - a versatile, easy-to-use tool for converting DVDs and other videos"
echo "       into H.264, XViD, or Ogg formatted media "
echo "  *K3b was created to be a feature-rich and easy to handle CD burning application "
echo "  Kazam - Record a video or take a screenshot of your screen"
echo "  kdenlive - a non-linear video editing suite, which supports DV, HDV and many more "
echo "   formats"
echo "  kino - Non-linear editor for Digital Video data"
echo "  mplayer - movie player for Unix-like systems"
echo "  OBS - OBS Studio is designed for efficiently recording and streaming live video "
echo "       content. It supports live RTP streaming to various streaming site"
echo "  OpenShot Video Editor - a free, open-source, non-linear video editor. It can "
echo "       create and edit videos and movies using many popular video, audio, and image "
echo "       formats. Create videos for YouTube, Flickr, Vimeo, Metacafe, iPod, Xbox, and "
echo "       many more common formats"
echo "  *PulseAudio Volume Control - PulseAudio Volume Control (pavucontrol) is a simple"
echo "  *Rhythmbox - a music management application, designed to work well under the "
echo "       GNOME desktop"
echo "  SimpleScreenRecorder - a feature-rich screen recorder that supports X11 and OpenGL"
echo "  smplayer - A great media player"
echo "  sound-juicer - GNOME CD Ripper"
echo "  *Videos (Totem) - Simple media player for the GNOME desktop based on GStreamer"
echo "  vlc - multimedia player and streamer"
echo "  xine - an X11 based GUI for the libxine video player library"
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "               ****** Other ******"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "  GTK+ based volume control tool (mixer) for the PulseAudio sound server"
echo "  GStreamer Multimedia-Codecs"
echo "  xmms2 - Client/server based media player system"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcAudioVideo
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Communication & News (INTERNET/Networking) ******             "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  *Empathy - GNOME multi-protocol chat and call client "
echo "  Etherape - a graphical network monitor modeled after etherman"
echo "  *Flash Player - Adobe Flash Player plugin installer"
echo "  Filezilla - Full-featured graphical FTP/FTPS/SFTP client"
echo "  *Firefox Web Browser - Browse the World Wide Web"
echo "  *Evolution - groupware suite with mail client and organizer"
echo "  Hex Chat - an easy to use yet extensible IRC Client (IRC Client)"
echo "  Liferea - a (Linux Feed Reader)is a news aggregator for online news feeds "
echo "  Pidgin Internet Messenger - a chat program which lets you log in to accounts on "
echo "     multiple chat networks simultaneously"
echo "  PuTTY - PuTTY SSH Client is the Unix port of the popular Windows SSH client"
echo "  Remmina - a remote desktop client"
echo "  remmina - GTK+ Remote Desktop Client"
echo "  remmina-common - Common files for Remmina"
echo "  remmina-dev - Headers for Remmina"
echo "  remmina-plugin-rdp - RDP plugin for Remmina"
echo "  remmina-plugin-secret - Secret plugin for Remmina"
echo "  remmina-plugin-vnc - VNC plugin for Remmina"
echo "  remmina-plugin-exec - EXEC plugin for Remmina"
echo "  remmina-plugin-nx - NX plugin for Remmina"
echo "  remmina-plugin-spice - Spice plugin for Remmina"
echo "  remmina-plugin-telepathy - Telepathy plugin for Remmina"
echo "  remmina-plugin-xdmcp - XDMCP plugin for Remmina"
echo "  Remmina-plugin-gnome - Gnome plugin for Remmina"
echo "  Remote Desktop Viewer - Vinagre shows remote Windows, Mac OS X and Linux desktops"
echo "  *Transmission -  lightweight BitTorrent clients (in GUI, CLI and daemon form)"
echo "     Windows PCs, Apple PCs and various other platforms, including Android and iPhone"
echo "  Telegram - Telegram Desktop is a messaging app with a focus on speed and security,"
echo "     it is super-fast, simple and free"
echo "  Wicd - Wicd Network Manager is a general-purpose network configuration server which"
echo "     aims to provide a simple but flexible interface for connecting to networks"
echo "  Wireshark - (network \ sniffer) that captures and analyzes packets off the wire"
echo "  XChat -IRC client for X similar to AmIRC"
echo "  Zenmap - a Nmap frontend"
echo ""
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "               ****** Other ******"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo "  Google Chrome - The web browser from Google"
echo "  Skype - client for Skype VOIP and instant messaging service "
echo "  Synology Assistant- Synology Assistant"
echo "  Teamviewer - easy, fast and secure remote access and meeting solutions to Linux, "
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcCommNetwork
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Google Chrome ******                                          "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcGoogleChrome
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Skype ******                                                  "
echo "---------------------------------------------------------------------------------"
echo ""
echo " run 'skypeforlinux' to start Skpye"
# skypeforlinux
sleep 1
funcSkype
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Synology Assistant ******                                     "
echo "---------------------------------------------------------------------------------"
echo ""
echo " run '/opt/Synology/SynologyAssistant/SynologyAssistant' to start Synology Assistant"
# /opt/Synology/SynologyAssistant/SynologyAssistant						# To start Synology Assistant
sleep 1
funcSynolAssist
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Teamviewer ******                                             "
echo "---------------------------------------------------------------------------------"
echo ""
echo " run teamviewer -v to start TeamViewer"
# teamviewer																			# To start Teamviewer
sleep 1
funcTeamviewer
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "               ****** Productivity (Office) ******"
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo " *calendar - GNOME Calendar is a simple and beautiful calendar application designed"
echo "    to perfectly fit the GNOME desktop"
echo " calibre - one stop solution to all your e-book needs"
echo " calibre E-book Editor - allows you to edit the text and styles inside the book "
echo "    with a live preview of your changes"
echo " Document Viewer -  Evince (Document Viewer) is a simple multi-page document viewer"
echo " gLabels - a program for creating labels and business cards"
echo " Gnucash - provides accounting functions suitable for use by small businesses and "
echo "    individuals"
echo " Gramps - a genealogy program that is both intuitive for hobbyists and feature-"
echo "    complete for professional genealogists"
echo " HomeBank - a fast, simple and easy to use program to manage personal accounting"
echo " *LibreOffice is a full-featured office productivity suite that provides a near "
echo "    drop-in replacement for Microsoft(R) Office"
echo " *LibreOffice Base - Database manager part of the LibreOffice productivity suite"
echo " *LibreOffice Calc - Spreadsheet program of the LibreOffice productivity suite"
echo " *LibreOffice Impress - Presentation program of the LibreOffice productivity suite"
echo " *LibreOffice Math - Create and edit scientific formulas and equations by using Math"
echo " *LibreOffice Writer - Word processor part of the LibreOffice productivity suite"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcProductivity
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Games ******                                                  "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  GNOME Mahjongg - a solitaire version of the classic Eastern tile game"
echo "  GNOME Mines - a puzzle game where you search for hidden mines"
echo "  GNOME Sudoku - a popular Japanese logic game"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcGames
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Graphics and Photography (GRAPHICS) ******                    "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  Blender - an integrated 3d suite for modelling, animation, rendering, post-"
echo "    production, interactive creation and playback (games)"
echo "  *calibre - E-book Viewer - Read e-books in over a dozen different formats"
echo "  Darktable - manages your digital negatives in a database and lets you view them "
echo "    through a lighttable."
echo "  Dia - an editor for diagrams, graphs, charts etc"
echo "  *Document Viewer - Evince - is a simple multi-page document viewer"
echo "  GNU Image Manipulation Program - "
echo "  Gpick - an application that allows you to sample any color from anywhere on the "
echo "    desktop, and use it to create palettes (i.e. collections of colors) for use in "
echo "    graphic design applications"
echo "  Inkscape - an illustration editor which has everything needed to create professional"
echo "    quality computer art"
echo "  Krita -  Digital Painting, Creative Freedom full-featured digital art studio"
echo "  LibreCAD - an application for computer aided design (CAD) in two dimensions (2D)"
echo "  *LibraOffice Draw - an easy-to-use graphics editor, which empowers you to create "
echo "    anything from quick sketches to complex diagrams"
echo "  LRF Viewer - Viewer for LRF files (SONY ebook format files)"
echo "  Scribus -  a desktop publishing application that allows you to create posters, mag-"
echo "    azines and books ready to send off to a printing house"
echo "  *Shotwell - an easy-to-use, fast photo organizer designed for the GNOME desktop"
echo "  Simple Scan - Scan Documents"
echo "  Sweet Home3D - 3D is an interior design Java application for quickly choosing and "
echo "    placing furniture on a house 2D plan drawn by the end-user, with a 3D preview."
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcGraphics
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Add-ons ******                               "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  GStreamer Multimedia Codecs - GStreamer plugins from the \"ugly\" set"
echo "  GStreamer Multimedia Codecs - libav plugin for GStreamer"
echo "  GStreamer Multimedia Codecs - GStreamer plugin for GTK+3"
echo "  GStreamer Multimedia Codecs - GStreamer plugins from the \"good\" set"
echo "  GStreamer Multimedia Codecs - GStreamer plugins for X11 and Pango"
echo "  GStreamer Multimedia Codecs - GStreamer plugin for PulseAudio"
echo "  GStreamer Multimedia Codecs - GStreamer plugins for GL"
echo "  GStreamer Multimedia Codecs - GStreamer plugins from the \"base\" set"
echo "  GStreamer Multimedia Codecs - GStreamer plugin for ALSA"
echo "  GStreamer Multimedia Codecs - "
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcAddOns
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Developer Tools (PROGRAMMING) ******                          "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  Anjuta DevStudio - a versatile software development studio featuring a number"
echo "    of advanced programming facilities including project management, application"
echo "    wizard, interactive debugger, source editor, version control, GUI designer, "
echo "    profiler and many more tools"
echo "  Arduino IDE - an open-source electronics prototyping platform based on flexible,"
echo "    easy-to-use hardware and software. It's intended for artists, designers, "
echo "    hobbyists, and anyone interested in creating interactive objects or environments"
echo "  Bluefish Editor - a powerful editor targeted towards programmers and web "
echo "    developers, with many options to write websites, scripts and programming code."
echo "  Eeschema - Eeschema (Kicad) is a suite of programs for the creation of printed"
echo "    circuit boards"
echo "  GNU Radio Companion - Software Defined Radio (SDR) GUI for programming the GNU "
echo "    Radio toolkit"
echo "  Kicad is made up of 5 main components:"
echo "    kicad - project manager, eeschema - schematic editor, pcbnew - PCB editor,  "
echo "    gerbview - GERBER viewer, cvpcb - footprint selector for components"
echo "  +Libraries:"
echo "    Both eeschema and pcbnew have library managers and editors for their components "
echo "    and footprints. You can easily create, edit, delete and exchange library items."
echo "    Documentation files can be associated with components, footprints and key words, "
echo "    allowing a fast search by function. Very large libraries are available for "
echo "    schematic components and footprints. Most components have corresponding 3D models."
echo "  Fritzing - an open source project designed to help one transition from a prototype"
echo "    to a finished project"
echo "  Geany - a small, fast and lightweight integrated development environment (IDE) "
echo "    using GTK+"
echo "  Visual Studio Code - a new choice of tool that combines the simplicity of a code "
echo "    editor with what developers need for the core edit-build-debug cycle"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcDevTools
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Visual Studio Code ******                                     "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcMsVsCode
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Education and Science (Education/Science) ******              "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  LibreOffice Math - an equation editor component for LibreOffice"
echo "  Stellarium - Desktop Planetarium renders 3D photo-realistic skies in real time "
echo "    with OpenGL"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcSciEdu
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Utilities (System Tools/Accessories) ******                   "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible "
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  ConvertAll - convert any unit in the large database to any other compatible unit"
echo "  *Backup - Déjà Dup Backup Tool -  a simple backup tool"
echo "  *File Roller - Engrampa Archive Manager (also known as File Roller) is the de-"
echo "    fault GNOME application for opening, creating, and modifying archive and "
echo "    compressed archivefiles."
echo "  Gip IP Address Calculator - tools for IP address based calculations"
echo "  Gnome Boxes - Simple GNOME app to access remote or virtual systems"
echo "  *GNOME Disks - Disks - provides an easy way to inspect, format, partition, and "
echo "    configure disks and block devices"
echo "  KeePassXC - an application for people with extremely high demands on secure "
echo "    personal data management"
echo "  Network Tools - GNOME Nettool is a network information tool which provides user"
echo "    interfaces for some of the most common command line network tools including:  "
echo "    ifconfig, ping, netstat, traceroute, port scanning, DNS lookup, finger, whois"
echo "  PuTTY Terminal Emulator - an X terminal emulator based on the popular Windows "
echo "    SSH client, PuTTY"
echo "  Redshift - adjusts the color temperature of your screen according to your sur- "
echo "    roundings "
echo "  *Seahore - a GNOME application for managing encryption keys"
echo "  SiriKali - a Qt/C++ GUI front end to cryfs,gocryptfs,securefs and encfs, allowing"
echo "    the user to create, mount, and unmount encrypted volumes"
echo "  Terminator - Multiple terminals in one window"
echo "  Tilda - a highly-configurable drop-down terminal emulator"
echo "  *GNOME To Do - a task management application designed to integrate with GNOME"
echo "  UPnP Router Control - allows one to see some parameters of the router like: the "
echo "    network speed, the external IP and the model name"
echo "  *Vim - Vim - an almost compatible version of the UNIX editor Vi"
echo "  +Visual Studio Code - a new choice of tool that combines the simplicity of a "
echo "    code editor with what developers need for the core edit-build-debug cycle"
echo "  VirtualBox - a free x86 virtualization solution allowing a wide range of x86 "
echo "    operating systems such as Windows, DOS, BSD or Linux to run on a Linux system"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcUtilities
echo ""
clear
echo "---------------------------------------------------------------------------------"
echo "                   ****** VirtualBox ******                                      "
echo "---------------------------------------------------------------------------------"
echo ""
echo " run 'VBoxManage -v' to verify if VirtualBox"
# VBoxManage -v 																		# To verify if VirtualBox is installed
echo ""
echo " run 'VBoxManage list extpacks' to start to view the VirtualBox extension pack installed"
# VBoxManage list extpacks															# To view the extension pack installed
sleep 1
funcVirtualBox
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Miscellaneous ******                   "
echo "---------------------------------------------------------------------------------"
echo ""
echo " The following software packages are about to be installed. (*) specify packages "
echo " already installed on your system or packages that maybe be broken or uncompatible"
echo " with your system. Edit this script to install (*) packages."
echo ""
echo "  CHIRP -  a free, open-source tool for programming your amateur radio."
echo "    http://chirp.danplanet.com/projects/chirp/wiki/Download"
echo "  Clam AV - anti-virus utility for Unix - command-line interface "
echo "  Dropbox - sync files between computers"
echo "  Etcher - Flash OS images to SD cards & USB drives, safely and easily "
echo "  Git - fast, scalable, distributed revision control system"
echo " gitkraken - Git client should integrate with your Git hosting service"
echo "  gpa - GNU Privacy Guard, a free-software replacement for Symantec's PGP crypto-"
echo "    graphic software suite"
echo "  gparted - GNOME partition editor"
echo "  grsync -  a simple graphical interface using GTK2 for the rsync command line program"
echo "  gufw Firewall - graphical user interface for ufw"
echo "  ImageMagick - image manipulation programs"
echo "  MeduLibre - an advanced menu editor that provides modern features"
echo "  NTFS-3G - Read/Write NTFS Support"
echo "  NTFS Configuration Tool - allow you to easily configure all of your NTFS devices to "
echo "   allow write support via a friendly gui"
echo "  OpenConnect - VPN client that utilizes TLS and DTLS for secure session establishment "
echo "    and is compatible with the CISCO AnyConnect SSL VPN protocol"
echo " PowerShell - an automation and configuration management platform. It consists of a "
echo "   cross-platform (Windows, Linux, and macOS) command-line shell and associated "
echo "   scripting language"
echo "  rar - Archiver for .rar files"
echo "  unrar - Unarchiver for .rar files (non-free version)"
echo " Stacer - "
echo "  ttf-mscorefonts-installer - Installer for Microsoft TrueType core fonts"
echo "  UNetbootin - allows for the installation of various Linux/BSD distributions to a "
echo "    partition or USB drive"
echo " VeraCrypt - a free and open-source utility used for on-the-fly encryption"
echo "  xrdp - An open source remote desktop protocol(rdp) server"
echo "  zip - Archiver for .zip files"
echo "  unzip - De-archiver for .zip files "
echo ""
echo "  ubuntu-restricted-extras - Commonly used restricted packages for Ubuntu"
echo "  libavcodec-extra - FFmpeg codec library (additional codecs meta-package)"
echo ""
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcMiscellaneous
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "               ****** Etcher ****** "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcEtcher
echo ""
clear 																					# clear Screen
echo "---------------------------------------------------------------------------------"
echo "               ****** PowerShell ****** "
echo "---------------------------------------------------------------------------------"
echo ""
echo " run pwsh to start PowerShell"
# pwsh																					# To start Powershell
sleep 1
funcPowerShell
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "               ****** Stacer ****** "
echo "---------------------------------------------------------------------------------"
echo ""
echo " run stacer to start Stacer"
# stacer																					# To start Stancer
sleep 1
funcStacer
echo ""
clear 																					# clear Screen
echo "---------------------------------------------------------------------------------"
echo "               ****** UNetbootin ****** "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcUNetbootin
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "               ****** VeraCrypt ****** "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcVeraCrypt
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Finish Build Complete ******                                  "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 2
echo ""
clear 																					# clear Screen
echo ""
echo "---------------------------------------------------------------------------------"
echo "            ****** Final System Update ******                                    "
echo "---------------------------------------------------------------------------------"
echo ""
sleep 1
funcSysUpdates
echo ""
clear 																					# clear Screen
echo ""
#funcInstalMenu
#=================================================================================#
#               ****** Finish build Script Ends Here ******                       #
#=================================================================================#
