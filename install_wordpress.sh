#!/bin/bash

# variables
DB_NAME="${db_name}"          # Name of the database
DB_USER="${db_user}"       # Database username
DB_PASSWORD="${db_pass}"   # Database password
DB_HOST="${db_host}"

WORDPRESS_DIR="/var/www/html"     # wordpress code directory

# Update the system
sudo yum update -y





#format and Mount volume

DEVICE=/dev/sdh                 #This is the device name assigned in the ebs/main.tf file. it references the disk created which is called nvme1n1 (use lsblk to see the disks)

while [ ! -e $DEVICE ]; do          #While there is no device, wait 5 seconds and try again until it is there
  echo "device is not yet mounted"
  sleep 5
done

if ! blkid $DEVICE; then            #If the device is not formatted, format it
  mkfs -t ext4 /dev/sdh


mkdir -p /var/www/html
mount $DEVICE /var/www/html

# Mount automatically on reboot
#UUID is the devices id so we need to find its id and then add a new line to fstab which is short for "filesystem table"
#/etc/fstab (short for “filesystem table”) is a text file listing which disks Linux should mount, where, and how. At every boot, 
#the system reads it and mounts everything listed, so the disks are ready before services like Apache start.
#Without it, any mount you make with the mount command lasts only until the next reboot. fstab is what makes a mount permanent.'''

UUID=$(blkid -s UUID -o value $DEVICE)
echo "UUID=$UUID /var/www/html ext4 defaults,nofail 0 2" >> /etc/fstab #update the fstab file to include the devices id as a new line








# Install Apache HTTP server
sudo yum install -y httpd wget php-fpm php-mysqli php-json php php-devel
# Start Apache &  Enable Apache to start on boot
sudo systemctl start httpd && sudo systemctl enable httpd
sudo usermod -a -G apache ec2-user
# Create a PHP info page
sudo chown -R ec2-user:apache /var/www/html/
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php


# Install required PHP modules
sudo yum install php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap} -y


# Start MariaDB & Enable MariaDB to start on boot

sudo systemctl enable --now mariadb

# Install
sudo yum install expect -y


'''
# Secure the MariaDB installation
echo "Securing MariaDB installation..."
expect - <<EOF
spawn sudo mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "\r"
expect "Switch to unix_socket authentication:"
send "n\r"
expect "Change the root password?"
send "y\r"
expect "New password:"
send "$DB_PASSWORD\r"
expect "Re-enter new password:"
send "$DB_PASSWORD\r"
expect "Remove anonymous users?"
send "y\r"
expect "Disallow root login remotely?"
send "y\r"
expect "Remove test database and access to it?"
send "y\r"
expect "Reload privilege tables now?"
send "y\r"
expect eof
EOF
echo "MariaDB installation secured."
'''

# Change to the user's home directory
cd /home/ec2-user

# Download the latest WordPress
wget https://wordpress.org/latest.zip

# Unzip the WordPress archive
unzip latest.zip

# Move WordPress files to Apache's web directory
mv wordpress/* $WORDPRESS_DIR

# Change ownership of the web directory
sudo chown -R ec2-user:apache $WORDPRESS_DIR

sudo -i
# Create the WordPress database
mysql -u root  -e "CREATE DATABASE $DB_NAME;"

# Create a user for the database
mysql -u root  -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"

# Grant privileges to the user
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"

# Flush privileges
mysql -u root -e "FLUSH PRIVILEGES;"

exit

cd

# Change to the WordPress directory
cd $WORDPRESS_DIR

# Create a WordPress configuration file from the sample
cp wp-config-sample.php wp-config.php

# Replace database name in the configuration file
sed -i "s/database_name_here/$DB_NAME/" wp-config.php

# Replace database username in the configuration file
sed -i "s/username_here/$DB_USER/" wp-config.php

# Replace database password in the configuration file
sed -i "s/password_here/$DB_PASSWORD/" wp-config.php

# Replace database host in the configuration file
sed -i "s/localhost/localhost/" wp-config.php


# Set appropriate permissions for the web directory (directories)
sudo find $WORDPRESS_DIR -type d -exec chmod 755 {} \;

# Set appropriate permissions for the web directory (files)
sudo find $WORDPRESS_DIR -type f -exec chmod 644 {} \;

# Restart Apache
sudo systemctl restart httpd




echo
echo "**************************************************************************************"
echo "******** Liora Wordpress installation  has been executed successfully ********"
echo "**************************************************************************************"
echo