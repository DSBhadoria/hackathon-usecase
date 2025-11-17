# Terraform Infrastructure Setup

This directory contains Terraform code to provision Azure infrastructure for the Healthcare application.

## 📁 Structure

```
terraform/
├── main.tf                    # Provider and backend configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output values
├── resources.tf              # Azure resources (VNet, ACR, AKS)
└── environments/
    ├── dev.tfvars            # Development environment
    ├── staging.tfvars        # Staging environment
    └── prod.tfvars           # Production environment
```

## 🚀 Quick Start

### Prerequisites
- Azure CLI installed and authenticated
- Terraform >= 1.6.0 installed

### 1. Login to Azure
```bash
az login
```

### 2. Initialize Terraform
```bash
cd terraform
terraform init
```

### 3. Plan Infrastructure (Dev)
```bash
terraform plan -var-file="environments/dev.tfvars"
```

### 4. Apply Infrastructure (Dev)
```bash
terraform apply -var-file="environments/dev.tfvars"
```

## 📦 Resources Created

1. **Resource Group** - Container for all resources
2. **Virtual Network** - With public and private subnets
3. **Azure Container Registry (ACR)** - For Docker images
4. **Azure Kubernetes Service (AKS)** - Kubernetes cluster
5. **Role Assignment** - Allows AKS to pull from ACR

## 🔧 Configuration

### Environment Variables

Each environment has its own `.tfvars` file:

- **dev.tfvars** - 2 nodes, smaller VMs (cost-effective)
- **staging.tfvars** - 3 nodes, standard VMs
- **prod.tfvars** - 5 nodes, larger VMs (high availability)

### Customize Variables

Edit the `.tfvars` files to customize:
- `location` - Azure region
- `node_count` - Number of AKS nodes
- `node_vm_size` - VM size for nodes
- `tags` - Resource tags

## 🔐 Remote State Storage (Optional)

To enable remote state storage in Azure Blob Storage:

### 1. Create Storage Account
```bash
# Create resource group
az group create --name terraform-state-rg --location eastus

# Create storage account
az storage account create \
  --name tfstatehealthcare \
  --resource-group terraform-state-rg \
  --location eastus \
  --sku Standard_LRS

# Create container
az storage container create \
  --name tfstate \
  --account-name tfstatehealthcare
```

### 2. Uncomment Backend in main.tf
```hcl
backend "azurerm" {
  resource_group_name  = "terraform-state-rg"
  storage_account_name = "tfstatehealthcare"
  container_name       = "tfstate"
  key                  = "dev.tfstate"
}
```

### 3. Re-initialize
```bash
terraform init -migrate-state
```

## 📊 Outputs

After applying, get the outputs:

```bash
# View all outputs
terraform output

# Get specific output
terraform output acr_login_server
terraform output aks_cluster_name
```

## 🔄 GitHub Actions Integration

The Terraform workflow (`.github/workflows/terraform.yml`) will:

1. **On Pull Request**:
   - Run `terraform fmt -check`
   - Run `terraform validate`
   - Run `terraform plan` for all environments

2. **On Merge to Main**:
   - Run `terraform apply` for dev environment

### Required GitHub Secrets

Add these to GitHub Settings → Secrets:

```
AZURE_CREDENTIALS          - Service principal JSON
TF_STATE_STORAGE_ACCOUNT   - Storage account name
TF_STATE_CONTAINER         - Container name (tfstate)
```

## 🧪 Testing Locally

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Plan changes
terraform plan -var-file="environments/dev.tfvars"

# Show outputs
terraform output
```

## 🗑️ Cleanup

To destroy all resources:

```bash
terraform destroy -var-file="environments/dev.tfvars"
```

⚠️ **Warning**: This will delete all resources in the environment!

## 📝 Notes

- ACR names must be globally unique (adjust in `.tfvars`)
- AKS creation takes 5-10 minutes
- Costs vary by VM size and node count
- Use `Standard_B2s` for dev to save costs
