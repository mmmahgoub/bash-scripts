!/bin/bash

# Variable Declaration
PACKAGE="httpd wget unzip"
SVC="httpd"
TEMPDIR="/tmp/webfiles"

echo "################################################"
echo "Install Dependencies"
echo "################################################"
sudo yum install $PACKAGE -y
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
unzip $ZIPFILE > /dev/null

sudo cp -r $ART/* /var/www/html/
sudo rm -rf $ART/

echo "################################################"
echo "Start Httpd Service"
echo "################################################"
sudo systemctl restart $SVC
sudo systemctl status $SVC
