# resource "azurerm_public_ip" "public_ip" {
#   name                = "public_ip_arub"
#   resource_group_name = "rg_arub"
#   location            = "centralindia"
#   allocation_method   = "Static"
# }
# Google search azurerm public ip
# ye hmne alag resource bna diya h
# resource "azurerm_public_ip" "pip" {
#   name                = "pip-todoappvm"
#   resource_group_name = "rg_arub"
#   location            = "centralindia"
#   allocation_method   = "Static"

#   tags = {
#     environment = "Production"
#   }
# }


# Google search terraform azurerm nic

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
     name                          = "internal"  #ye subnet id todovnet se liya hun 
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.vm_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
# HW- find how to use admin password instead of SSH key
#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("~/.ssh/id_rsa.pub")
#   } ye id and password se krna h

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher #publiched id from market place
    offer     = var.image_offer  # offer id from azure marketplace
    sku       = var.image_sku
    version   = var.image_version
  }
}