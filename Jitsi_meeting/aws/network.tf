resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy = "default"    
  tags = {
    Name = "${var.app_name}-${var.app_environment}-vpc"
  }
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true

     tags = {
    Name = "${var.app_name}-${var.app_environment}-public-${data.aws_availability_zones.available.names[count.index]}"
  }
}



# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
     tags = {
    Name = "${var.app_name}-${var.app_environment}-igw"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_network_interface" "Jitsi" {
  subnet_id       = aws_subnet.public[0].id
  private_ips     = ["10.0.2.50"]
  security_groups = [aws_security_group.allow_connections_jitsi-meet.id]      
  tags = {
    Name = "${var.app_name}-${var.app_environment}-ni-ommeet"
  }
}








