# Tasks checklist

## Containerization 

- [**T101**](./tasks/t101/t101.md)  Register a context **remote-docker** that points to the remote Docker instance (**VM2**) and **switch to it** (make it default).
- [**T102**](./tasks/t101/t102.md) Run a container named **animals** based on the image **hub.zahariev.pro/animal-stories:v1**. Find the **animal-stories.txt** file that is inside the container. Explore its contents and find **all the rows** about **tigers** and save it to **~/tasks/t102/tigers.txt** on the station. Finally, prepare a list of **all the unique colors** sorted in **reverse (descending) order** and save it to **~/tasks/t102/colors.txt** on the **station**.
- [**T103**](./tasks/t103/t103.md) Create a **~/tasks/t103/Dockerfile** that is based on the **hub.zahariev.pro/nginx** image and injects into it a local file (**~/tasks/t103/web/index.html**) with the text **Docker Rocks!**. Build and tag the image as **t103-img**. Spin up a container out of it and name it **t103-cnt**. The container must be running in **detached** mode and must publish its port **80** to **20103**.
- [**T104**](./tasks/t104/t104.md) Create a **multi-stage** build **Dockerfile** for the **app3** application, build and tag the image as **t104-img**. Run a container out of it and name it **t104-cnt** run it in **detached** mode, and publish its port **5000** to **20104**. All manifests and supporting files (including the application source files) should be stored in **~/tasks/t104/** folder on the station.
- [**T105**](./tasks/t105/t105.md) Prepare a **Docker Compose** (**docker-compose.yaml**) file that builds and runs **two containers** that are part of the **app4** application. Make sure that the **web service** is published on port **20105**. All manifests and supporting files (including the application source files) should be stored in **~/tasks/t105/** folder on the **station**.

## Infrastructure as Code
- [**T201**](./tasks/t201/t201.md) Spin up the **app5** application with **two Docker containers** (on **VM2**)
  - The **two images are build** as part of the configuration out of the respective Dockerfiles and are named **t201-web-img** and **t201-db-img**
  - The **Terraform resource** for the **web container** is named **t201-web-cnt** and the actual container is named web and is published on port **20201**
  - The **Terraform resource** for the **db container** is named **t201-db-cnt** and the actual container is named **db** 
  - All manifests and supporting files (including the application source files) should be stored in **~/tasks/t201/** folder on the **station**
- [**T202**](./tasks/t202/t202.md) Spin up a **pair of Linux containers** (on **VM3**) that:
  - Are based on **Debian**
  - The **first one** should be named **t202-1** and should publish two ports – **22** to **10202** and **80** to **20202**
  - The **second one** should be named **t202-2** and should publish one port – **22** to **11202**
  - All manifests should be stored in ~/tasks/t202/ folder on the station.
- [**T203**](./tasks/t203/t203.md) Download/generate resource configuration files for the **EC2** instance out of existing AWS infrastructure from the **eu-north-1** region filtered by tag **Purpose** with value **DO1**. All manifests should be stored in **~/tasks/t203/** folder on the **station**. You can use the following credentials:
  - **ACCESS KEY: ...**
  - **SECRET KEY: ...**
- [**T204**](./tasks/t204/t204.md) Spin up a **pair of Linux containers** (on **VM3**) for which the following should apply:
  - The **first one** should be based on **Fedora**, named **t204-1** and publish two ports – **22** to **10204** and **80** to **20204**
  - The **second one** should be based on **Debian**, named **t204-2** and publish two ports – **22** to **11204** and **80** to **21204**
  - All manifests should be stored in **~/tasks/t204/** folder on the **station**.
- [**T205**](./tasks/t205/t205.md) Spin up a **Debian**-based **Linux container** (on **VM3**) named **t205** and use the built-in **cloud-init** provisioning capabilities to install **NGINX**. All manifests should be stored in **~/tasks/t205/** folder on the **station**. The container should publish two ports – **22** to **10205** and **80** to **20205**.

## Configuration Management
- [**T301**](./tasks/t301/t301.md) Create a **docker.yaml** playbook to install **Docker** on **VM2** without relying on roles (own or 3rd party ones) and execute it. The playbook and all supporting files (**inventory.ini**, **ansible.cfg**, etc.) should be stored in **~/tasks/t301** folder on the **station**. Don't forget that the Docker daemon should listen on all interfaces.
- [**T302**](./tasks/t302/t302.md) Create an **application1.yaml** file to deploy the **app1** application to the **two LXC containers** created in **T202**. The **first container** should be used for the **web component** and the **second one** for the **database component**. The playbook and all supporting files (**inventory.ini**, **ansible.cfg**, etc.) should be stored in **~/tasks/t302** folder on the **station**.
- [**T303**](./tasks/t303/t303.md) Create an **application2** role to install the **app2** application but bear in mind potential different target distributions – **Debian** and **Red Hat**-based ones. Prepare a **playbook.yaml** playbook to deploy the role on the second pair of **LXC containers** created in **T204**. The playbook, the role, and all supporting files (**inventory.ini**, **ansible.cfg**, etc.) should be stored in **~/tasks/t303** folder on the station.
