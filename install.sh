#!/bin/bash

TOKEN=$1
SERVER_URL=$2

if [ -z "$TOKEN" ] || [ -z "$SERVER_URL" ]; then
  echo "Error: Token or Server URL missing."
  echo "Usage: bash -s <AGENT_KEY> <SERVER_URL>"
  exit 1
fi

echo "Downloading goAgent_1.0.0_amd64.deb package..."
curl -fsSL https://github.com/sumit-duskbyte/go-agent-installer/releases/download/v1.0.0/goAgent_1.0.0_amd64.deb -o goAgent_1.0.0_amd64.deb


echo "Installing go agent package"
sudo dpkg -i goAgent_1.0.0_amd64.deb


echo "Saving token and server URL to /etc/goAgent/config.yml"
sudo mkdir -p /etc/goAgent

# Write YAML config
echo -e "token: \"$TOKEN\"\nserver_url: \"$SERVER_URL\"" | sudo tee /etc/goAgent/config.yml > /dev/null

echo "Enabling and starting service"
sudo systemctl daemon-reload
sudo systemctl enable goAgent
sudo systemctl start goAgent

rm -f goAgent_1.0.0_amd64.deb


echo "Go Agent installed and running!"
