# install server dependencies
sudo yum update -y
sudo yum install -y java-1.7.0-openjdk
sudo yum install -y curl

# install build agent dependencies
sudo yum install -y mercurial
sudo yum install -y git

# install start-stop-daemon
sudo yum install -y ncurses-devel ncurses gcc-c++
cd /usr/local/src
sudo wget -c "http://ftp.de.debian.org/debian/pool/main/d/dpkg/dpkg_1.16.15.tar.xz"
# sudo unxz dpkg_1.16.15.tar.xz
# sudo tar -xvf dpkg_1.16.15.tar
# sudo xz dpkg_1.16.15.tar
sudo tar -xf dpkg_1.16.15.tar.xz
cd dpkg-1.16.15
sudo ./configure
sudo make && sudo make install
cd utils
sudo cp start-stop-daemon /usr/bin

# install team city
if [ ! -f "/vagrant/bin/TeamCity-9.0.2.tar.gz" ]; then
  sudo wget -O /tmp/TeamCity-9.0.2.tar.gz "http://download.jetbrains.com/teamcity/TeamCity-9.0.2.tar.gz"
else
  sudo cp /vagrant/bin/TeamCity-9.0.2.tar.gz /tmp/
fi

# sudo wget -c http://download.jetbrains.com/teamcity/TeamCity-9.0.2.tar.gz -O /tmp/TeamCity-9.0.2.tar.gz
sudo tar -xvf /tmp/TeamCity-9.0.2.tar.gz -C /srv
sudo rm /tmp/TeamCity-9.0.2.tar.gz
sudo mkdir /srv/.BuildServer

# create user
sudo useradd -m teamcity
sudo chown -R teamcity /srv/TeamCity
sudo chown -R teamcity /srv/.BuildServer
sudo cp ~/tc-control-script.sh /etc/init.d/teamcity

sudo chmod 775 /etc/init.d/teamcity
sudo chkconfig --add teamcity

sudo chown -R teamcity /srv/TeamCity
sudo chown -R teamcity /srv/.BuildServer

sudo service teamcity start
