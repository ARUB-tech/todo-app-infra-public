terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.33.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "f5fde029-2c19-48dd-adbc-953ef3965338"
}