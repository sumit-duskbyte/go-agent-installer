#!/bin/bash

TOKEN=$1
SERVER_URL=$2

if [ -z "$TOKEN" ] || [ -z "$SERVER_URL" ]; then
  echo "Error: Token or Server URL missing."
  echo "Usage: bash -s <AGENT_KEY> <SERVER_URL>"
  exit 1
fi


check_ports() {
  echo "Checking for required ports: 80 (HTTP), 443 (HTTPS), and 5432 (PostgreSQL) ..."
  local missing_ports=()

  for port in 80 443 5432; do
    if ss -tuln | awk '{print $5}' | grep -E -q ":$port$|:$port\$"; then
      echo "✅ Port $port is open."
    else
      echo "❌ Port $port is not open."
      missing_ports+=("$port")
      exit 1
    fi
  done

  if [ ${#missing_ports[@]} -gt 0 ]; then
    echo
    echo "Required ports not open: ${missing_ports[*]}"
    echo "Please make sure ports 80 (HTTP), 443 (HTTPS), and 5432 (PostgreSQL) are open before continuing."
  fi

  echo
}


check_docker() {
  echo "Checking if Docker is installed..."

  if command -v docker &> /dev/null; then
    echo "✅ Docker is installed."
  else
    echo "❌ Docker is not installed."
    echo "Please install Docker before proceeding."
    exit 1
  fi

  echo
}


check_ports

check_docker


echo "Downloading goAgent.deb package..."
curl -fsSL https://github.com/sumit-duskbyte/go-agent-installer/releases/download/v1.0.0/goAgent.deb -o goAgent.deb

echo "Installing go agent package"
sudo dpkg -i goAgent.deb

echo "Saving token and server URL to /etc/goAgent/config.yml"
sudo mkdir -p /etc/goAgent

# Write YAML config
echo -e "token: \"$TOKEN\"\nserver_url: \"$SERVER_URL\"" | sudo tee /etc/goAgent/config.yml > /dev/null

echo "Enabling and starting service"
sudo systemctl daemon-reload
sudo systemctl enable goAgent
sudo systemctl start goAgent

rm -f goAgent.deb

echo "Go Agent installed and running!"
