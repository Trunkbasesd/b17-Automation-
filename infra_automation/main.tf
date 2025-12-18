module "resource_group" {
    source = "../Modules/resource_group"
    resource_group_name = "ankit"
    resource_group_location = "central india"
}

module "virtual_network" {
    source = "../Modules/virtual_network"
    depends_on = [ module.resource_group ]
    virtual_name = "vipin"
    location = "central india"
    resource_group_name = "ankit"
    address_space = ["10.0.0.0/16"]
}

module "public_ip" {
    source = "../Modules/public_ip"
    pip_name = "sweta_public"
    resource_group_name = "ankit"
    location = "central india"
    allocation_method = "Static"
}

# Dard 2 : Backend subnet and frontend subnet do baar repeat ho raha hai ..... 
module "frontend_subnet" {
    source = "../Modules/subnet"
    depends_on = [ module.virtual_network ]
    subnet_name = "suchi_front"
    resource_group_name = "ankit"
    virtual_network_name = "vipin"
    address_prefixes = ["10.0.0.0/24"]
}

module "backend_subnet" {
    source = "../Modules/subnet"
    depends_on = [ module.virtual_network ]
    subnet_name = "bimla_backend"
    resource_group_name = "ankit"
    virtual_network_name = "vipin"
    address_prefixes = ["10.0.1.0/24"]
}


# Ye upar wala public ip ko frontend vm k sath attach krana hai 

# Dard 2 Do baar Module bulana pad raha hai ....do vm k lie ....
module "frontend_vm" {
  source     = "../Modules/virtual_machine"
  depends_on = [module.frontend_subnet]  

  vm_name = "frontend_vm"
  resource_group_name = "ankit"
  location = "central india"
  size = "Standard_B1s"
 # id / password hardcode hi marr diya hai ...koi bhi dkh lega ...aur vm hack ho zaegi  
  admin_username = "adminuser"
  admin_password = "devopsadmin@12345"
  nic_name = "pawarnic"
 # ye subnet upar bna hai ....hardcode kyu karna hai 
  subnet_id = ""
  public_ip_address_id = ""
  
}


module "backend_vm" {
  source     = "../Modules/virtual_machine"
  depends_on = [module.frontend_subnet]

  vm_name = "backend_vm"
  resource_group_name = "ankit"
  location = "central india"
  size = "Standard_B1s"
  admin_username = "adminuser"
  admin_password = "devopsadmin@12345"
  nic_name = "pawarnic"
  # ye subnet upar bna hai ....hardcode kyu karna hai  
  subnet_id = "/subscriptions..."
  public_ip_address_id = ""
}


module "sql_server" {
    source = "../Modules/sql_server"
    
    sql_name = ""
    resource_group_name = "ankit"
    location = ""
    version = ""
   # secret ko rkhne ka jugaar ... Azure key vault  
    admin_login = ""
    admin_password = ""
}


module "sql_server" {
    source = "../Modules/sql_databse"

    sql_database = ""
 # sql server ka id hardcode hai ...yeh th bada hi takhiff thara hai 

}
