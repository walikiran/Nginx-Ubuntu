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
