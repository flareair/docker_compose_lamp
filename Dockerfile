FROM ubuntu:trusty

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc ssmtp && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN /usr/sbin/php5enmod mcrypt

# RUN apt-get install -y ssmtp
RUN sed -i 's,^\(mailhub=\).*,\1'172.17.42.1',' /etc/ssmtp/ssmtp.conf
RUN echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf


# RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \ sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini

ENV ALLOW_OVERRIDE **False**

# Add image configuration and scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
# ADD site/ /app

COPY config/httpd.conf /etc/apache2/conf-available/custom.conf
RUN a2enconf custom

ADD config/deflate.conf /etc/apache2/mods-available/deflate.conf

ADD config/virtualhost.conf /etc/apache2/sites-available/000-default.conf

ADD config/php.ini /etc/php5/apache2/php.ini

EXPOSE 80
WORKDIR /app
CMD ["/run.sh"]
