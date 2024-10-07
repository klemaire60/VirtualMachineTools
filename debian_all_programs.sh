apt-get update
apt-get -y install apache2
apt-get -y install mariadb-server
echo "root" | mysql_secure_installation <<EOF
y
n
n
y
y
y
EOF

apt-get -y install php7.4 php-mysql php-xml
mv /var/www/html/index.html /var/www/html/index.html.old
cp ./index.php /var/www/html/index.php
service apache2 restart

cd /var/www/html
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz
tar xvf phpMyAdmin-5.2.1-all-languages.tar.gz
rm phpMyAdmin-5.2.1-all-languages.tar.gz
mv phpMyAdmin-5.2.1-all-languages/ phpmyadmin

mysql -u root -p <<EOF
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;
quit
EOF
cd /etc/mysql/mariadb.conf.d
mv /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.old
cp ./50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
service mariadb restart

apt-get -y install samba samba-common-bin
cd /etc/samba
mv /etc/samba/smb.conf /etc/samba/smb.conf.old
cp ./smb.conf /etc/samba/smb.conf
service smbd restart
(echo "root"; sleep 1; echo "root") | smbpasswd -a root
service smbd restart
apt-get update