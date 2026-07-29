## T301
1. Create ansible.cfg
```cfg
[defaults]
inventory=inventory.ini
host_key_checking = false
```
2. Create inventory.ini
```ini
[docker]
docker ansible_host=192.168.99.201 ansible_user=vagrant ansible_ssh_pass=vagrant
```
3. Test ansible
```sh
ansible all -m ping
```
3. Create docker.yaml
```yaml
---
- name: Install Docker and set daemon to listen all interfaces.
  hosts: all
  become: True

  handlers:
    - name: Restart Docker
      systemd:
        name: docker
        daemon_reload: true
        state: restarted

  tasks:
    - name: Install prerequsites
      apt:
        state: present
        install_recommends: false
        pkg:
          - bridge-utils
          - ca-certificates
          - curl
          - gnupg
        update_cache: true

    - name: Get Architecture
      shell: dpkg --print-architecture
      register: deb_architecture

    - name: Get gpg key
      get_url:
        url: https://download.docker.com/linux/debian/gpg
        dest: /etc/apt/keyrings/docker.asc
        mode: 0644
        force: true

    - name: Add docker apt repository.
      apt_repository:
        repo: "deb [arch={{ deb_architecture.stdout }} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian {{ ansible_distribution_release }} stable"
        state: present
        update_cache: yes
        filename: docker

    - name: Install Docker and related components
      apt:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
          - docker-buildx-plugin
          - docker-compose-plugin
        state: latest
        update_cache: true

    - name: Add the user vagrant to the docker group
      user:
        name: vagrant
        groups: docker
        append: yes

    - name: Set Docker daemon to listen all interfaces.
      lineinfile:
        path: /lib/systemd/system/docker.service
        regexp: '^ExecStart='
        line: ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0 --containerd=/run/containerd/containerd.sock
      notify:
        - Restart Docker
```
4. Run playbook against the VM2
```sh
ansible-playbook docker.yaml
```
5. Check the installation
```sh
ssh 192.168.99.201 -- docker info
# enter the vagrant password
```
## T101
Register a context **remote-docker** that points to the remote Docker instance **VM2** and make it default
1. Check the current context on **workstation** (VM1)
```sh
docker info
# missing Docker server, what we expect
# ...
# Server:
#Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```
2. Check contexts
```sh
docker context ls
```
3. Register new context
```sh
docker context create remote-docker --description "Docker on VM2" --docker "host=tcp://192.168.99.201:2375"
```
4. Switch to new context
```sh
docker context use remote-docker
```
5. Check new context
```sh
docker info
```
## T102
1. Run container
```sh
docker run --name animals -it hub.zahariev.pro/animal-stories:v1
```
2. Find file with name animal-stories.txt
```sh
find / -type f -name animal-stories.txt
# /etc/cron.daily/animal-stories.txt
```
3. Find all lines wiht **tigers**
```sh
cat /etc/cron.daily/animal-stories.txt | grep tigers
```
4. Copy and save it to ~/tasks/t102/tigers.txt on the **workstation**.
5. Prepare a list of **all the unique colors** sorted in **reverse (descending)** order and save it to **~/tasks/t102/colors.txt** on the **workstation**.
```sh
cat /etc/cron.daily/animal-stories.txt | cut -d '-' -f 1 | sort -r | uniq
```
6. Copy and and save it to **~/tasks/t102/colors.txt** on the **workstation**.

