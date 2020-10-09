#!/usr/bin/env bash

if [[ -z "${CLOUDSQL_PROXY_SA}" ]]; then
    echo "'CLOUDSQL_PROXY_SA' environment variable not defined. Place the contents of the service account json in this environment variable" 1>&2
    exit 1
else
    # Replace \\n with an actual newline, for .env file compatibility
    echo "${CLOUDSQL_PROXY_SA}" > /tmp/sa.json
fi

if [[ -z "${GCLOUD_SQL_INSTANCE}" ]]; then
    echo "'GCLOUD_SQL_INSTANCE' environment variable not defined. Specify the cloudsql instance in this environment variable" 1>&2
    exit 1
fi

export GOOSE_DBSTRING=postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@localhost:${POSTGRES_PORT}/${POSTGRES_DATABASE}?sslmode=disable

echo "Starting the cloudsql proxy"
touch /tmp/cloudsql.log
exec /proxy/cloud_sql_proxy -dir=/cloudsql -instances="$GCLOUD_SQL_INSTANCE" -credential_file=/tmp/sa.json > /tmp/cloudsql.log 2>&1 &

# Set true in the shared memory
# Check whether the ready message was received
echo "1" >/dev/shm/cloudsql_ready

# Wait for the cloudsql connection to go up
echo "Waiting for ready message from cloudsql proxy..."

# The tail grep command will get stuck if no ready message arrives, so we set a timer to kill it
# Even if the grep terminates naturally, the tail is running in the background so it needs to be killed
delayTailKill() {
    sleep 10
    # When killing the tail, set the shared memory to zero
    echo "0" >/dev/shm/cloudsql_ready
    pkill -s 0 tail
}
delayTailKill &>/dev/null &

( tail -f -n +1 /tmp/cloudsql.log & ) | grep -q "Ready for new connections"

# Remove SA json from the tmp folder
# Nobody should have access either way, but just to check
rm /tmp/sa.json
# Print the log for debug purposes
tail -n +1 /tmp/cloudsql.log

# Read from shared memory to see if the tail was killed or the ready message arrived
if (( "$(</dev/shm/cloudsql_ready)" != "1" ));
then
  echo "Waiting for cloudsql connection timed out. Exitting."
  # Dump the log so you can see what went wrong
  cat /tmp/cloudsql.log
  exit 1
else
    echo "Cloudsql proxy ready"
fi
