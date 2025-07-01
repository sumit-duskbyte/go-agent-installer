check_ports() {
  echo "Checking for required ports: 80 (HTTP), 443 (HTTPS), and 5432 (PostgreSQL) ..."
  local missing_ports=()

  for port in 80 443 5432; do
    if ss -tuln | awk '{print $5}' | grep -E -q ":$port$|:$port\$"; then
      echo "✅ Port $port is open."
    else
      echo "❌ Port $port is not open."
      missing_ports+=("$port")
    fi
  done

  if [ ${#missing_ports[@]} -gt 0 ]; then
    echo
    echo "Required ports not open: ${missing_ports[*]}"
    echo "Please make sure ports 80 (HTTP), 443 (HTTPS), and 5432 (PostgreSQL) are open before continuing."
    exit 1
    
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