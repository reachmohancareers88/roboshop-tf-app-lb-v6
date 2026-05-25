resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "${var.component_name}-${var.env}-nic${count.index}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  ip_configuration {
    name                          = "${var.component_name}-${var.env}-nic${count.index}"
    subnet_id = "/subscriptions/cde5241e-289a-449b-b2b7-4efcf2d5c83c/resourceGroups/denmark-east-rg/providers/Microsoft.Network/virtualNetworks/controller-vnet/subnets/default"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.vm_count
  name                            = "${var.component_name}-${var.env}-${count.index}"
  location                        = data.azurerm_resource_group.main.location
  resource_group_name             = data.azurerm_resource_group.main.name
  network_interface_ids           = [azurerm_network_interface.main[count.index].id]
  size                            = "Standard_B1s"
  admin_password                  = "Devops@123456"
  admin_username                  = "Devops"
  source_image_id                 = var.image_id
  disable_password_authentication = false
  secure_boot_enabled             = true
  vtpm_enabled                    = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_dns_a_record" "main" {
  name                = "${var.component_name}-${var.env}"
  zone_name           = "rdevopsb89.online"
  resource_group_name = data.azurerm_resource_group.main.name
  ttl                 = 30
  records             = var.lb_type == null ? [azurerm_network_interface.main[0].private_ip_address] : var.lb_type == "public" ? azurerm_public_ip.main[*].ip_address :azurerm_lb.main[*].private_ip_address
}

resource "azurerm_public_ip" "main" {
  count               = var.lb_type == "public" ? 1 : 0
  name                = "${var.component_name}-${var.env}-lb"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  allocation_method   = "Static"
}


resource "azurerm_lb" "main" {
  count               = var.lb_type != null ? 1 : 0
  name                = "${var.component_name}-${var.env}"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                          = "${var.component_name}-${var.env}"
    private_ip_address_allocation = var.lb_type == "private" ? "Dynamic" : null
    subnet_id                     = var.lb_type == "private" ? "subnet_id = "/subscriptions/cde5241e-289a-449b-b2b7-4efcf2d5c83c/resourceGroups/denmark-east-rg/providers/Microsoft.Network/virtualNetworks/controller-vnet/subnets/default"
" : null
    public_ip_address_id          = var.lb_type == "public" ? azurerm_public_ip.main[0].id : null
  }

}

resource "azurerm_lb_backend_address_pool" "main" {
  count           = var.lb_type != null ? 1 : 0
  loadbalancer_id = azurerm_lb.main[0].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "main" {
  count                               = var.lb_type != null ? var.vm_count : 0
  name                                = "${var.component_name}-${var.env}-${count.index}"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.main[0].id
  ip_address                          = azurerm_network_interface.main[count.index].private_ip_address
  virtual_network_id                  = "/subscriptions/3f2e42e1-ca06-4a99-8c56-be8d8ba306db/resourceGroups/denmark-east-rg/providers/Microsoft.Network/virtualNetworks/workstation-vnet"

}

resource "azurerm_lb_rule" "main" {
  count                          = var.lb_type != null ? 1 : 0
  loadbalancer_id                = azurerm_lb.main[0].id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = var.port
  backend_port                   = var.port
  frontend_ip_configuration_name = "${var.component_name}-${var.env}"
}

