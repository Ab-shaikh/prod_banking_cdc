#!/bin/bash
set -e

# 1. Install Docker & Git
apt-get update -y
apt-get install -y docker.io docker-compose-v2 git unzip curl
usermod -aG docker ubuntu

# 2. Clone Repository (Yahan Apna Naya Repo URL Daalein)
cd /home/ubuntu
git clone https://github.com/Ab-shaikh/prod_banking_cdc.git cdc_project
chown -R ubuntu:ubuntu /home/ubuntu/cdc_project

# 3. Setup Kafka S3 Plugin
cd /home/ubuntu/cdc_project/data_streaming
mkdir -p connect-plugins/s3-sink && cd connect-plugins/s3-sink
curl -sL -o s3-sink.zip "https://api.hub.confluent.io/api/plugins/confluentinc/kafka-connect-s3/versions/10.5.7/archive"
unzip -q s3-sink.zip && mv confluentinc-kafka-connect-s3-*/lib/* . && rm -rf confluentinc-kafka-connect-s3-* s3-sink.zip

# 4. Start Data Streaming (Postgres + Kafka)
cd /home/ubuntu/cdc_project/data_streaming
sudo -u ubuntu sg docker -c "docker compose up -d"

# 5. Start Airflow Orchestration
cd /home/ubuntu/cdc_project/orchestration
echo "AIRFLOW_UID=50000" > .env
sudo -u ubuntu sg docker -c "docker compose build"
sudo -u ubuntu sg docker -c "docker compose up airflow-init"
sudo -u ubuntu sg docker -c "docker compose up -d"