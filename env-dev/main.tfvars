# Corrected Terraform Configuration

Use this updated configuration with your latest Azure subscription details.

env      = "dev"
location = "Denmark East"
rgname   = "denmark-east-rg"

image_id = "/subscriptions/cde5241e-289a-449b-b2b7-4efcf2d5c83c/resourceGroups/DENMARK-EAST-RG/providers/Microsoft.Compute/galleries/rhel10/images/rhel10/versions/1.0.0"

# Database Configuration

db = {
  mysql = {}

  # valkey   = {}
  # mongodb  = {}
  # rabbitmq = {}
}

# Application Servers

apps = {
  catalogue = {
    port = 8002
  }

  # user = {
  #   port = 8001
  # }

  # cart = {
  #   port = 8003
  # }

  # shipping = {
  #   port = 8004
  # }

  # order = {
  #   port = 8007
  # }

  # notification = {
  #   port = 8008
  # }

  # ratings = {
  #   port = 8006
  # }

  # payment = {
  #   port = 8005
  # }
}

# UI Configuration

ui = {
  frontend = {
    port = 80
  }
}
