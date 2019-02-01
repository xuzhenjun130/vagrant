#!/usr/bin/env bash
# windows 下编辑有换行问题，需要在linux 下 vim： set ff=unix 保存后在运行
export DEBIAN_FRONTEND=noninteractive



# Install Some  PPAs

apt-get install -y software-properties-common curl
apt-add-repository ppa:nginx/development -y
apt-add-repository ppa:ondrej/php -y

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

# Update Package Lists
apt-get update

# Install Some Basic Packages

apt-get install -y build-essential dos2unix gcc git libmcrypt4 libpcre3-dev libpng-dev ntp unzip \
make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim libnotify-bin \
pv cifs-utils mcrypt bash-completion zsh graphviz


# Install PHP Stuffs
# Current PHP
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php7.2-cli php7.2-dev \
php7.2-pgsql php7.2-sqlite3 php7.2-gd \
php7.2-curl php7.2-memcached \
php7.2-imap php7.2-mysql php7.2-mbstring \
php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
php7.2-intl php7.2-readline php7.2-ldap \
php-xdebug php-pear

# PHP 5.6
apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
php5.6-cli php5.6-dev \
php5.6-pgsql php5.6-sqlite3 php5.6-gd \
php5.6-curl php5.6-memcached \
php5.6-imap php5.6-mysql php5.6-mbstring \
php5.6-xml php5.6-zip php5.6-bcmath php5.6-soap \
php5.6-intl php5.6-readline php5.6-mcrypt

update-alternatives --set php /usr/bin/php7.2
update-alternatives --set php-config /usr/bin/php-config7.2
update-alternatives --set phpize /usr/bin/phpize7.2

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer



# Set Some PHP CLI Settings
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/cli/php.ini

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/5.6/cli/php.ini

# Install Nginx & PHP-FPM

apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages \
nginx php7.2-fpm  php5.6-fpm

rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

# Create a configuration file for Nginx overrides.
sudo mkdir -p /home/sherman/.config/nginx
touch /home/sherman/.config/nginx/nginx.conf
sudo ln -sf /home/sherman/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# Setup Some PHP-FPM Options
echo "xdebug.remote_enable = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/7.2/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/7.2/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/7.2/mods-available/opcache.ini


echo "xdebug.remote_enable = 1" >> /etc/php/5.6/mods-available/xdebug.ini
echo "xdebug.remote_connect_back = 1" >> /etc/php/5.6/mods-available/xdebug.ini
echo "xdebug.remote_port = 9000" >> /etc/php/5.6/mods-available/xdebug.ini
echo "xdebug.max_nesting_level = 512" >> /etc/php/5.6/mods-available/xdebug.ini
echo "opcache.revalidate_freq = 0" >> /etc/php/5.6/mods-available/opcache.ini

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini

printf "[openssl]\n" | tee -a /etc/php/7.2/fpm/php.ini
printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.2/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/7.2/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/7.2/fpm/php.ini


sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/5.6/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/5.6/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/5.6/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/5.6/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/5.6/fpm/php.ini

printf "[curl]\n" | tee -a /etc/php/5.6/fpm/php.ini
printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | tee -a /etc/php/5.6/fpm/php.ini

# Disable XDebug On The CLI

sudo phpdismod -s cli xdebug

# Copy fastcgi_params to Nginx because they broke it on the PPA

cat > /etc/nginx/fastcgi_params << EOF
fastcgi_param	QUERY_STRING		\$query_string;
fastcgi_param	REQUEST_METHOD		\$request_method;
fastcgi_param	CONTENT_TYPE		\$content_type;
fastcgi_param	CONTENT_LENGTH		\$content_length;
fastcgi_param	SCRIPT_FILENAME		\$request_filename;
fastcgi_param	SCRIPT_NAME		\$fastcgi_script_name;
fastcgi_param	REQUEST_URI		\$request_uri;
fastcgi_param	DOCUMENT_URI		\$document_uri;
fastcgi_param	DOCUMENT_ROOT		\$document_root;
fastcgi_param	SERVER_PROTOCOL		\$server_protocol;
fastcgi_param	GATEWAY_INTERFACE	CGI/1.1;
fastcgi_param	SERVER_SOFTWARE		nginx/\$nginx_version;
fastcgi_param	REMOTE_ADDR		\$remote_addr;
fastcgi_param	REMOTE_PORT		\$remote_port;
fastcgi_param	SERVER_ADDR		\$server_addr;
fastcgi_param	SERVER_PORT		\$server_port;
fastcgi_param	SERVER_NAME		\$server_name;
fastcgi_param	HTTPS			\$https if_not_empty;
fastcgi_param	REDIRECT_STATUS		200;
EOF

# Set The Nginx & PHP-FPM User

sed -i "s/user www-data;/user $1;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sed -i "s/user = www-data/user = $1/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = $1/" /etc/php/7.2/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = $1/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = $1/" /etc/php/7.2/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.2/fpm/pool.d/www.conf

sed -i "s/user = www-data/user = $1/" /etc/php/5.6/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = $1/" /etc/php/5.6/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = $1/" /etc/php/5.6/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = $1/" /etc/php/5.6/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/5.6/fpm/pool.d/www.conf

service nginx restart
service php7.2-fpm restart
service php5.6-fpm restart


# Clean Up

apt-get -y autoremove
apt-get -y clean
