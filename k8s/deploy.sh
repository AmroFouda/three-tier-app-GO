#!/bin/bash

# Kubernetes deployment script for project1

echo "Deploying project1 to Kubernetes..."

# Check if secrets are configured
if grep -q "<BASE64_ENCODED_PASSWORD>" db-secret.yaml; then
    echo "ERROR: Please configure your passwords in db-secret.yaml before deploying!"
    echo "Replace <BASE64_ENCODED_PASSWORD> and <BASE64_ENCODED_ROOT_PASSWORD> with your base64 encoded passwords."
    echo "To encode: echo -n 'your-password' | base64"
    exit 1
fi

# Apply secrets first
echo "Creating secrets..."
kubectl apply -f db-secret.yaml

# Apply persistent volumes
echo "Creating persistent volumes..."
kubectl apply -f db-data-pv.yaml
kubectl apply -f db-data-pvc.yaml

# Deploy database
echo "Deploying database..."
kubectl apply -f db-deployment.yaml
kubectl apply -f db-service.yaml

# Wait for database to be ready
echo "Waiting for database to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/db-deployment

# Deploy backend
echo "Deploying backend..."
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml

# Wait for backend to be ready
echo "Waiting for backend to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/backend-deployment

# Deploy proxy
echo "Deploying proxy..."
kubectl apply -f proxy-deployment.yaml
kubectl apply -f proxy-nodeport.yaml

# Wait for proxy to be ready
echo "Waiting for proxy to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/proxy-deployment

echo "Deployment complete!"
echo ""
echo "Access the application at:"
echo "  HTTPS: https://localhost:30443"
echo "  HTTP:  http://localhost:30080"
echo ""
echo "To check status:"
echo "  kubectl get pods"
echo "  kubectl get services"