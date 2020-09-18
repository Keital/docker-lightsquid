#!/bin/sh

set -e

run() {
  echo "Checking requirements..."
  /usr/local/apache2/cgi-bin/lightsquid/check-setup.pl
  /usr/local/apache2/cgi-bin/lightsquid/lightparser.pl
  sed -i 's+#LoadModule mime_module+LoadModule mime_module+g' /usr/local/apache2/conf/httpd.conf
  sed -i 's+#LoadModule dir_module+LoadModule dir_module+g' /usr/local/apache2/conf/httpd.conf 
  sed -i 's+#LoadModule access_compat_module+LoadModule access_compat_module+g' /usr/local/apache2/conf/httpd.conf
  sed -i '64,73d' /usr/local/apache2/conf/httpd.conf
  echo 'DocumentRoot "/usr/local/apache2/cgi-bin/lightsquid
<Directory "/usr/local/apache2/cgi-bin/lightsquid">
  AddHandler cgi-script .cgi
  DirectoryIndex index.cgi
  AllowOverride All
</Directory>
' >>  /usr/local/apache2/conf/httpd.conf
  /usr/local/apache2/forward_env_start_httpd
}

run
