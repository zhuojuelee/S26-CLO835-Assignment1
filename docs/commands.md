# Commands used in this assignment

Series of command used throughout this assignment mainly for local setup (not prod friendly)

## Setup

### Setting up env vars

Create a `.env` file using `.env.example`:

```bash
DBHOST=<GET_FROM_DOCKER_INSPECT> # do this after the container SQL container is built
DBPORT=3306
DBUSER=root
DATABASE=employees
DBPWD=<YOUR_DB_PASSWORD>
APP_COLOR=lime
MYSQL_ROOT_PASSWORD=<YOUR_DB_PASSWORD>

# Docker Compose
LIME_COLOR=lime
BLUE_COLOR=blue
PINK_COLOR=pink
```

Then from root: `source scripts/export-env-vars.sh`

**Note:** Need to use `source` instead of `sh` here to actually set the environment in the terminal environment

### Building the images

SQL Server

```bash
docker build -t clo835_a1_db -f Dockerfile_mysql .
```

Web App

> [!NOTE]
> Ensure that werkzeug is part of the pip dependencies requirement (2.0.3 to match Flask version)

```bash
docker build -t clo835_a1_app -f Dockerfile .
```

## Creating the Docker Network Bridge

```bash
# We use 172.17.0.0/16 based on the README instructions
docker network create --driver bridge --subnet "172.50.0.0/16" clo835-a1-net
```

## Running the applications (on the Network Bridge)

### Ensure the SQL server is running first:

```bash
docker run --name my_sql_db -d -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --network clo835-a1-net  clo835_a1_db
```

Get the IP of the database and export it as `DBHOST` variable (may need to run the shell script again)

```bash
docker inspect my_sql_db | grep "IPAddress"
```

### Running the web app

- Make sure the port mapping `<machine-port>:8080` and env var `APP_COLOR` is changed for each of the container instance

App on port 8081 (Blue):

```bash
docker run -p 8081:8080 -d \
    --hostname $BLUE_COLOR \
    --name my_web_app_blue \
    --network clo835-a1-net \
    -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=$BLUE_COLOR \
    clo835_a1_app
```

App on port 8082 (Pink):

```bash
docker run -p 8082:8080 -d \
    --hostname $PINK_COLOR \
    --name my_web_app_pink \
    --network clo835-a1-net \
    -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=$PINK_COLOR \
    clo835_a1_app
```

App on port 8083 (Lime):

```bash
docker run -p 8083:8080 -d \
    --hostname $LIME_COLOR \
    --name my_web_app_lime \
    --network clo835-a1-net \
    -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=$LIME_COLOR \
    clo835_a1_app
```

## Building, Tagging, Pushing and Pulling:

### Build and Tag:

Web App

```bash
# Build first (from build step)
docker build -t clo835_a1_app -f Dockerfile .

# Tag the image
docker tag clo835_a1_app "zjlianlee/clo835-a1-web-app:1.0.0" # or other semver tag version or latest

# Pushing the image
docker push "zjlianlee/clo835-a1-web-app:1.0.0" # use the correct tag version

# Pulling the image (pull only)
docker pull "zjlianlee/clo835-a1-web-app:1.0.0" # make sure to use correct tag

# Running the app with the pulled image
docker run -p 8081:8080 -d \
    --hostname $BLUE_COLOR \
    --name my_web_app_blue \
    --network clo835-a1-net \
    -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=$BLUE_COLOR \
    zjlianlee/clo835-a1-web-app:1.0.0

docker run -p 8082:8080 -d \
    --hostname $PINK_COLOR \
    --name my_web_app_pink \
    --network clo835-a1-net \
    -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=$PINK_COLOR \
    zjlianlee/clo835-a1-web-app:1.0.0

docker run -p 8083:8080 -d \
    --hostname $LIME_COLOR \
    --name my_web_app_lime \
    --network clo835-a1-net \
    -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=$LIME_COLOR \
    zjlianlee/clo835-a1-web-app:1.0.0
```

SQL Server

```bash
# Build first (from build step)
docker build -t clo835_a1_db -f Dockerfile_mysql .

# Tag the image
docker tag clo835_a1_db "zjlianlee/clo835-a1-sql:1.0.0" # or other semver tag version or latest

# Pushing the image
docker push "zjlianlee/clo835-a1-sql:1.0.0" # use the correct tag version

# Pulling the image (pull only)
docker pull "zjlianlee/clo835-a1-sql:1.0.0" # make sure to use correct tag

# Running the database service with the image
docker run --name my_sql_db -d -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --network clo835-a1-net  zjlianlee/clo835-a1-sql:1.0.0
```

## Docker Compose

Set the following environment variables as:

```bash
DBHOST=<PICK_AN_ADDRESS_FROM_SUBNET_RANGE> # most likely only need to change this
DBPWD=<YOUR_DB_PASSWORD>
MYSQL_ROOT_PASSWORD=<YOUR_DB_PASSWORD>
```

Run the following to compose, this will build using the current `Dockerfile` setup:

```bash
docker compose up -d --build # --build optional if you want to rebuild the images
```

If you want to compose using the images on the DockerHub, run the following:

```bash
docker compose up -d -f docker-compose-registry.yml
```
