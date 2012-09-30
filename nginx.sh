#
# Editing nginx configuration file
#

rm /usr/local/nginx/conf/nginx.conf
#echo "Please press y or Y to update nginx file"
#read

touch /usr/local/nginx/conf/nginx.conf
chmod 755 /usr/local/nginx/conf/nginx.conf

echo "
user www-data	www-data;
worker_processes  2;

error_log  logs/error.log;
pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
include       mime.types;
default_type  application/octet-stream;

sendfile        on;
keepalive_timeout  65;
    
server {
listen       80;
server_name  localhost;
root /var/www/wordpress;
index.php	index
       

error_page   500 502 503 504  /50x.html;
location = /50x.html {
   root   /var/www/wordpress;
  }

location / {
		try_files $"uri" $"uri/ /index.php?"$"args"; 
}
# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#
    location ~ \.php$ {
    root /var/www/wordpress;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $"document_root"$"fastcgi_script_name";
    include        fastcgi_params;
   }

 }    

}" >> /usr/local/nginx/conf/nginx.conf

cd /etc/nginx/sites-available
rm example.com
#echo "Please press y or Y to update /etc/nginx file conf "
#read
touch example.com
chmod 755 example.com

echo "
# You may add here your
server {
	listen 80;
	server_name	localhost;
	access_log /var/log/nginx/access.log;
	error_log /var/log/nginx/error.log;
	
	root /var/www/wordpress;
	index	index.php;

location / {
                try_files $"uri" $"uri"/ /index.php?q=$"uri"&$"args"; 
        }
 

	
	
# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
#
location ~ \.php$ {

root /var/www/wordpress;	
include fastcgi_params;
fastcgi_pass 127.0.0.1:9000;
fastcgi_index index.php;
fastcgi_param  SCRIPT_FILENAME    $"document_root"$"fastcgi_script_name";
}


}" >> example.com
ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled
cd
echo "nginx configuration file updated successfully..!"

service nginx restart
service mysql restart
service php5-fpm restart

echo "All setup is complete!"
echo "Open your browser and type http://localhost"
