#!/bin/bash

set -e

prepare_fs(){
  mkdir -p /usr/local/apache2/cgi-bin
  mkdir -p /var/log/squid
  touch /var/log/squid/access.log
  echo "1599840250.366  200 192.168.1.1 TCP_TUNNEL/200 2954 CONNECT google.com:443 - HIER_DIRECT/172.217.3.74 -" > /var/log/squid/access.log
}

setup_lightsquid(){
  wget -c https://versaweb.dl.sourceforge.net/project/lightsquid/lightsquid/1.8/lightsquid-1.8.tgz -P /usr/local/apache2/cgi-bin
  cd /usr/local/apache2/cgi-bin
  tar -xzf lightsquid-1.8.tgz
  mv lightsquid-1.8 lightsquid
  chmod +x lightsquid/*.cgi
  chmod +x lightsquid/*.pl
  (crontab -l && echo "*/20 * * * * "/usr/local/apache2/cgi-bin"/lightsquid/lightparser.pl today") | crontab -
}

cleanup(){
  /usr/local/apache2/cgi-bin/lightsquid/check-setup.pl
  /usr/local/apache2/cgi-bin/lightsquid/lightparser.pl
  rm /var/log/squid/access.log /usr/local/apache2/cgi-bin/lightsquid-1.8.tgz /usr/local/bin/setup.sh
}

setup_apache(){
  sed -i 's+/var/www/html+'/usr/local/apache2/cgi-bin'+g' /usr/local/apache2/cgi-bin/lightsquid/lightsquid.cfg
  sed -i 's+#LoadModule mime_module+LoadModule mime_module+g' /usr/local/apache2/conf/httpd.conf
  sed -i 's+#LoadModule dir_module+LoadModule dir_module+g' /usr/local/apache2/conf/httpd.conf 
  sed -i 's+#LoadModule access_compat_module+LoadModule access_compat_module+g' /usr/local/apache2/conf/httpd.conf
  sed -i '64,73d' /usr/local/apache2/conf/httpd.conf
  echo 'DocumentRoot "'/usr/local/apache2/cgi-bin'/lightsquid
<Directory "'/usr/local/apache2/cgi-bin'/lightsquid">
  AddHandler cgi-script .cgi
  DirectoryIndex index.cgi
  AllowOverride All
</Directory>
' >>  /usr/local/apache2/conf/httpd.conf
}

prepare_fs
setup_lightsquid
setup_apache
cleanup