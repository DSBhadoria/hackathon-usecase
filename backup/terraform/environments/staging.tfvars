# Staging Environment Variables
environment         = "staging"
location            = "eastus"
resource_group_name = "healthcare-rg"
acr_name            = "healthcareacr"
aks_cluster_name    = "healthcare-aks"
node_count          = 3
node_vm_size        = "Standard_D2s_v3"

tags = {
  Environment = "staging"
  Project     = "Healthcare"
  ManagedBy   = "Terraform"
  CostCenter  = "Staging"
}
