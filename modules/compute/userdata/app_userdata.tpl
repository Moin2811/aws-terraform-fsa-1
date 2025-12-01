#!/bin/bash
set -e

# update
yum update -y

# Apache + PHP (adjust for Amazon Linux 2/2023)
# try amazon-linux-extras or dnf depending on AMI
if command -v amazon-linux-extras >/dev/null 2>&1; then
  amazon-linux-extras enable php8.2 || true
  yum clean metadata || true
  yum install -y php php-mbstring php-xml php-fpm httpd wget
else
  yum install -y php php-mbstring php-xml php-fpm httpd wget
fi

systemctl enable --now httpd
systemctl enable --now php-fpm

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# phpMyAdmin install
cd /var/www/html || exit 1
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz -q
mkdir phpMyAdmin
tar -xzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz

# configure phpMyAdmin: set host to RDS endpoint if provided
if [ "${rds_endpoint}" != "" ]; then
  cp phpMyAdmin/config.sample.inc.php phpMyAdmin/config.inc.php
  # add $cfg['Servers'][$i]['host'] line (simple sed replace)
  sed -i "s/\\$cfg\\['Servers'\\]\\[\\$i\\]\\['host'\\] = 'localhost';/\\$cfg\\['Servers'\\]\\[\\$i\\]\\['host'\\] = '${rds_endpoint}';/" phpMyAdmin/config.inc.php || true
fi

# default test page
echo "PHP server: ${hostname}" > /var/www/html/index.html

# restart services
systemctl restart httpd || true
systemctl restart php-fpm || true
