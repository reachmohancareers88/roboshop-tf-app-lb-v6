env      = "dev"
location = "Denmark East"
rgname   = "denmark-east-rg"

image_id = "/subscriptions/cde5241e-289a-449b-b2b7-4efcf2d5c83c/resourceGroups/denmark-east-rg/providers/Microsoft.Compute/galleries/rhel10/images/rhel10/versions/1.0.0"

db = {
  mysql = {}
}

apps = {
  catalogue = {
    port = 8002
  }
}

ui = {
  frontend = {
    port = 80
  }
}
