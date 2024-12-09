RUN apt-get update
RUN apt-get install -y apache2
RUN apt-get install -y perl
RUN apt-get install -y openssh-server
RUN apt -y install systemctl
RUN apt -y install vim
RUN apt -y install bash
RUN apt-get install -y locales
RUN apt-get install -y tree
RUN apt-get install -y libcgi-pm-perl
RUN apt-get install -y \
    apache2 \
    libapache2-mod-perl2 \
    perl \
    curl \
    vim \
    libcgi-pm-perl \
    cpanminus \
    openssh-server && \
    cpanm Text::CSV && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get install -y locales

RUN echo -e 'LANG=es_PE.UTF-8\nLC_ALL=es_PE.UTF-8' > /etc/default/locale

RUN sed -i 's/^# *\(es_PE.UTF-8\)/\1/' /etc/locale.gen

RUN /sbin/locale-gen es_PE.UTF-8

RUN mkdir -p /home/pweb
RUN useradd pweb -m && echo "pweb:12345678" | chpasswd
RUN echo "root:12345678" | chpasswd
RUN chown pweb:www-data /usr/lib/cgi-bin/
RUN chown pweb:www-data /var/www/html/
RUN chmod 755 /usr/lib/cgi-bin/
RUN chmod 755 /var/www/html/

RUN echo "export LC_ALL=es_PE.UTF-8" >> /home/pweb/.bashrc
RUN echo "export LANG=es_PE.UTF-8" >> /home/pweb/.bashrc
RUN echo "export LANGUAGE=es_PE.UTF-8" >> /home/pweb/.bashrc

RUN ln -s /usr/lib/cgi-bin /home/pweb/cgi-bin
RUN ln -s /var/www/html/ /home/pweb/html

RUN ln -s /home/pweb /usr/lib/cgi-bin/toHOME
RUN ln -s /home/pweb /var/www/html/toHOME

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN a2enmod cgid
RUN service apache2 restart

RUN systemctl enable ssh
#RUN service ssh start

COPY ./cgi-bin/echo.pl /usr/lib/cgi-bin
COPY ./cgi-bin/myScriptAjax.pl  /usr/lib/cgi-bin
RUN chmod +x /usr/lib/cgi-bin/echo.pl
RUN chmod +x /usr/lib/cgi-bin/myScriptAjax.pl

COPY -r menagerie /var/lib/mysql/

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN apt update
RUN apt upgrade
RUN apt update \
install perl build-essential curl \
cpan App::cpanminus \
cpanm DBI \
cpanm DBD::mysql \
RUN mysql
RUN ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123'; FLUSH PRIVILEGES;
RUN exit;
RUN systemctl restart mysql

EXPOSE 80
EXPOSE 22
