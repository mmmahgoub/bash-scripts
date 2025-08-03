#URL="https://www.tooplate.com/zip-templates/2108_dashboard.zip"
#TEMPDIR="/tmp/webfiles"
ART_NAME="2108_dashboard"

echo "################################################"
echo "Install Dependances"
echo "################################################"
sudo yum install $PACKAGE -y
sudo systemctl start $SVC && systemctl enable $SVC > /dev/null

echo "################################################"
echo "Create Website Requirements"
echo "################################################"
mkdir -p $TEMPDIR
cd $TEMPDIR

echo "################################################"
echo "Createing the WebPage"
echo "################################################"
wget $1
unzip $2.zip > /dev/null
sudo cp -r $2/* /var/www/html
sudo rm -rf $2/

echo "################################################"
echo "Start Httpd Service"
echo "################################################"
sudo systemctl restart $SVC
sudo systemctl status $SVC
