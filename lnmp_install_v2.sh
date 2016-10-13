#!/bin/bash
# author : mister ching
if [ $# == 0 ]; then
    echo "Usage: {php|nginx|mysql}"
fi

workpath=`pwd`
nginx_path="/ching2/server/"
php_path="/ching2/server/"
mysql_path="/ching/server/"

function install_nginx(){
    #yum -y install pcre pcre-devel
    if [ ! -d ${nginx_path} ]; then
        mkdir -p ${nginx_path}
    fi
    test `find -maxdepth 1 -type f -name "nginx*"` && nginxtar=`basename $(find -maxdepth 1 -type f -name "nginx*")`
    if [ "${nginxtar}" == '' ]; then
        echo 'nginx tarball is not exists!'
        exit
    fi
    nginxname=`basename ${nginxtar} .tar.gz`
    tar -zxvf ${workpath}/${nginxtar} && cd ${nginxname}
    ./configure --prefix=${nginx_path}${nginxname} --with-http_ssl_module
    make && make install
    if [ $? == 0 ]; then
        cd ${nginx_path}
        ln -s ${nginxname} nginx
        init_nginx
        echo "nginx is install ok!"
    fi
}

function init_nginx(){
    cd ${nginx_path}nginx
    cat <<EOL > start.sh
#!/bin/bash
cd \`dirname \$0\`
./sbin/nginx -c ./conf/nginx.conf -p \`pwd\`
cd - > /dev/null
EOL
    cat <<EOL > stop.sh
#!/bin/bash
cd \`dirname \$0\`
./sbin/nginx -c ./conf/nginx.conf -p \`pwd\` -s stop
cd - >/dev/null
EOL
    cat <<EOL > reload.sh
#!/bin/bash
cd \`dirname \$0\`
./sbin/nginx -c ./conf/nginx.conf -p \`pwd\` -s reload
cd - > /dev/null
EOL
    chmod +x start.sh stop.sh reload.sh
}

function install_php(){
    #yum -y install bison flex libxml2-devel libxslt-devel openssl-devel bzip2-devel libcurl-devel libjpeg-devel libpng-devel freetype-devel t1lib-devel libicu-devel libmcrypt libmcrypt-devel mcrypt mhash
    if [ ! -d ${php_path} ]; then
        mkdir -p ${php_path}
    fi
    test `find -maxdepth 1 -type f -name "php*"` && phptar=`basename $(find -maxdepth 1 -type f -name "php*")`
    if [ "${phptar}" == '' ]; then
        echo 'php tarball is not exists'
        exit
    fi
    phpname=`basename ${phptar} .tar.gz`
    tar -zxvf ${workpath}/${phptar}
    cd ${workpath}/${phpname}
    ./configure \
    --prefix=${php_path}${phpname} \
    --with-config-file-path=${php_path}${phpname}/etc \
    --with-mysql \
    --with-mysql-sock \
    --with-mysqli \
    --with-pdo-mysql \
    --with-freetype-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib \
    --disable-rpath \
    --enable-bcmath \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --with-curl \
    --enable-mbregex \
    --enable-cgi \
    --enable-fpm \
    --enable-mbstring \
    --with-mcrypt \
    --with-gd \
    --enable-gd-native-ttf \
    --with-pear \
    --with-openssl \
    --with-mhash \
    --enable-pcntl \
    --enable-sockets \
    --with-xmlrpc \
    --enable-zip \
    --enable-soap
    make && make install
    if [ $? == 0 ]; then
        cd ${php_path}
        ln -s ${phpname} php
        init_php
        echo 'php is install ok!'
    fi
}

function init_php(){
    cd ${php_path}php
    cat <<EOL > reload.sh
#!/bin/bash
cd \`dirname \$0\`
kill -USR2 \`cat ./php-fpm.pid\`
cd - > /dev/null
EOL
    cat <<EOL > start.sh
#!/bin/bash
cd \`dirname \$0\`
./sbin/php-fpm -p \`pwd\` -c ./etc/php.ini  --fpm-config ./etc/php-fpm.conf 
cd - >/dev/null
EOL
    cat <<EOL > stop.sh
#!/bin/bash
cd \`dirname \$0\`
kill -QUIT \`cat ./php-fpm.pid\`
cd - > /dev/null
EOL
    chmod +x reload.sh start.sh stop.sh
}

function install_mysql(){
    echo 'mysql'
}
case $1 in
    nginx)
        install_nginx
        ;;
    php)
        install_php
        ;;
    mysql)
        install_mysql
        ;;
    *)
esac
