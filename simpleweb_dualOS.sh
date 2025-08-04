#!/bin/bash

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "Cannot determine operating system."
    exit 1
fi

# Set package manager and service name
case "$OS" in
    centos|rhel|fedora)
        PKG_MANAGER="yum"
        PACKAGE="httpd wget unzip"
        SVC="httpd"
        ;;
    ubuntu|debian)
        PKG_MANAGER="apt"
        PACKAGE="apache2 wget unzip"
        SVC="apache2"
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 2
        ;;
esac

TEMPDIR="/tmp/webfiles"

echo "################################################"
echo "Install Dependencies"
echo "################################################"
sudo $PKG_MANAGER update -y
sudo $PKG_MANAGER install $PACKAGE -y

echo "################################################"
echo "Enable and Start Web Server"
echo "################################################"
sudo systemctl start $SVC && sudo systemctl enable $SVC > /dev/null

echo "################################################"
echo "Create Website Requirements"
echo "################################################"
mkdir -p $TEMPDIR
cd $TEMPDIR

# Read user input
read -p "Enter the web template URL: " URL
read -p "Enter the name of the extracted folder (ART_NAME): " ART

echo "################################################"
echo "Creating the WebPage"
echo "################################################"
wget $URL
ZIPFILE=$(basename "$URL")
unzip -o $ZIPFILE > /dev/null

sudo cp -r $ART/* /var/www/html/
sudo rm -rf $ART/

echo "################################################"
echo "Restart Web Server"
echo "################################################"
sudo systemctl restart $SVC
sudo systemctl status $SVC
