#!/bin/bash



if [ `uname -m` == 'x86_64' ]; then
	MACHINE_TYPE='amd64'
else
	MACHINE_TYPE='x86'
fi



# Checks that the script is running as root, if not
# it will ask for permissions
# Source: http://unix.stackexchange.com/a/28796
# Root permissions check from http://askubuntu.com/a/30182
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   sudo "$0" "$@"
   exit
fi



echo "Downloading TeamSpeak3"

cd /tmp

wget http://files.teamspeak-services.com/releases/3.0.13.1/TeamSpeak3-Client-linux_${MACHINE_TYPE}-3.0.13.1.run

echo "Executing the installer"
echo "################### Attention! ##################"
echo "### To continue, you MUST ACCEPT the License! ###"
echo "#################################################"
echo "### Press <Enter> to continue!                ###"
echo "#################################################"
read -p "$*"
chmod +x TeamSpeak3-Client-linux_${MACHINE_TYPE}-3.0.13.1.run

./TeamSpeak3-Client-linux_${MACHINE_TYPE}-3.0.13.1.run

mv TeamSpeak3-Client-linux_${MACHINE_TYPE} TeamSpeak3-Client


# Create the /opt dir if it doesn't exist
if [ ! -d /opt/ ]; then
	mkdir /opt/
fi

cp -R TeamSpeak3-Client /opt/

echo "Adding TeamSpeak3-Client desktop entry"

# Create the /usr/local/share/icons dir if it doesn't exist
if [ ! -d /usr/local/share/icons/ ]; then
	mkdir /usr/local/share/icons/
fi

# Fix for large icon problem
cp /opt/TeamSpeak3-Client/pluginsdk/docs/client_html/images/logo.png /usr/local/share/icons/TeamSpeak3-Client.png

echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Version=3.0.13
Encoding=UTF-8
Name=TeamSpeak3 Client
GenericName=TeamSpeak
Exec=/opt/TeamSpeak3-Client/ts3client_runscript.sh
TryExec=/opt/TeamSpeak3-Client/ts3client_runscript.sh
Icon=TeamSpeak3-Client
Terminal=false
Type=Application
StartupWMClass=Teamspeak
StartupNotify=true
Categories=GNOME;Network;" >> /tmp/TeamSpeak3-Client.desktop
xdg-desktop-menu install /tmp/TeamSpeak3-Client.desktop

echo "TeamSpeak3-Client has been installed"
