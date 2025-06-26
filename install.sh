#!/bin/bash

TOKEN=$1

if [ -z "$TOKEN" ]; then
  echo "Error: Token missing. Usage: bash -s <YOUR_TOKEN>"
  exit 1
fi

echo "Saving token to /etc/goAgent/config.json"
sudo mkdir -p /etc/goAgent
echo "\"token\": \"$TOKEN\"" | sudo tee /etc/goAgent/config.json > /dev/null

echo "Downloading goAgent.deb package"
curl -fsSL https://github.com/sumit-duskbyte/go-agent-installer/releases/download/v1.0.0/goAgent.deb -o goAgent.deb

echo "Installing package"
sudo dpkg -i goAgent.deb

echo "Enabling and starting service"
sudo systemctl daemon-reload
sudo systemctl enable goAgent
sudo systemctl start goAgent

rm -f goAgent.deb

echo "Go Agent installed and running!"
