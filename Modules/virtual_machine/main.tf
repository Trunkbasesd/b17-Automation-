resource "azurerm_network_interface" "nic" {
  name = var.nic_name
  location = var.location 
  resource_group_name = var.resource_group_name

  ip_configuration {
    name = "internal"
    subnet_id = var.subnet_id  # is step se subnet se nic or nic se subnet connect kr diya .
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip_address_id  # is step se public ip ko nic ce or nic ko public ip se connect kr diya .
  }
}

# NIC card ko public ip se aur vnet/subnet se bhi connect krana hai 

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.size
  admin_username      = var.admin_username
  admin_password = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id,  # here we have pass nic id in it and connect our vm to nic or nic to vm 
  ]                                    # Implicit dependency se andar hi andar assign ho gaya nic block se .

  # admin_ssh_key {
  #   username   = "adminuser"
  #   public_key = file("~/.ssh/id_rsa.pub")
  # }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}