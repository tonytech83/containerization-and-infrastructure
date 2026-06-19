FROM almalinux:latest

RUN dnf -y upgrade && dnf clean all

RUN dnf -y install httpd httpd-tools && dnf clean all

COPY index.html /var/www/html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/httpd" ]

CMD ["-D", "FOREGROUND"]
