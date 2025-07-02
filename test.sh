check_apache_ports() {
  echo "🔍 Checking if Apache2 is serving ports 80 and 443..."
  local apache_ports=(80 443)
  local apache_port_errors=()

  for port in "${apache_ports[@]}"; do
    if sudo ss -tulnp | awk -v p=":$port" '$1 ~ /LISTEN/ && $5 ~ p {print $5, $7}' | grep -q .; then
      echo "✅ Port $port is open."

      if ! sudo ss -tulnp | awk -v p=":$port" '$1 ~ /LISTEN/ && $5 ~ p' | grep -q "apache2"; then
        echo "❌ Port $port is NOT used by Apache2."
        apache_port_errors+=("$port")
      else
        echo "🔄 Port $port is correctly used by Apache2."
      fi
    else
      echo "❌ Port $port is not open."
      apache_port_errors+=("$port")
    fi
  done

  if [ ${#apache_port_errors[@]} -gt 0 ]; then
    echo
    echo "❌ Apache2 failed to use the following ports: ${apache_port_errors[*]}"
    echo "👉 Please make sure Apache is installed and listening on these ports."
    exit 1
  fi

  echo "✅ Apache2 is correctly serving ports 80 and 443."
  echo
}

check_apache_ports