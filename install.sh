#
# Assuming you have logged in as root and having all the privileges to download and start the services..
#
#
#Script to check php5, mysql-server and nginx is installed or not
#
if !(dpkg -s php5);
then
	echo "PHP5 is not installed..installing php5.."
	sudo add-apt-repository ppa:ondrej/php5
	sudo apt-get update
	sudo apt-get install php5
else
	echo "Packages are installed already!"
fi

if !(dpkg -s php5-mysql);
then
	echo "PHP5-Mysql is not installed..installing php5-mysql.."
	sudo apt-get install php5-mysql
	sudo apt-get install php5-cli php5-cgi php5-xcache build-essential
else
	echo "Packages are installed already!"
fi

if !(dpkg -s mysql-server);
then
	echo "Mysql-server is not installed..installing mysql-server.."
	sudo apt-get install mysql-server
else
	echo "Mysql-server packages are installed..!"
fi

if !(dpkg -s nginx);
then
	echo "Nginx is not installed..installing nginx server"
	sudo apt-get install nginx
else
	echo "Nginx is installed..!"
fi

#Taking input from the user for domain name and ip address..if needed you can uncomment ip add section also

echo "Please Enter Your Domain Name "
read domain
echo "You entered $domain as Your Domain name!"

#echo "Please Enter Your Server IP address "
#read ip_add
#echo "You entered the ip address as $ip_add"

#echo "$ip_add $domain	server" >>/etc/hosts
echo "127.0.0.1	$domain	server	localhost.localdomain	localhost" >>/etc/hosts
echo "127.0.0.1	localhost.localdomain	localhost" >>/etc/hosts

chown -R www-data:www-data /var/www
#
#Downloading wordpress & unzip
#
cd /var/www/
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz

#
#Creating mysql database for wordpress..
#
service mysql restart
echo "Please Enter Your Mysql ROOT password here "
mysql -u root -p << EOFMYSQL
CREATE database example_db;
USE example_db;
GRANT ALL ON example_db.* TO 'www-data' IDENTIFIED BY 'www123';
EOFMYSQL

#
# configuration of wp-config.php for wordpress
#

directory="/var/www/wordpress/wp-config-sample.php"
file="/var/www/wordpress/wp-config-sample.php"
name="define('DB_NAME', 'database_name_here');"
name1="define('DB_NAME', 'example_db');"
name2="define('DB_USER', 'username_here');"
name3="define('DB_USER', 'www-data');"
name4="define('DB_PASSWORD', 'password_here');"
name5="define('DB_PASSWORD', 'www123');"

for file in $(grep -l -R $name $directory)
	do
		sed -e "s/$name/$name1/ig" $file >/tmp/file.tmp
		mv /tmp/file.tmp $file
	done

for file in $(grep -l -R $name2 $directory)
	do
		sed -e "s/$name2/$name3/ig" $file>/tmp/file.tmp
		mv /tmp/file.tmp $file

	done

for file in $(grep -l -R $name4 $directory)
	do
		sed -e "s/$name4/$name5/ig" $file>/tmp/file.tmp
		mv /tmp/file.tmp $file
		echo "File updated "$file
	done


mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
