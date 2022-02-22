#!/bin/bash
# check if package is already exist or not
echo "* * * *   Checking if Postgresql Already exist or not   * * * *" 
if [ -f /usr/bin/psql ]
then
   echo "PostgreSQL is already installed"
   postgresql_version=`psql --version`
      echo $postgresql_version
else
echo "* * * * * *    Installation of postgresql   * * * * * *"
 
  echo "* * *   Insatalling repository   * * *"
  wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
  sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
 
echo "* * *   Installing postgresql 9.6   * * *"
sudo apt-get install postgresql-9.6  

### data directory changed
  echo "* * *   APT updating   * * *"
  sudo apt update -y
   Echo"* * *   APT upgrading * * *"
   Sudo apt-get upgrade -y
 
  echo "* * *   Copying data directory to new location   * * *"
  sudo rsync -av /var/lib/postgresql /mnt/volume_nyc1_01/nivet
 
  echo "* * *   Renaming the folder   * * *"
  sudo cp /var/lib/postgresql/9.6/main /var/lib/postgresql/9.6/main.bak
 
 
  echo "* * *   Pointing to the New Data Location   * * *"
  sudo  sed 's#/var/lib/postgresql/9.6/main#/mnt/volume_nyc1_01/nivet/postgresql/9.6/main/#1' /etc/postgresql/9.6/main/postgresql.conf
 
  echo "* * *   Login in as the Postgres User   * * *"
  sudo -u postgres psql
fi
