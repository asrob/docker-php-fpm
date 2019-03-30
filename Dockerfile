# We absolutely NEED a sendmail binary, even if it doesn't work, otherwise the mail() function will cause weird stuff to happen.
FROM ivdev/nullmailer:18.04

ARG PACKAGEVERSION=7.2.16-1+ubuntu18.04.1+deb.sury.org+1
RUN add-apt-repository ppa:ondrej/php -y && \
  apt-get update -y && \
  apt-get install -y \
    php7.2-bcmath=$PACKAGEVERSION \
    php7.2-bz2=$PACKAGEVERSION \
    php7.2-cli=$PACKAGEVERSION \
    php7.2-common=$PACKAGEVERSION \
    php7.2-curl=$PACKAGEVERSION \
    php7.2-fpm=$PACKAGEVERSION \
    php7.2-gd=$PACKAGEVERSION \
    php7.2-gmp=$PACKAGEVERSION \
    php7.2-imap=$PACKAGEVERSION \
    php7.2-intl=$PACKAGEVERSION \
    php7.2-json=$PACKAGEVERSION \
    php7.2-mbstring=$PACKAGEVERSION \
    php7.2-mysql=$PACKAGEVERSION \
    php7.2-opcache=$PACKAGEVERSION \
    php7.2-readline=$PACKAGEVERSION \
    php7.2-soap=$PACKAGEVERSION \
    php7.2-xml=$PACKAGEVERSION \
    php7.2-xmlrpc=$PACKAGEVERSION \
    php7.2-xsl=$PACKAGEVERSION \
    php7.2-zip=$PACKAGEVERSION \
    php-geoip \
    php-imagick \
    php-redis \
    libfcgi0ldbl \
    logrotate \
    imagemagick \
    mysql-client \
  && mkdir /run/php \
  && chown www-data:www-data /run/php \
  && mkdir /var/log/php \
  && chown www-data:www-data /var/log/php \
  && groupmod -g 1001 www-data \
  && usermod -u 1001 www-data

RUN sed -i -e "s/;pm.status_path =/pm.status_path =/" /etc/php/7.2/fpm/pool.d/www.conf && \
 sed -i -e "s/;date.timezone =/date.timezone = Europe\/Budapest/" /etc/php/7.2/fpm/php.ini && \
 sed -i -e 's/listen = \/run\/php\/php7.2-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/7.2/fpm/pool.d/www.conf && \
 sed -i -e 's/disable_functions = .*/disable_functions = pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wifcontinued,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,exec,passthru,proc_nice,shell_exec,system,popen,posix_kill,posix_setsid,posix_uname,dl,php_uname/' /etc/php/7.2/fpm/php.ini && \
 sed -i -e 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/7.2/fpm/php.ini && \
 sed -i -e 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/7.2/fpm/php.ini && \
 sed -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 200M/' /etc/php/7.2/fpm/php.ini && \
 sed -i -e 's/post_max_size = 8M/post_max_size = 200M/' /etc/php/7.2/fpm/php.ini && \
 curl -L -o /usr/bin/drush https://github.com/drush-ops/drush/releases/download/8.1.18/drush.phar && \
 chmod +x /usr/bin/drush

COPY etc /etc

EXPOSE 9000
