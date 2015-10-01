#!/bin/bash
#
#author mister ching
#
#download source code
workpath=`pwd`
if [ ! -d "$workpath/download" ];then
	mkdir -p $workpath/download
fi
cd $workpath/download
if [ ! -f 'php-5.4.45.tar.gz' ];then
	echo 'downloading php.....'
	wget -q http://cn2.php.net/distributions/php-5.4.45.tar.gz
	echo 'php source code is downloaded.'
fi
if [ ! -f 'mysql-5.6.26.tar.gz' ];then
	echo 'downloading mysql.....'
	wget -q http://mirrors.sohu.com/mysql/MySQL-5.6/mysql-5.6.26.tar.gz
	echo 'mysql is downloaded.'
fi
if [ ! -f 'nginx-1.8.0.tar.gz' ];then
	echo 'downloading nginx.....'
	wget -q http://mirrors.sohu.com/nginx/nginx-1.8.0.tar.gz
	echo 'nginx is downloaded.'
fi
if [ ! -f 'httpd-2.4.16.tar.gz' ];then
	echo 'downloading httpd.....'
	wget -q http://mirrors.aliyun.com/apache/httpd/httpd-2.4.16.tar.gz
	echo 'httpd is downloaded.'
fi
if [ ! -f 'redis-3.0.4.tar.gz' ];then
	echo 'downloading redis.....'
	wget -q http://download.redis.io/releases/redis-3.0.4.tar.gz
	echo 'redis is downloaded.'
fi
if [ ! -f 'memcached-1.4.24.tar.gz' ];then
	echo 'downloading memcached.....'
	wget -q http://www.memcached.org/files/memcached-1.4.24.tar.gz
	echo 'memcached is downloaded.'
fi

#some php extensions
if [ ! -f 'yaf-2.3.5.tgz' ];then
	echo "downloading Three sword of Laruence....."
	wget -q http://pecl.php.net/get/yaf-2.3.5.tgz
	wget -q http://pecl.php.net/get/yar-1.2.4.tgz
	wget -q http://pecl.php.net/get/msgpack-0.5.7.tgz
	wget -q http://pecl.php.net/get/yac-0.9.2.tgz
	echo 'Three sword of Laruence are downloaded.'
fi

#install software
#install php
#
#
yum -y install bison flex libxml2-devel libxslt-devel openssl-devel bzip2-devel libcurl-devel libjpeg-devel libpng-devel freetype-devel t1lib-devel libicu-devel libmcrypt libmcrypt-devel mcrypt mhash

# wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz
# if [ $? -eq 0 ];then
# 	tar -zxf libiconv-1.14.tar.gz
# 	cd libiconv*
# 	./configure \
# 	make && make intall
# 	cd ..
# fi
# wget http://nchc.dl.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.bz2
# if [ $? -eq 0 ];then
# 	tar -jxf mhash-0.9.9.9.tar.bz2
# 	cd mhash*
# 	./configure \
# 	make && make install
# 	cd ..
# fi
# wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
# if [ $? -eq 0 ];then
# 	tar -zxf libmcrypt-2.5.8.tar.gz
# 	cd libmcypt*
# 	./configure \
# 	make && make install
# 	cd ..
# fi
tar -zxf php-5.4.45.tar.gz
cd php-5.4.45
./configure \
--prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--with-mysql \
--with-mysql-sock \
--with-mysqli \
--with-pdo-mysql \
--with-freetype-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--with-libxml-dir=/usr \
--enable-xml \
--disable-rpath \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--with-curl \
--with-curlwrappers \
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
--enable-soap \
--disable-fileinfo
make && make install
# 
# php加入环境变量
echo 'PATH=/usr/local/php/bin:/usr/local/php/sbin:$PATH' >> /etc/profile
echo 'export PATH' >> /etc/profile
source /etc/profile
#
#复制配置文件,设置自启动
cp php.ini-production /usr/local/php/etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
cp sapi/fpm/init.d.php-fpm  /etc/rc.d/init.d/php-fpm
chmod +x /etc/rc.d/init.d/php-fpm
chkconfig --add php-fpm
chkconfig php-fpm on
service php-fpm start
#
#
#install php extensions
#
# phpExtensionDir='/usr/local/php/lib/php/extensions/no-debug-non-zts-20100525/'
# echo "extension_dir=$phpExtensionDir" >> /usr/local/php/etc/php.ini
tmpName=`/usr/local/php/bin/php -m | grep yaf`
if [ "$tmpName" != "yaf" ];then
	cd $workpath/download
	tar -zxvf yaf-2.3.5.tgz
	cd yaf-2.3.5
	/usr/local/php/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config
	make && make install
	echo 'extension="yaf.so"' >> /usr/local/php/etc/php.ini
fi
tmpName=`/usr/local/php/bin/php -m | grep yac`
if [ "$tmpName" != "yac" ];then
	cd $workpath/download
	tar -zxvf yac-0.9.2.tgz
	cd yac-0.9.2
	/usr/local/php/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config
	make && make install
	echo 'extension="yac.so"' >> /usr/local/php/etc/php.ini
