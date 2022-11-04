// route tables, creates a route table and all needed components (3) for each subnet


module "route_table_public_1" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    gateway_id = aws_internet_gateway.main.id
    //module from where i get output .output value 
    subnet_id = module.public_subnet_1.mySubnet.id
}

module "route_table_public_2" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    gateway_id = aws_internet_gateway.main.id
    //module from where i get output .output value 
    subnet_id = module.public_subnet_2.mySubnet.id
}

// before creating the route tables for my private subnets i need a nat gateway

module "nat_av_1" {
    source = "./modules/nat"
    subnet_id = module.public_subnet_1.mySubnet.id //need to be on public subnet
    environment = var.environment
    depends_on = [aws_internet_gateway.main]
}

module "nat_av_2" {
    source = "./modules/nat"
    subnet_id = module.public_subnet_2.mySubnet.id
    environment = var.environment
    depends_on = [aws_internet_gateway.main]
}

// private route tables

module "route_table_private_1" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    nat_gateway_id = module.nat_av_1.myNat.id
    //module from where i get output .output value 
    subnet_id = module.private_subnet_1.mySubnet.id
    depends_on = [module.nat_av_1]
}

module "route_table_private_2" {
    source = "./modules/rtTable"
    vpc_id = aws_vpc.main.id
    environment = var.environment
    nat_gateway_id = module.nat_av_2.myNat.id
    //module from where i get output .output value 
    subnet_id = module.private_subnet_2.mySubnet.id
    depends_on = [module.nat_av_2]
}