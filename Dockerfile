# Because we intend to use this image on CircleCi, we want to use an image with a bit more components than buster
FROM golang:1.21

LABEL maintainer=det@travelaudience.com

# Fetch the cloudsql proxy
RUN mkdir /proxy &&\
    wget https://storage.googleapis.com/cloudsql-proxy/v1.18.0/cloud_sql_proxy.linux.amd64 -O /proxy/cloud_sql_proxy &&\
    chmod +x /proxy/cloud_sql_proxy &&\
    mkdir /cloudsql

# Fetch goose
RUN export GO111MODULE=on &&\
    go install github.com/pressly/goose/v3/cmd/goose@v3.15.0

RUN mkdir /db
WORKDIR /db

# Our execution script
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
COPY ./startup.sh /startup.sh

RUN  chmod +x /docker-entrypoint.sh &&\
    chmod +x /docker-entrypoint.sh /startup.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
