# Commands used in this assignment

Series of command used throughout this assignment mainly for local setup (not prod friendly)

## Setup

### Setting up env vars

From root: `source scripts/export-env-vars`

Note: Need to use `source` instead of `sh` here to actually set the environment in the terminal environment

### Building the images

SQL Server

```bash
docker build -t my_db -f Dockerfile_mysql .
```

### Creating the Docker network bridge

```bash
# We use 172.17.0.0/16 based on the README instructions
docker network create --driver bridge --subnet 172.17.0.0/16" clo835-a1-net
```

---

Web App

> [!NOTE]
> Ensure that werkzeug is part of the pip dependencies requirement (2.0.3 to match Flask version)

```bash
docker build -t my_app -f Dockerfile .
```

## Running the applications

Ensure the SQL server is running first:

```bash
docker run --name my_sql_db -d -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --network clo835-a1-net  my_db
```

Get the IP of the database and export it as `DBHOST` variable (may need to run the shell script again)

```bash
docker inspect my_sql_db
```

---

Running the web app

- Make sure the port mapping `<machine-port>:8080` and env var `APP_COLOR` is changed for each of the container instance

```bash
docker run -p 8080:8080 --network clo835-a1-net  -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD  my_app
```

## Building, Tagging, Pushing and Pulling:

### Build and Tag:

Web App

```bash
# Build first (from build step)
docker build -t my_app -f Dockerfile .

# Tag the image
docker tag my_app "zjlianlee/clo835-a1-web-app:1.0.0" # or other semver tag version or latest

# Pushing the image
docker push "zjlianlee/clo835-a1-web-app:1.0.0" # use the correct tag version

# Pulling the image (pull only)
docker pull "zjlianlee/clo835-a1-web-app:1.0.0" # make sure to use correct tag
```

SQL Server

```bash
# Build first (from build step)
docker build -t my_db -f Dockerfile_mysql .

# Tag the image
docker tag my_db "zjlianlee/clo835-a1-sql:1.0.0" # or other semver tag version or latest

# Pushing the image
docker push "zjlianlee/clo835-a1-sql:1.0.0" # use the correct tag version

# Pulling the image (pull only)
docker pull "zjlianlee/clo835-a1-sql:1.0.0" # make sure to use correct tag
```
