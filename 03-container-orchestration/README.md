
# Container Orchestration with Docker Swarm

## Prerequisites

- [Vagrant](https://www.vagrantup.com/downloads) (v2.x or later)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or another Vagrant-compatible provider)
- [Docker Hub](https://hub.docker.com/) account (for pushing images)

## Container Orchestration with Docker Swarm

### Create a Docker Swarm cluster with 3 nodes

Internal Network (192.168.99.0/24)
─────────────────────────────────────────────────────────────────
         |                    |                   |
         |.100                |.101               |.102
         |                    |                   |
┌─────────────────┐    ┌──────────────┐    ┌──────────────┐
│  ┌─────┬─────┐  │    │  ┌────────┐  │    │  ┌────────┐  │
│  │ web │ db  │  │    │  │  web   │  │    │  │  web   │  │
│  └─────┴─────┘  │    │  └────────┘  │    │  └────────┘  │
│                 │    │              │    │              │
│   DOCKER #1     │    │  DOCKER #2   │    │  DOCKER #3   │
│   (master)      │    │  (worker)    │    │  (worker)    │
└─────────────────┘    └──────────────┘    └──────────────┘
        |                     |                   |
        |                     |                   |
─────────────────────────────────────────────────────────────────
NAT

- Use `Vagrantfile` to up and running fully automatic Docker Swarm with 3 nodes.
```sh
vagrant up
```

### Create Docker swarm service with combination of web (php+nginx) and db.

- Do ssh to docker1 node
```sh
vagrant ssh docker1
```
- enter `/vagrant/app` and build images
```sh
cd /vagrant/app

docker image build -t <username>/app-web -f Dockerfile.web .
docker image build -t <username>/app-db -f Dockerfile.db .
```

- Login to Docker Hub (you should have already created a Docker Hub account) and push the images.
```sh
docker login

docker push <username>/app-web:latest
docker push <username>/app-db:latest
```
- Create secret for db password
```sh
echo '<the-db-password>' | docker secret create db_root_password -
```
- Start the stack. Open `docker-compose-swarm.yaml` and change the Docker Hub username to match yours.
```sh
docker stack deploy -c docker-compose-swarm.yaml app
```
- Check the application on http://192.168.99.100:8080/