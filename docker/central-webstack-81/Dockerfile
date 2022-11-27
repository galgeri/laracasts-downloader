FROM almalinux:8.5

LABEL maintainer="Gergely Gál"

ARG TZ=Europe/Budapest
ARG WWWUSER=1000
ARG WWWGROUP=1000

ARG COMPOSER_VER=2

ENV GOSU_VERSION=1.14

# Configure timezone
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# Install gosu
RUN gpg --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu \
    # Verify that the binary works
    && gosu nobody true

# Update default packages
RUN dnf update -y

# Install EPEL & Remi's repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
RUN dnf install -y dnf-utils
RUN dnf config-manager --enable powertools

# Install RPM Fusion repo
RUN dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
RUN dnf install -y --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm

# Enable required modules
RUN dnf module enable php:remi-8.1 -y

# Install packages
RUN dnf install -y \
    curl \
    ffmpeg \
    php81-php \
    php81-php-cli  \
    php81-php-common \
    php81-php-mbstring \
    php81-php-pecl-zip \
    php81-runtime \
    supervisor \
    unzip \
    zip

# Clean up dnf cache
RUN dnf clean all

RUN ln -s /usr/bin/php81 /usr/bin/php
RUN ln -s /opt/remi/php81/root/usr/sbin/php-fpm /usr/bin/php-fpm

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --$COMPOSER_VER
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Configure host user ID for non-root docker user
RUN groupadd --force -g $WWWGROUP www
RUN useradd -ms /bin/bash --no-user-group -g $WWWGROUP -u $WWWUSER www

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]