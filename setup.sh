#!/bin/bash

# Setup script for three-tier-app-GO

echo "Setting up three-tier-app-GO..."

# Check if example files exist
if [ ! -f "db-password.txt.example" ]; then
    echo "ERROR: db-password.txt.example not found!"
    exit 1
fi

if [ ! -f ".env.example" ]; then
    echo "ERROR: .env.example not found!"
    exit 1
fi

# Copy example files if they don't exist
if [ ! -f "db-password.txt" ]; then
    echo "Creating db-password.txt from example..."
    cp db-password.txt.example db-password.txt
    echo "Please edit db-password.txt with your secure password!"
fi

if [ ! -f ".env" ]; then
    echo "Creating .env from example..."
    cp .env.example .env
    echo "Please edit .env with your configuration!"
fi

# Generate SSL certificates
echo "Generating SSL certificates..."
cd nginx
if [ ! -f "generate-ssl.sh" ]; then
    echo "ERROR: generate-ssl.sh not found in nginx directory!"
    exit 1
fi

chmod +x generate-ssl.sh
./generate-ssl.sh
cd ..

echo ""
echo "Setup complete! Next steps:"
echo "1. Edit db-password.txt with a secure password"
echo "2. Edit .env with your configuration"
echo "3. For Kubernetes: Update k8s/db-secret.yaml with base64 encoded passwords"
echo "4. Run: docker compose up -d"
echo ""
echo "IMPORTANT: Never commit db-password.txt or .env to version control!"