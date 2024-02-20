#!/bin/bash

# Install latest Vault
LATEST=$(curl -s https://releases.hashicorp.com/vault/index.json | jq -r '.versions[0].version')
curl -o vault.zip https://releases.hashicorp.com/vault/$LATEST/vault_$LATEST_linux_amd64.zip
unzip vault.zip
sudo mv vault /usr/local/bin

# Initialize Vault dev server
vault server -dev -dev-root-token-id="myroot" -dev-listen-address="0.0.0.0:8200" &

# Check if Postgres is installed
if ! [ -x "$(command -v psql)" ]; then
  echo "Installing Postgres..."
  sudo apt install postgresql postgresql-contrib -y
fi

# Check if MySQL is installed
if ! [ -x "$(command -v mysql)" ]; then
  echo "Installing MySQL..." 
  sudo apt install mysql-server -y
fi

# Set up databases
sudo -u postgres psql -c "CREATE DATABASE myproject;"
mysql -u root -e "CREATE DATABASE myproject;"

# Set .env variables
echo "
DATABASE_URL=postgresql://postgres@localhost/myproject
MYSQL_URL=mysql://root@localhost/myproject
VAULT_ADDR=http://127.0.0.1:8200
VAULT_TOKEN=myroot
" > .env

echo "Done! Env file .env created."

