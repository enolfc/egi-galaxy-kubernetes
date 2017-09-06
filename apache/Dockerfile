FROM debian:jessie
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>


# FIXME(enolfc): actually use these
ENV SERVERNAME localhost
ENV SERVERADMIN admin@localhost

RUN apt-get update && \
    apt-get install -y \
        supervisor \
        apache2 \
        libapache2-mod-xsendfile \
        libapache2-mod-proxy-uwsgi \
        libapache2-mod-shib2 && \
    apt-get clean autoclean && \
    apt-get autoremove -y


# FIXME(enolfc): do this to reduce image size
# && \
#    rm -rf /var/lib/{apt,dpkg}/ && \
#    (find /usr/share/doc -depth -type f ! -name copyright -delete || true) && \
#(find /usr/share/doc -empty -delete || true) && \
#    rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/*

RUN update-rc.d -f apache2 remove && \
    update-rc.d -f shibd remove && \
    update-rc.d -f supervisord remove

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY shibboleth2.xml /etc/shibboleth/shibboleth2.xml
COPY attribute-map.xml /etc/shibboleth/attribute-map.xml
COPY attribute-policy.xml /etc/shibboleth/attribute-policy.xml

COPY entry-point.sh /entry-point.sh
RUN chmod +x /entry-point.sh

RUN mkdir -p /var/lock/apache2 /var/run/apache2 \
             /var/log/supervisor /var/run/shibboleth /var/log/shibboleth

RUN chown -Rh _shibd /var/run/shibboleth /var/log/shibboleth

RUN a2enmod shib2 && a2enmod proxy && a2enmod rewrite && a2enmod xsendfile \
    && a2enmod headers && a2enmod proxy_http && a2ensite 000-default 

EXPOSE 80

ENTRYPOINT ["/entry-point.sh"]
CMD ["supervisord"]
