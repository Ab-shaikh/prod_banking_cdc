#!/bin/bash
set -e

# ==========================================
# 1. Install Docker, Git & AWS CLI
# ==========================================
apt-get update -y
apt-get install -y docker.io docker-compose-v2 git unzip curl
usermod -aG docker ubuntu

# AWS CLI Installation
echo "Installing AWS CLI..."
curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
./aws/install
rm -rf awscliv2.zip aws
echo "AWS CLI installed successfully!"

# ==========================================
# 2. Clone Repository & Setup Git
# ==========================================
cd /home/ubuntu
git clone https://github.com/Ab-shaikh/prod_banking_cdc.git cdc_project
chown -R ubuntu:ubuntu /home/ubuntu/cdc_project

# Configure Git Identity
sudo -u ubuntu git config --global user.name "Ab-shaikh"
sudo -u ubuntu git config --global user.email "shaikhabubakar059@gmail.com"

# ==========================================
# 3. Setup Kafka S3 Plugin
# ==========================================
cd /home/ubuntu/cdc_project/data_streaming
mkdir -p connect-plugins/s3-sink && cd connect-plugins/s3-sink
curl -sL -o s3-sink.zip "https://api.hub.confluent.io/api/plugins/confluentinc/kafka-connect-s3/versions/10.5.7/archive"
unzip -q s3-sink.zip && mv confluentinc-kafka-connect-s3-*/lib/* . && rm -rf confluentinc-kafka-connect-s3-* s3-sink.zip
chown -R ubuntu:ubuntu /home/ubuntu/cdc_project/data_streaming/connect-plugins

# ==========================================
# 4. Start Data Streaming (Postgres + Kafka)
# ==========================================
cd /home/ubuntu/cdc_project/data_streaming
sudo -u ubuntu sg docker -c "docker compose up -d"

# Airflow start hone se pehle thoda wait karein taaki network set ho jaye
sleep 15

# ==========================================
# 5. Generate .env File dynamically (SECRETS)
# ==========================================
cd /home/ubuntu/cdc_project/orchestration

cat <<EOF > .env
AIRFLOW_UID=50000
SNOWFLAKE_ACCOUNT="${sf_acc}"
SNOWFLAKE_USER="${sf_user}"
SNOWFLAKE_PASSWORD="${sf_pass}"
EOF

chown ubuntu:ubuntu .env

# ==========================================
# 6. Start Airflow Orchestration
# ==========================================
sudo -u ubuntu sg docker -c "docker compose build"
sudo -u ubuntu sg docker -c "docker compose up airflow-init"
sudo -u ubuntu sg docker -c "docker compose up -d"

echo "Setup Complete! Enjoy the Data Pipeline."