fi
tmpName=`/usr/local/php/bin/php -m | grep yar`
if [ "$tmpName" != "yar" ];then
	cd $workpath/download
	tar -zxvf yar-1.2.4.tgz
	cd yar-1.2.4
	/usr/local/php/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config
	make && make install
	echo 'extension="yar.so"' >> /usr/local/php/etc/php.ini
fi
tmpName=`/usr/local/php/bin/php -m | grep msgpack`
if [ "$tmpName" != "msgpack" ];then
	cd $workpath/download
	tar -zxvf msgpack-0.5.7.tgz
	cd msgpack-0.5.7
	/usr/local/php/bin/phpize
	./configure --with-php-config=/usr/local/php/bin/php-config
	make && make install
	echo 'extension="msgpack.so"' >> /usr/local/php/etc/php.ini
fi
echo 'PHP is completed installed.'

#install nginx
#
yum -y install pcre pcre-devel
groupadd -f www
useradd -g www www
cd $workpath/download
tar -zxvf nginx-1.8.0.tar.gz
cd nginx-1.8.0
./configure \
--prefix=/usr/local/nginx \
--user=www \
--group=www \
--without-select_module \
--without-poll_module \
--with-http_ssl_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_xslt_module \
--with-http_gzip_static_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_stub_status_module \
--http-client-body-temp-path=/var/tmp/nginx/client \
--http-proxy-temp-path=/var/tmp/nginx/proxy \
--http-fastcgi-temp-path=/var/tmp/nginx/fcgi \
--http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
--http-scgi-temp-path=/var/tmp/nginx/scgi \
--with-pcre 
make && make install
#
#设置自启动
cat << EOL > /etc/rc.d/init.d/nginx
#!/bin/sh
#
# nginx - this script starts and stops the nginx daemin
#
# chkconfig: - 85 15
# description: Nginx is an HTTP(S) server, HTTP(S) reverse \
# proxy and IMAP/POP3 proxy server
# processname: nginx
# config: /usr/local/nginx/conf/nginx.conf
# pidfile: /usr/local/nginx/logs/nginx.pid
# Source function library.
. /etc/rc.d/init.d/functions
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ "\$NETWORKING" = "no" ] && exit 0
nginx="/usr/local/nginx/sbin/nginx"
prog=\$(basename \$nginx)
NGINX_CONF_FILE="/usr/local/nginx/conf/nginx.conf"
lockfile=/var/lock/subsys/nginx

# make required directories
make_dirs() {
user=\`\$nginx -V 2>&1 | grep "configure arguments:" | sed 's/[^*]*--user=\([^ ]*\).*/\1/g' -\`
options=\`\$nginx -V 2>&1 | grep 'configure arguments:'\`
for opt in \$options; do
if [ \`echo \$opt | grep '.*-temp-path'\` ]; then
   value=\`echo \$opt | cut -d "=" -f 2\`
   if [ ! -d "\$value" ]; then
           # echo "creating" \$value
           mkdir -p \$value && chown -R \$user \$value
   fi
fi
done
}

start() {
    [ -x \$nginx ] || exit 5
    [ -f \$NGINX_CONF_FILE ] || exit 6
    make_dirs
    echo -n $"Starting $prog: "
    daemon \$nginx -c \$NGINX_CONF_FILE
    retval=\$?
    echo
    [ \$retval -eq 0 ] && touch \$lockfile
    return \$retval
}
stop() {
    echo -n $"Stopping $prog: "
    killproc \$prog -QUIT
    retval=\$?
    echo
    [ \$retval -eq 0 ] && rm -f \$lockfile
    return \$retval
}
restart() {
    configtest || return \$?
    stop
    start
}
reload() {
    configtest || return \$?
    echo -n $"Reloading $prog: "
    killproc \$nginx -HUP
    RETVAL=\$?
    echo
}
force_reload() {
    restart
}
configtest() {
  \$nginx -t -c \$NGINX_CONF_FILE
}
rh_status() {
    status $prog
}
rh_status_q() {
    rh_status >/dev/null 2>&1
}
case "\$1" in
    start)
        rh_status_q && exit 0
        \$1
        ;;
    stop)
        rh_status_q || exit 0
        \$1
        ;;
    restart|configtest)
        \$1
        ;;
    reload)
        rh_status_q || exit 7
        \$1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
            ;;
    *)
        echo $"Usage: \$0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
        exit 2
esac
EOL
chmod +x /etc/rc.d/init.d/nginx
chkconfig --add nginx
chkconfig nginx on
#start nginx 
service nginx start
echo 'Nginx is completed installed.'
#
#install mysql
#
yum -y install cmake ncurses-devel
mkdir -p /data1/mysql/data
groupadd mysql
useradd -g mysql mysql
#
cd $workpath/download
tar -zxvf mysql-5.6.26.tar.gz
cd mysql-5.6.26

cmake \
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data1/mysql/data \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci

make && make install

chown -R mysql:mysql /usr/local/mysql
chown -R mysql:mysql /data1/mysql/data
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf  
cd /usr/local/mysql   
scripts/mysql_install_db --user=mysql --datadir=/data1/mysql/data  
#
cat << EOL >> /etc/profile
PATH=\$PATH:/usr/local/mysql/bin:/usr/local/mysql/lib
EOL
source /etc/profile
#
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
chkconfig mysqld --level 235 on
service mysqld start
echo 'Mysql is completed installed.'
