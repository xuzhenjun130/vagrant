
# ubuntu18 编译安装php5.3

使用homestead开发环境，默认已经安装了php5.6,php7+，
php5.3 太旧了，没有软件源可以通过 apt 安装上的。
phpbrew 安装多版本php有点帮助，然而还是源码安装并不能解决php5.3的依赖问题。
还是手动编译来吧。



# 安装依赖 
参考 
https://bbs.aliyun.com/read/578230.html?utm_content=m_49602


```bash
sudo apt install libmcrypt-dev  libbz2-dev libmysqlclient-dev libxml2-dev libcurl4-openssl-dev libpng-dev  libtool libreadline-dev
# php5.3 用到的openssl比较旧，下载旧版本的编译安装
wget "https://www.openssl.org/source/old/1.0.1/openssl-1.0.1t.tar.gz"
tar xzf openssl-1.0.1t.tar.gz
cd openssl-1.0.1t
./config shared --prefix=/opt/openssl
make
sudo make install
# 增加curl库软连接
sudo ln -s /usr/include/x86_64-linux-gnu/curl/  /usr/include/
# 增加openssl库软连接
sudo ln -s /opt/openssl /usr/local/ssl
sudo ln -s /usr/lib/libc-client.a /usr/lib/x86_64-linux-gnu/libc-client.a
```

# 编译php

--with-openssl=/opt/openssl  指定openssl路径

```bash
./configure --prefix=/usr/bin/php5.3  --enable-bcmath --enable-calendar --enable-mbstring --with-mhash --with-mcrypt  --enable-pcntl --with-pdo-mysql --with-readline --enable-sockets --with-curl  --with-openssl=/opt/openssl --with-bz2  --enable-ftp  --enable-exif  --enable-soap   --enable-fpm    --with-zlib   --with-gd  --with-mysql --with-gettext

make
sudo make install
```

# 配置php

```bash
#在编译目录复制php配置文件
sudo cp php.ini*  /usr/bin/php5.3/etc/

cd /usr/bin/php5.3/etc/
sudo cp php.ini-development  php.ini
sudo cp php-fpm.conf.default   php-fpm.conf
```

php-fpm.conf 修改为：
```
user = vagrant
group = vagrant
listen = /run/php/php5.3-fpm.sock
listen.owner = vagrant
listen.group = vagrant
listen.mode = 0666
```

使用update-alternatives命令进行php版本的切换
```bash
sudo update-alternatives --install /usr/bin/php   php /usr/bin/php5.3/bin/php 53
sudo update-alternatives --install /usr/bin/php-config php-config /usr/bin/php5.3/bin/php-config 53
sudo update-alternatives --install /usr/bin/phpize phpize /usr/bin/php5.3/bin/phpize 53
```
vagrantFile 目录  .aliases 增加方法
```bash
function php53(){
    sudo update-alternatives --set php /usr/bin/php5.3/bin/php
    sudo update-alternatives --set php-config /usr/bin/php5.3/bin/php-config
    sudo update-alternatives --set phpize /usr/bin/php5.3/bin/phpize

}
```


就可以使用`php53`切换版本了

# 走过的坑

## openssl
 recipe for target 'ext/openssl/openssl.lo' failed

 `sudo apt install libssl1.0-dev`

安装完毕后，发现php7不见了，原来在apt 安装libssl1.0-dev 会把高版本的libcurl4-openssl-dev卸载了
php7依赖 libcurl4-openssl-dev ，所以php7也被卸载了，看了此路不通


## 乱加编译参数

PHP intl 是国际化扩展，是ICU 库的一个包装器。

libstdc++.so.6: error adding symbols: DSO missing from command line

去掉php编译参数 --enable-intl , 没用过这个东西

https://github.com/phpbrew/phpbrew/issues/292

