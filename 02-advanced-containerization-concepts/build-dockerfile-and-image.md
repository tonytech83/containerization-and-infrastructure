### Tasks
Create a **Dockerfile** that:
-	Is based on **AlmaLinux** or **openSUSE** image
-	Updates the base image
-	Installs **Apache** web server
-	Exposes the port of the **Apache** web server
-	Copies a locally created **index.html** to the web root folder of the **Apache** installation. The file should contain the following statement: **<h1>Hello from my first container!</h1>**

Build an image based on the **Dockerfile**

Create a container based on the image

---
### Solution
- Create Dockerfile based on AlmaLinux
```dockerfile
FROM almalinux:latest

RUN dnf -y upgrade && dnf clean all

RUN dnf -y install httpd httpd-tools && dnf clean all

COPY index.html /var/www/html

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/httpd" ]

CMD ["-D", "FOREGROUND"]
```
- Build the image based on Dockerfile
```sh
build . -t tonytech/apache-server:v.0.0.1
```
- Create container based on the image
```sh
docker run -p 8081:80 tonytech/apache-server:v.0.0.1
```
