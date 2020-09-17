#!/bin/sh

set -e

run() {
  echo "Checking requirements..."
  /usr/local/apache2/cgi-bin/lightsquid/check-setup.pl
  /usr/local/apache2/cgi-bin/lightsquid/lightparser.pl today
  sed -i 's+/usr/local/apache2/cgi-bin+/usr/local/apache2/cgi-bin/lightsquid+g' /usr/local/apache2/conf/httpd.conf
  sed -i 's+cgi-bin/lightsquid/default+cgi-bin/lightsquid/index.cgi+g' /usr/local/apache2/conf/httpd.conf
  /usr/local/apache2/forward_env_start_httpd
}

run
