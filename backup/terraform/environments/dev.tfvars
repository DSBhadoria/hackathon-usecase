# Development Environment Variables
environment         = "dev"
location            = "eastus"
resource_group_name = "healthcare-rg"
acr_name            = "healthcareacr"
aks_cluster_name    = "healthcare-aks"
node_count          = 2
node_vm_size        = "Standard_B2s"  # Cheaper for dev

tags = {
  Environment = "dev"
  Project     = "Healthcare"
  ManagedBy   = "Terraform"
  CostCenter  = "Development"
}
