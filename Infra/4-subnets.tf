resource "aws_subnet" "private_zone1" {
    vpc_id = aws_vpc.main.id
    availability_zone = local.zone1
    cidr_block = "10.0.0.0/19"

    tags = {
      "Name" = "${local.cluster_name}-private-${local.zone1}"
      "kubernetes.io/role/internal-elb" = "1"
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    }
}

resource "aws_subnet" "private_zone2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.32.0/19"
    availability_zone = local.zone2

    tags = {
      Name = "${local.cluster_name}-private-${local.zone2}"
/* 
private subnet -- internal elb is a special tag used by 
EKS (Kubernetes & AWS load balancer controller) 
to create private load balancer 
if you want to expose your service internally within VPC
value -> 1 to enable, 0 to disable
*/
      "kubernetes.io/role/internal-elb" = "1"
/* 
Optional but important, if you want to create multiple EKS
cluster in single AWS account
value -> owned & shared
*/
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.64.0/19"
    map_public_ip_on_launch = true  
    availability_zone = local.zone1
    
    tags = {
      "Name" = "${local.cluster_name}-public-${local.zone1}"
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    }
}

resource "aws_subnet" "public_zone2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.96.0/19"
    map_public_ip_on_launch = true  
    availability_zone = local.zone2
    
    tags = {
      "Name" = "${local.cluster_name}-public-${local.zone2}"
/*
Public subnet --  elb tag instead of internal-elb in private subnet
*/
      "kubernetes.io/role/elb" = "1"
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    }
}