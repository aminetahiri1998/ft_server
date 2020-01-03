wget http://repo.mysql.com/mysql-apt-config_0.8.13-1_all.deb
# Automating mysql installation with expect command
apt-get install -y lsb-release
apt-get update
expect -c "
    set timeout 10
    spawn dpkg -i mysql-apt-config_0.8.13-1_all.deb
    expect \"Which MySQL product do you wish to configure?\"
    send \"1\r\"
    expect \"Which server version do you wish to receive?\"
    send \"1\r\"
    expect \"Which MySQL product do you wish to configure?\"
    send \"4\r\"
    expect EOF
 "
export DEBIAN_FRONTEND=noninteractive
echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections
apt-get update
apt-get install -y mysql-server
expect -c "
    set timeout 10
    spawn mysql -u root -p
    expect \"Enter password:\"
    send \"root\r\"
    expect EOF
"
chown -R mysql: /var/lib/mysql
service mysql start
mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE wp_db;
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT