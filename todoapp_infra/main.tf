module "resource_group" {
  source = "../Modules/azurerm_resource_group"
  resource_group_name= "rg-todoapp"
  resource_group_location = "centralindia"

  
}
#ek story kr rha hun chek krne ke liye 
module "virtual_network" {
    depends_on = [ module.resource_group ]
    source = "../Modules/azurerm_virtual_network"
virtual_network_name = "vnet-todoapp"
virtual_network_location = "centralindia"
resource_group_name = "rg-todoapp"
address_space = ["10.0.0.0/16"]
  
}
module "frontend_subnet" {
    depends_on = [module.virtual_network]
    source = "../Modules/azurerm_subnet"
    resource_group_name = "rg-todoapp"
    virtual_network_name = "vnet-todoapp"
    subnet_name = "frontend-subnet"
    address_prefixes = ["10.0.1.0/24"]
  
}
module "backend_subnet" {
    depends_on = [module.virtual_network ]
    source = "../Modules/azurerm_subnet"
    resource_group_name = "rg-todoapp"
    virtual_network_name = "vnet-todoapp"
    subnet_name = "backend-subnet"
    address_prefixes = ["10.0.2.0/24"]
  
}
module "public_ip_name" {
    source = "../Modules/azurerm_pulic-ip"
    public_ip_name = "pip-todoapp"
    resource_group_name = "rg-todoapp"
    location = "centralindia"
    allocation_method = "Static"
  
}


module "frontend_vm" {
    depends_on = [ module.frontend_subnet ]
    source = "../Modules/azurerm_virtual _machine"
    resource_group_name = "rg-todoapp"
    location = "centralindia"
    vm_name = "vm-frontend"
    nic_name = "nic-vm-frontend"
    subnet_id = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-todoapp/providers/Microsoft.Network/virtualNetworks/vnet-todoapp/subnets/frontend-subnet"
    vm_location = "centralindia"
    vm_size = "Standard_B1s"
    admin_username = "devopsadmin"
    admin_password = "P@ssord123"
    image_publisher = "Canonical"
    image_offer = "UbuntuServer"
    image_sku = "18.04-LTS"
    image_version = "Latest"
    
 
}
# module "backend_vm" {
#     depends_on = [ module.backend_subnet ]
#     source = "../Modules/azurerm_virtual _machine"
#     resource_group_name = "rg-todoapp"
#     location = "centralindia"
#     vm_name = "vm-backend"
#     nic_name = "nic-vm-backend"
#     subnet_id = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-todoapp/providers/Microsoft.Network/virtualNetworks/vnet-todoapp/subnets/backend-subnet"
#     vm_location = "centralindia"
#     vm_size = "Standard_B1s"
#     admin_username = "devopsadmin"
#     admin_password = "P@ssord123"
#     image_publisher = "Canonical"
#     image_offer =  "0001-com-ubuntu-server-focal"
#     image_sku = "20_04-lts"
#     image_version = "Latest"
    
 
# }
module "sql_server" {
    source = "../Modules/azurerm_sql_server"
    sql_server_name = "sqlserver-todoapp123"
    resource_group_name = "rg-todoapp"
    location = "centralindia"
    administrator_login = "Sqladmin"
    administrator_login_password = "Sql@1996"
  
}

module "sql_database" {
    depends_on = [ module.sql_server ]
    source = "../Modules/azurerm_sql_database"
    sql_database_name = "sql-dbase-todo"
    sql_database_id = "/subscriptions/f5fde029-2c19-48dd-adbc-953ef3965338/resourceGroups/rg-todoapp/providers/Microsoft.Sql/servers/sqlserver-todoapp123"

  
}