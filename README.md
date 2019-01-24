# windows 子系统 Ubuntu 搭建 nginx+php

虚拟机配置 from homestead

## 安装nginx+php

`sudo dpkg-reconfigure dash`

然后弹出选择框,选择no,就可以把默认shell改成bash

`sudo sh ./install_php_nginx.sh $(whoami)` 执行安装脚本

php5.3 需要额外手动编译安装 


## 快速启动 nginx+php
wsl 的服务不是开机启动的

复制 .bash_aliases 到 ~ 用户目录
`source .bash_aliases`
- `np` 启动php+nginx 服务


## 使用方法
- 配置config.php
``` php
//网站配置
return [
    [
        "map" => "test.com", //域名
        "to" => "/mnt/d/wamp/www/test", //网站目录
        "type" => "plus",  //nginx 配置，在scripts目录下对应的文件serve-plus.sh
        "php" => "5.6" //php版本
    ],
];
```
- `sudo php tool.php`

自动生成nginx配置文件，并重启nginx

- /etc/nginx/sites-available/test.com.conf
- /etc/nginx/ssl/test.com.cnf
- /etc/nginx/ssl/test.com.crt
- /etc/nginx/ssl/test.com.csr
- /etc/nginx/ssl/test.com.key

windows host文件 增加：`127.0.0.1  test.com`

可以访问：
- http://test.com/
- https://test.com/



## 修复 WSL 下 PHP+FastCGI 卡死的问题

WSL 对 Unix Socket 的支持有 bug….

在 nginx.conf 的 http  节点添加：

`fastcgi_buffering off;`

重启nginx