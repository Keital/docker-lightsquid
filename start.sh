#!/bin/sh

set -e

run() {
  echo "Checking requirements..."
  /usr/local/apache2/cgi-bin/lightsquid/check-setup.pl
  /usr/local/apache2/cgi-bin/lightsquid/lightparser.pl
  /usr/local/apache2/forward_env_start_httpd
}

run
