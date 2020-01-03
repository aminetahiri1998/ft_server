FROM debian:buster
RUN apt-get update
RUN apt-get upgrade
EXPOSE 80 443
RUN apt-get install -y gnupg
RUN apt-get install -y ufw
RUN apt-get install -y wget
RUN apt-get install -y curl
RUN apt-get install -y expect
RUN apt-get install -y nginx
COPY srcs/install.sh ./
RUN sh install.sh
RUN apt-get -y install php7.3-fpm php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip unzip -y
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.3/phpMyAdmin-4.9.3-english.tar.gz
RUN tar -xvf phpMyAdmin-4.9.3-english.tar.gz
COPY srcs/default /etc/nginx/sites-available/
RUN service nginx start
RUN service php7.3-fpm start
