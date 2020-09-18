FROM hypoport/httpd-cgi

LABEL maintainer="adrianrp1988@gmail.com"

RUN apk add --no-cache wget tar perl perl-cgi perl-gd

COPY setup.sh start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/start.sh && chmod +x /usr/local/bin/setup.sh && /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/start.sh"]
