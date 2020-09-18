# docker-cloudsql-goose
Docker image for running goose transactions on a cloudsql database

# Usage


## Configuration (Local)

Parameters are passed as environment variables, so the image can easily be used from CircleCI (See below). For local development it is recommended to set up a `.env.local` file with the following contents:

```bash
# Contents of the service account json file. (put everything on 1 line!)
# https://cloud.google.com/iam/docs/creating-managing-service-account-keys
CLOUDSQL_PROXY_SA={ XXXXXXXXX }
# The cloudsql instance you want to connect to
GCLOUD_SQL_INSTANCE=project:region:cloudsql_instance=tcp:localhost:port

# Goose connection configuration
GOOSE_DRIVER=postgres
GOOSE_DBSTRING=postgres://postgres:postgres@localhost:port/external_platforms?sslmode=disable
```

## Build & Run (local)
```bash
# Build the image
docker build -t cloudsql-goose . 

# For local executions we mount the goose migration folder
docker run --rm -it --env-file .env.local --mount type=bind,source="$(pwd)"/db/migrations,target=/db/migrations --name goose cloudsql-goose

# cd into the directory we mounted
cd migrations/
```

### Create a sql migration

```bash
goose create sql
```

### Apply migrations

```bash
goose up
```


Or to run bash inside the container:
```bash
docker run -it --rm --env-file .env.local --name goose --entrypoint bash cloudsql-goose 
```

## CircleCI