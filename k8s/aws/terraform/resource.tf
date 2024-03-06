# resource "aws_instance" "k8s-cluster" {
#   ami           = "ami-00381a880aa48c6c6"
#   instance_type = [ var.instance_type[count.index] ]

#   count = length(var.instance_type)

#   tags = {
#     Name = "k8s"
#   }
# }




# vpc
resource "aws_vpc" "k8s-vpc" {
  cidr_block = "10.0.0.0/16"
}





# Security Group
resource "aws_security_group" "sg" {
  name        = "k8s-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.k8s-vpc.id
  tags = {
    Name = "k8s-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.k8s-vpc.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_k8s_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.k8s-vpc.cidr_block
  from_port         = 6443
  ip_protocol       = "tcp"
  to_port           = 6443
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}



# EC2
resource "aws_instance" "k8s-master" {
  ami           = "ami-00381a880aa48c6c6"
  instance_type = "t3.small"

  key_name = "k8s-key"

  security_groups = [ aws_security_group.sg.name ]

  tags = {
    Name = "Master"
  }
}


resource "aws_instance" "k8s-worker" {
  ami           = "ami-00381a880aa48c6c6"
  instance_type = "t3.micro"

  security_groups = [ aws_security_group.sg.name ]

  tags = {
    Name = "Worker"
  }
}