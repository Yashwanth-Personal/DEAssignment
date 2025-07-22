-- PostgreSQL table for storing CDR data from Kafka for my assignment

CREATE TABLE IF NOT EXISTS cdr_records (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    type VARCHAR(20),
    status VARCHAR(20),
    event_time TIMESTAMP,
    ingestion_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Kafka Connect JDBC Sink properties (sink-config.properties) configured with 3 parallel flows

# Kafka Connect JDBC Sink configuration
name=postgres-sink-connector
connector.class=io.confluent.connect.jdbc.JdbcSinkConnector
tasks.max=3

connection.url=jdbc:postgresql://postgres:5432/cdr_db
connection.user=admin
connection.password=admin

topics=cdr_data_topic

insert.mode=insert
auto.create=false
auto.evolve=true

key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=org.apache.kafka.connect.json.JsonConverter
value.converter.schemas.enable=false

batch.size=5000
max.retries=10
retry.backoff.ms=1000

transforms=InsertTS
transforms.InsertTS.type=org.apache.kafka.connect.transforms.InsertField$Value
transforms.InsertTS.timestamp.field=ingestion_time
