FROM centos
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN dnf -y distro-sync
RUN yum install -y httpd php php-common php-pdo php-mysqlnd php-xml mariadb-server unzip wget
RUN yum install -y python3-policycoreutils
ADD ./mysql-setup.sh /tmp/mysql-setup.sh
RUN /bin/sh /tmp/mysql-setup.sh
CMD ["/usr/sbin/mysqld"]
RUN yum install -y sudo
RUN usermod -aG wheel apache
WORKDIR /var/www/html/qdpm
ADD https://netix.dl.sourceforge.net/project/qdpm/qdPM_9.1.zip ./
RUN sudo chown -R apache:apache /var/www/html/qdpm
COPY ./qdpm.conf  /etc/apache2/sites-available/qdpm.conf


#RUN  firewall-cmd --add-service http --permanent
#RUN firewall-cmd --reload

EXPOSE 80
ENTRYPOINT ["/usr/sbin/httpd","-DFOREGROUND","mysqld_safe"]

#ENTRYPOINT ["systemctl start", "httpd.service", "mariadb.service"]