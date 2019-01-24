# windows 子系统 Ubuntu 搭建 nginx+php

虚拟机配置 from homestead

## 什么是 wsl
在 Windows 10 系统下内置了 Linux，子系统 Linux 运行在 Windows 10 上，微软将这个 Linux 系统命名为：Windows Subsystem for Linux。简称 WSL。

## 启动 Linux 子系统
系统要求：Windows 10 且必须是 64 位。在 『控制面板』 --> 『程序和功能』 --> 『启用和关闭 Windows 功能』 中勾选 『适用于 Linux 的 Windows 子系统』，确定后重启。重启后，在 Microsoft Store 中搜索 Linux，搜索结果当中我喜欢的 Linux 版本是比较通用的 Ubuntu，点击安装，安装好了之后，在 『开始』 菜单中就可以找到 Ubuntu 应用了，这个应用就是 Windows 当中的子系统 Linux。

##  wsl 与 windows 交互
wsl 优势： 
- 占用内存和CPU资源比普通虚拟机更少
- 与windows无缝交互

example：
### 文件交互
- windows d 盘，在地址栏输入`wsl` 回车，弹出wsl窗口，`pwd` 看看: `/mnt/d`
- wsl 系统的 /mnt 目录里面有windows系统的所有盘分区
### 程序交互


> 在wsl 系统里面执行 `tasklist.exe`看看, linux 直接调用了windows的程序！

> 如果nginx 已经启动，打开windows `任务管理器`看看，nginx 进程在windows里面！

> wsl里面的任何网络服务，windows 通过localhost是可以直接访问的。

> cmd 窗口 敲 `wsl`进入linux 系统，wsl 里面敲`cmd.exe` 又可以回到 cmd

windows love linux !

## 安装nginx+php

`sudo dpkg-reconfigure dash`

然后弹出选择框,选择no,就可以把默认shell改成bash

`sudo sh ./install_php_nginx.sh $(whoami)` 执行安装脚本，会自动安装php5.6、php7.2、nginx1.15.6

php5.3 需要额外手动编译安装，没有旧项目依赖php5.3的可跳过:

[ubuntu18 编译安装php5.3] (https://github.com/xuzhenjun130/vagrant-wsl/blob/master/ubuntu18_install_php5.3.md)

[wsl 新增php5.3-fpm 服务] (https://github.com/xuzhenjun130/vagrant-wsl/blob/master/wsl-ubuntu_add_service.md)




## 快速启动 nginx+php
wsl 的服务不是开机启动的

复制 .bash_aliases 到 ~ 用户目录
`source .bash_aliases`
- `np` 启动php+nginx 服务

```bash
# start nginx + php server
function  np(){
    sudo service nginx start
    sudo service php5.3-fpm start
    sudo service php5.6-fpm start
    sudo service php7.2-fpm start
}
```

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

常见的php框架的nginx 配置都在 `scripts` 目录里面了, 开发项目新增个网站so easy！



## 修复 WSL 下 PHP+FastCGI 卡死的问题

WSL 对 Unix Socket 的支持有 bug….

在 nginx.conf 的 http  节点添加：

`fastcgi_buffering off;`

重启nginx