# The configuration for the `remote` backend.
terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "terraform-dbhadoria"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "example-workspace"
    }
  }
}

# Create a random name for the resource group using random_pet
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

# Create a resource group using the generated random name
resource "azurerm_resource_group" "rg_azure" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "azurerm_network_security_group" "nat" {
  name                = "example-security-group"
  location            = azurerm_resource_group.rg_azure.location
  resource_group_name = azurerm_resource_group.rg_azure.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "example-network"
  location            = azurerm_resource_group.rg_azure.location
  resource_group_name = azurerm_resource_group.rg_azure.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "public-subnet"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "private-subnet"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.nat.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "aks-cluster"
  location            = azurerm_resource_group.rg_azure.location
  resource_group_name = azurerm_resource_group.rg_azure.name
  dns_prefix          = "aksckuster"

  sku_tier = "Free"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DC1s_v3"
  }

  network_profile {
    network_plugin = "kubenet"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_role_assignment" "aks_acr_pull" {
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_resource_group.rg_azure.id
  # scope                = azurerm_container_registry.acr.id
}
