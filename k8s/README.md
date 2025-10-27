# Kubernetes Deployment for Project1

This directory contains Kubernetes manifests to deploy the project1 application.

## Prerequisites

1. Kubernetes cluster running (minikube, kind, or any K8s cluster)
2. kubectl configured to connect to your cluster
3. Docker images built and available in your cluster:
   - `project1-backend:latest`
   - `project1-proxy:latest`

## Security Setup (IMPORTANT)

Before deploying, you must configure the secrets:

1. **Update db-secret.yaml**:
   ```bash
   # Generate base64 encoded passwords
   echo -n "your-secure-password" | base64
   echo -n "your-root-password" | base64
   
   # Edit db-secret.yaml and replace placeholders with your encoded passwords
   nano db-secret.yaml
   ```

2. **Never commit real secrets to version control**

## Building Images for Kubernetes

If using minikube, load the Docker images:
```bash
# Build images first (from project root)
docker compose build

# Load images into minikube
minikube image load project1-backend:latest
minikube image load project1-proxy:latest
```

## Deployment

### Option 1: Use the deployment script
```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 2: Manual deployment
```bash
# Deploy in order
kubectl apply -f db-secret.yaml
kubectl apply -f db-data-pv.yaml
kubectl apply -f db-data-pvc.yaml
kubectl apply -f db-deployment.yaml
kubectl apply -f db-service.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f proxy-deployment.yaml
kubectl apply -f proxy-nodeport.yaml
```

## Access the Application

- **HTTPS**: https://localhost:30443 (or your cluster IP:30443)
- **HTTP**: http://localhost:30080 (or your cluster IP:30080)

If using minikube:
```bash
minikube service proxy-nodeport --url
```

## Monitoring

Check deployment status:
```bash
kubectl get pods
kubectl get services
kubectl get pv,pvc
```

View logs:
```bash
kubectl logs -l app=backend
kubectl logs -l app=proxy
kubectl logs -l app=db
```

## Cleanup

Remove all resources:
```bash
kubectl delete -f .
```

## Files Description

- `db-secret.yaml`: Contains database passwords (base64 encoded)
- `db-data-pv.yaml`: Persistent Volume for MySQL data
- `db-data-pvc.yaml`: Persistent Volume Claim for MySQL data
- `db-deployment.yaml`: MySQL database deployment
- `db-service.yaml`: MySQL service (ClusterIP)
- `backend-deployment.yaml`: Go backend application deployment
- `backend-service.yaml`: Backend service (ClusterIP)
- `proxy-deployment.yaml`: Nginx proxy deployment
- `proxy-nodeport.yaml`: Nginx proxy service (NodePort for external access)

## Notes

- The database uses a PersistentVolume to store data
- Backend has 2 replicas for high availability
- Proxy is exposed via NodePort on ports 30443 (HTTPS) and 30080 (HTTP)
- Health checks are configured for all services
- Init container ensures database is ready before backend starts