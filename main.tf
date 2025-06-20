module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_vpn_gateway = false

  enable_nat_gateway  = true
  single_nat_gateway  = true
  reuse_nat_ips       = true # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = aws_eip.nat.*.id

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_eip" "nat" {
  count = 1
  domain = "vpc"
}

resource "aws_instance" "my_vm" {
  ami           = "ami-020cba7c55df1f615" //Ubuntu AMI
  instance_type = "t2.micro"

  tags = {
    Name = "My first EC2 instance using Terraform",
  }
}