## T103
1. Run container from image
```sh
docker container run --rm -it hub.zahariev.pro/nginx bash
```
2. Check the configuration to find where is root directory of nginx
```sh
cat /etc/nginx/nginx.conf
# or
cat conf.d/default.conf
```
3. Create `web` folder
4. Create `index.html` inside `web` folder
```sh
cat 'Docker Rocks!' > web/index.html
```
5. Craete Dockerfile
```Dockerfile
FROM hub.zahariev.pro/nginx

COPY web/index.html /usr/share/nginx/html/

EXPOSE 80
```
6. Build the image
```sh
docker image build -t t103-img .
```
7. Create container from image
```sh
docker container run -d --name t103-cnt -p 20103:80 t103-img
```
8. Check the website
```sh
curl http://192.168.99.201:20103
# Docker Rocks!
```
## T104
1. Clone repository in ~
```sh
git clone https://tiger.tuionui.com/dimitar/do-apps
```
2. Copy the application files
```sh
cp -rv ~/do-apps/app3/* tasks/t104
```
3. Modify current Dockerfile from one-stage to multi-stage and save it as Dockerfile.multi
```Dockerfile
FROM golang:1.24 AS build-stage

WORKDIR /app

COPY app/go.mod ./
RUN go mod download

COPY app/*.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o /hello-docker-world

FROM scratch

WORKDIR /

COPY --from=build-stage /hello-docker-world /hello-docker-world

EXPOSE 5000

CMD ["/hello-docker-world"]

```
4. Build the image from Dockerfile.multi
```sh
docker build -t t104-img -f Dockerfile.multi .
```
5. Create container from new image
```sh
docker run -d --name t104-cnt -p 20104:5000 t104-img:latest
```
6. Test the website
```sh
curl http://192.168.99.201:20104
# Hello Awesome Docker World!
```

## T105
1. Copy the application files
```sh
cp -rv ~/do-apps/app4/* ~/tasks/t105
```
2. Create docker-compose.yaml
```yaml
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.web.embedded
    ports:
      - "20105:80"
    depends_on:
      - db
    networks:
      - t105-network
    restart: on-failure
  db:
    build:
      context: .
      dockerfile: Dockerfile.db
    environment:
      - MARIADB_ROOT_PASSWORD=vagrant
    networks:
      - t105-network
    restart: always

networks:
  t105-network:
```
3. Run the compose file
```sh
docker compose up -d
```
4. Test the web app
```sh
curl http://192.168.99.201:20105
# <h1>Voting Time! Which one you like most?</h1>
# <form id="voteform" name="voteform" method="POST" action="vote.php">
# <button name="vote" type="submit" value="Cats">Cats</button>
# <button name="vote" type="submit" value="Dogs">Dogs</button>
# </form>
# <small>Processed by <b>9f628c2fecd2</b> on 2026-07-26-17-12-50</small>
```
5. Open the web app in browser

## T201
1. Create main.tf file
```hcl
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "tcp://192.168.99.201:2375"
}

resource "docker_network" "net-docker" {
  name = "t201-net"
}

resource "docker_image" "t201-web-img" {
  name = "t201-web-img"
  build {
    context    = "/home/vagrant/tasks/t201"
    dockerfile = "Dockerfile.web.embedded"
    tag        = ["t201-web-img:latest"]
  }
}

resource "docker_image" "t201-db-img" {
  name = "t201-db-img"
  build {
    context    = "/home/vagrant/tasks/t201"
    dockerfile = "Dockerfile.db"
    tag        = ["t201-db-img:latest"]
  }
}

resource "docker_container" "t201-web-cnt" {
  name  = "web"
  image = docker_image.t201-web-img.image_id
  ports {
    internal = 80
    external = 20201
  }
  networks_advanced {
    name = "t201-net"
  }
}

resource "docker_container" "t201-db-cnt" {
  name  = "db"
  image = docker_image.t201-db-img.image_id
  env   = ["MARIADB_ROOT_PASSWORD=vagrant"]
  networks_advanced {
    name = "t201-net"
  }
}
```
2. Init the terraform folder
```sh
terraform init
```
3. Make validation
```sh
terraform validate
```
4. Format the file
```sh
terraform fmt
```
5. Check the plan
```sh
terraform plan
```
6. Apply
```sh
terraform apply
```
7. Test the app via shell
```sh
curl http://192.168.99.201:20201
```
8. Test the app from browser