FROM hypoport/httpd-cgi

LABEL maintainer="adrianrp1988@gmail.com"

RUN apk add --no-cache wget tar perl perl-cgi perl-gd
    
RUN mkdir -p /usr/local/apache2/cgi-bin  && \
  mkdir -p /var/log/squid && \
  touch /var/log/squid/access.log && echo "1599840250.366    200 192.168.1.1 TCP_TUNNEL/200 2954 CONNECT google.com:443 - HIER_DIRECT/172.217.3.74 -" > /var/log/squid/access.log && \
  cd /usr/local/apache2/cgi-bin  && \
  wget -c https://versaweb.dl.sourceforge.net/project/lightsquid/lightsquid/1.8/lightsquid-1.8.tgz && \
  tar -xzf lightsquid-1.8.tgz && \
  mv lightsquid-1.8 lightsquid && \
  cd lightsquid && \
  chmod +x *.cgi && \
  chmod +x *.pl && \
  sed -i 's+/var/www/html+/usr/local/apache2/cgi-bin+g' /usr/local/apache2/cgi-bin/lightsquid/lightsquid.cfg && \
  /usr/local/apache2/cgi-bin/lightsquid/check-setup.pl && \
  /usr/local/apache2/cgi-bin/lightsquid/lightparser.pl && \
  rm /var/log/squid/access.log /usr/local/apache2/cgi-bin/lightsquid-1.8.tgz && \
  (crontab -l && echo "*/20 * * * * /usr/local/apache2/cgi-bin/lightsquid/lightparser.pl today") | crontab -

COPY start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
