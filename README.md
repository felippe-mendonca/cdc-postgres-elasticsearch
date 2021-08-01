
# cdc-postgres-elasticsearch

This repository shown an example of a Change Data Capture to sync data from Postgres to Elasticsearch using Kafka Connect.

## Running

Starting all components running the `docker-compose` command below:

```shell
docker-compose up --remove-orphans --force-recreate --build
```

Check if all components are up and running. If so, fetch sample data and use `psql` to ingest it on Postgres.

```shell
./download-demo-db.sh
PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres < demo-small-en-20170815.sql
```

Now let's configure the first Connector responsible to capture all changes on Postgres server:

```shell
curl -X POST -H "content-type: application/json" -d @connector-postgres-source.json http://localhost:8083/connectors
```

Access Confluent Control Center on http://localhost:9021. You'll be able to see on Topics section a new topic named `dev.bookings.flights`. In order to stream data from that topic to an ElasticSearch index, let's configure [ElasticSearch Sink Connector](https://docs.confluent.io/kafka-connect-elasticsearch/current/index.html):

```shell
curl -X POST -H "content-type: application/json" -d @connector-elasticsearch-sink-bookings-flights.json http://localhost:8083/connectors
```

By now, we have all components configure to ensure that any change on Postgres will reflect on ElasticSearch. First of all, verify how many rows we have on `flights` table.

```
PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres -d demo -c "select count(1) from flights;"
```
If everything went well, we'll have same number of documents on ElasticSearch:

```shell
curl http://localhost:9200/dev.bookings.flights/_count
```

Run a search command to see some documents:

```shell
curl http://localhost:9200/dev.bookings.flights/_search
```

Check document with index `1`:

```shell
curl http://localhost:9200/dev.bookings.flights/_doc/1
```

Now we'll finally see the magic happens! Let's update the row with index `1`. Pay attention on the document on ElasticSearch before run the command below:

```
PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres -d demo < 0-update-flight.sql
```

Run the previous `curl` again to see the change. Finally, let's remove the same row we've changed:

```
PGPASSWORD=postgres psql -h 127.0.0.1 -U postgres -d demo < 1-remove-flight.sql
```

If you try to find the document with index `1` on ElasticSearch, hopefully it'll not be there!