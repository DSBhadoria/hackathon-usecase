# Healthcare Application - DevOps Hackathon

## Project Structure

This healthcare application consists of three microservices:

### 1. **Patient Service** (Node.js)
- Port: 3000
- Endpoints: `/health`, `/patients`, `/patients/:id`
- Technology: Express.js

### 2. **Application Service** (Node.js - Appointment Service)
- Port: 3001
- Endpoints: `/health`, `/appointments`, `/appointments/:id`, `/appointments/patient/:patientId`
- Technology: Express.js

### 3. **Order Service** (Java Spring Boot)
- Port: 8080
- Endpoints: `/actuator/health`, `/orders/*`
- Technology: Spring Boot, JPA, H2 Database

## Quick Start

### Prerequisites
- Docker and Docker Compose
- Node.js 18+ (for local development)
- Java 17+ and Maven (for local development)
- kubectl (for Kubernetes deployment)
- Azure CLI (for ACR/AKS deployment)

### Local Development with Docker Compose

```bash
# Build and run all services
docker-compose up --build

# Run in detached mode
docker-compose up -d

# Stop all services
docker-compose down
```

**Service URLs:**
- Patient Service: http://localhost:3000
- Application Service: http://localhost:3001
- Order Service: http://localhost:8080

### Build Individual Docker Images

```bash
# Patient Service
cd patient-service
docker build -t patient-service:latest .

# Application Service
cd application-service
docker build -t application-service:latest .

# Order Service
cd order-service
docker build -t order-service:latest .
```

## CI/CD Pipeline

### GitHub Actions Workflow

The `.github/workflows/github-action.yml` file contains a complete CI/CD pipeline that:

1. **Builds all three microservices** using a matrix strategy
2. **Pushes images to Azure Container Registry (ACR)**
3. **Scans images for vulnerabilities** using Trivy
4. **Supports multiple tagging strategies**: commit SHA, branch name, PR number, semver
5. **Implements Docker layer caching** for faster builds

### Required GitHub Secrets

Configure these secrets in your GitHub repository:

- `AZURE_CREDENTIALS`: Azure service principal credentials
- `ACR_USERNAME`: Azure Container Registry username
- `ACR_PASSWORD`: Azure Container Registry password

### Environment Variables

Update in `.github/workflows/github-action.yml`:
- `AZURE_CONTAINER_REGISTRY`: Your ACR name (e.g., `myhealthcareacr.azurecr.io`)

## Kubernetes Deployment

### Deploy to AKS/GKE

```bash
# Apply all Kubernetes manifests
kubectl apply -f k8s/

# Or using Kustomize
kubectl apply -k k8s/

# Check deployment status
kubectl get pods -n healthcare-app
kubectl get services -n healthcare-app
kubectl get ingress -n healthcare-app

# View logs
kubectl logs -f deployment/patient-service -n healthcare-app
kubectl logs -f deployment/application-service -n healthcare-app
kubectl logs -f deployment/order-service -n healthcare-app
```

### Update Image Tags

Edit `k8s/kustomization.yaml` to update image tags:

```yaml
images:
  - name: myacrname.azurecr.io/patient-service
    newTag: abc123  # Your commit SHA or version
```

### Horizontal Pod Autoscaling

All services include HPA configurations:
- Min replicas: 2
- Max replicas: 10
- Target CPU: 70%
- Target Memory: 80%

## Kubernetes Resources

The `k8s/` directory contains:

- `deployment.yaml`: Deployments, Services, ConfigMaps, Ingress
- `hpa.yaml`: HorizontalPodAutoscaler for all services
- `kustomization.yaml`: Kustomize configuration

## Testing Endpoints

### Patient Service
```bash
# Health check
curl http://localhost:3000/health

# Get all patients
curl http://localhost:3000/patients

# Get patient by ID
curl http://localhost:3000/patients/1

# Create patient
curl -X POST http://localhost:3000/patients \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Patient","age":35,"condition":"Healthy"}'
```

### Application Service (Appointments)
```bash
# Health check
curl http://localhost:3001/health

# Get all appointments
curl http://localhost:3001/appointments

# Get appointments by patient ID
curl http://localhost:3001/appointments/patient/1
```

### Order Service
```bash
# Health check
curl http://localhost:8080/actuator/health

# Get orders
curl http://localhost:8080/orders
```

## Monitoring and Logging

### Azure Monitor Setup (AKS)
- Enable Container Insights on AKS cluster
- View logs in Log Analytics workspace
- Set up alerts for pod failures and resource usage

### GCP Monitoring Setup (GKE)
- Enable Cloud Monitoring and Cloud Logging
- View logs in Cloud Console
- Set up uptime checks and alerts

## Infrastructure as Code (Terraform)

(To be implemented - see main README.md for requirements)

## Troubleshooting

### Docker Build Issues
```bash
# Clean Docker cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

### Kubernetes Pod Issues
```bash
# Describe pod
kubectl describe pod <pod-name> -n healthcare-app

# Check events
kubectl get events -n healthcare-app --sort-by='.lastTimestamp'

# Check resource usage
kubectl top pods -n healthcare-app
```

## Security Best Practices

✅ Multi-stage Docker builds
✅ Non-root user in containers
✅ Vulnerability scanning with Trivy
✅ Resource limits in Kubernetes
✅ Health checks and readiness probes
✅ .dockerignore files to exclude sensitive data

## License

MIT
