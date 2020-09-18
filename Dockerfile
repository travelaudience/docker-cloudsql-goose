# Because we intend to use this image on CircleCi, we want to use an image with a bit more components than buster
FROM golang:1.15

# Fetch the cloudsql proxy
RUN mkdir /proxy &&\
    wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O /proxy/cloud_sql_proxy &&\
    chmod +x /proxy/cloud_sql_proxy &&\
    mkdir /cloudsql

# Fetch goose
RUN go get -v -u github.com/pressly/goose/cmd/goose

# Our execution script
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN  chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]