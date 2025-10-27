# Three-Tier Application with Go Backend

A complete three-tier web application built with Go backend, MySQL database, and Nginx proxy with SSL support.

## Architecture

- **Frontend/Proxy**: Nginx with SSL termination
- **Backend**: Go application with REST API
- **Database**: MySQL 8.0 with persistent storage

## Prerequisites

- Docker and Docker Compose
- Kubernetes cluster (for K8s deployment)
- Git

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/AmroFouda/three-tier-app-GO.git
cd three-tier-app-GO
```

### 2. Setup Secrets (IMPORTANT)
```bash
# Copy example files
cp db-password.txt.example db-password.txt
cp .env.example .env

# Edit the files with your secure passwords
nano db-password.txt  # Add your database password
nano .env             # Configure environment variables
```

### 3. Generate SSL Certificates
```bash
cd nginx
chmod +x generate-ssl.sh
./generate-ssl.sh
cd ..
```

### 4. Deploy with Docker Compose
```bash
docker compose up -d
```

### 5. Access the Application
- **HTTPS**: https://localhost:8443
- **HTTP Backend**: http://localhost:8000

## Kubernetes Deployment

See the [k8s/README.md](k8s/README.md) for Kubernetes deployment instructions.

## Project Structure

```
├── backend/                 # Go application source
├── nginx/                   # Nginx configuration and SSL
├── k8s/                     # Kubernetes manifests
├── docker-compose.yml       # Docker Compose configuration
├── docker-compose.template.yml  # Template without secrets
└── README.md               # This file
```

## Security Notes

- **Never commit secrets**: Use `.env` files and `db-password.txt` for local development
- **SSL Certificates**: Generate your own certificates for production
- **Database Passwords**: Use strong, unique passwords
- **Environment Variables**: Use environment-specific configurations

## Development

### Backend Development
```bash
cd backend
go mod tidy
go run main.go
```

### Database Access
```bash
docker compose exec db mysql -u bloguser -p blog
```

### View Logs
```bash
docker compose logs -f backend
docker compose logs -f proxy
docker compose logs -f db
```

## Production Deployment

1. Use proper SSL certificates (not self-signed)
2. Configure proper database credentials
3. Set up monitoring and logging
4. Use secrets management (Kubernetes secrets, Docker secrets, etc.)
5. Configure proper backup strategies

## Troubleshooting

### Common Issues

1. **502 Bad Gateway**: Backend not ready, check backend logs
2. **Database Connection**: Verify credentials and network connectivity
3. **SSL Issues**: Regenerate certificates or check certificate paths

### Health Checks
- Backend: `curl http://localhost:8000/health`
- Database: `docker compose exec db mysqladmin ping`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## This Project DONE by Amr Fouda
