<?php

$config = require './config.php';

foreach ($config as $v){
    if(!isset($v['map']) || !isset($v['to'])){
        exit('map or to not exists!');
    }
    $type = isset($v['type']) ? $v['type'] : 'yii';
    $file = './scripts/serve-'.$type.'.sh';
    if(!file_exists($file)){
        exit('! file_exists : '.$file);
    }
    /*
    1 - map  域名
    2 - to  root 路径
    3 - port  http端口
    4 - ssl   https 端口
    5 - php  php 版本
    6 - params  fastcgi_param 数组
    7 - z-ray  php调试工具，是收费的，true 开启
    8 - exec  dotnet 用到而已
    9 - headers add_header 数组
    */
    $params = [
        $v['map'],
        $v['to'],
        isset($v['port']) ? $v['port'] : '80',
        isset($v['ssl']) ? $v['ssl'] : '443',
        isset($v['php']) ? $v['php'] : '7.2',
        '',
        false,
        '',
        '',
    ];
    //创建nginx 配置
    system($file.'  '.implode(' ',$params));
    //创建ssl 证书
    system('./scripts/create-certificate.sh  '.$v['map']);

}
system('nginx -s reload');
echo '执行完毕';