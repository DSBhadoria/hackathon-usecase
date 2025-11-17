# Production Environment Variables
environment         = "prod"
location            = "eastus"
resource_group_name = "healthcare-rg"
acr_name            = "healthcareacr"
aks_cluster_name    = "healthcare-aks"
node_count          = 5
node_vm_size        = "Standard_D4s_v3"

tags = {
  Environment = "prod"
  Project     = "Healthcare"
  ManagedBy   = "Terraform"
  CostCenter  = "Production"
}
