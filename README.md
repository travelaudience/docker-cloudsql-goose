# docker-cloudsql-goose
Docker image for running goose transactions on a cloudsql database

# Usage

## Local

Parameters are passed as environment variables, so the image can easily be used from CircleCI (See below). For local development it is recommended to set up a `.env.local` file with the following contents:

```bash
# Contents of the service account json file. (put everything on 1 line!)
# https://cloud.google.com/iam/docs/creating-managing-service-account-keys#iam-service-account-keys-list-gcloud
CLOUDSQL_PROXY_SA='{ XXXXXXXXX }'
# The cloudsql instance you want to connect to
GCLOUD_SQL_INSTANCE="project:region:cloudsql_instance=tcp:0.0.0.0:port"
```

### Build & Run
```bash
# Build the image
docker build -t cloudsql-goose . 
# The service account is passed as environment variable, so it can be easily be passed from CircleCI (See below)
docker run --rm --env-file .env.local --name goose cloudsql-goose
```

Or to run bash inside the container:
```bash
docker run -it --rm --env-file .env.local --name goose --entrypoint bash cloudsql-goose 
```

## CircleCI