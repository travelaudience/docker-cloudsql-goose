# docker-cloudsql-goose
Docker image for running [goose ](https://github.com/pressly/goose) migrations on a cloudsql database

# Usage

## CircleCI

## Configuration (Local)

Parameters are passed as environment variables, so the image can easily be used from CircleCI (See below). For local development it is recommended to set up a `.env.local` file with the following contents:

```bash
# Contents of the service account json file. (put everything on 1 line. dot env files don't support multiline variables)
# https://cloud.google.com/iam/docs/creating-managing-service-account-keys
CLOUDSQL_PROXY_SA=SERVICE_ACCOUNT_SECRET_JSON
# The cloudsql instance you want to connect to
GCLOUD_SQL_INSTANCE=project:region:cloudsql_instance=tcp:localhost:port

# Goose & postgres connection configuration
POSTGRES_USER=postgres
POSTGRES_PASSWORD=XXXXXX
POSTGRES_PORT=5536
POSTGRES_DATABASE=goose_demo
GOOSE_DRIVER=postgres
```

## Build & Run (local)
```bash
# Build the image
docker build -t travelaudience/cloudsql-goose . 

# For local executions we mount the goose migration folder
docker run --rm -it --name goose \
    --env-file .env.local \
    --mount type=bind,source="$(pwd)"/db/migrations,target=/db/migrations \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    cloudsql-goose

# cd into the directory we mounted
cd migrations/
```

### Create a new sql migration

This might create the file as root on your host system
```bash
goose create sql
```

### Apply migrations

```bash
goose up
```

### Remove everything

```bash
goose reset
```
