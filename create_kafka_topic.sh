#!/bin/bash

# Kafka CLI script to create high-throughput topic for my Assignment

KAFKA_BIN=/opt/bitnami/kafka/bin
BROKER=kafka:9092

echo "Creating topic 'cdr_data_topic' with 12 partitions, lz4 compression, 7-day retention..."

$KAFKA_BIN/kafka-topics.sh \
  --create \
  --topic cdr_data_topic \
  --partitions 12 \
  --replication-factor 2 \
  --bootstrap-server $BROKER \
  --config compression.type=lz4 \
  --config retention.ms=604800000 \
  --config segment.bytes=1073741824 \
  --config max.message.bytes=5242880

$KAFKA_BIN/kafka-topics.sh --describe --topic cdr_data_topic --bootstrap-server $BROKER
