resource "aws_instance" "pub" {
  ami                         = var.AMI  
  instance_type               = var.type
  key_name                    = var.Instancekey
  subnet_id                   = var.pubsubnet0
  vpc_security_group_ids      = [aws_security_group.webSG.id]
  associate_public_ip_address = true

  provisioner "remote-exec" {
        inline = var.public-inline
        connection {
          type = "ssh"
          user = "ubuntu"
          private_key = file("./saif.pem")
          host =self.public_ip

      }
    }
  tags = {
    Name = "web_instance-1"
  }

}

resource "aws_instance" "pub1" {
  ami             = var.AMI  
  instance_type   = var.type
  key_name = var.Instancekey
  subnet_id = var.pubsubnet1
  vpc_security_group_ids = ["${aws_security_group.webSG.id}"]
  associate_public_ip_address = true

  provisioner "remote-exec" {
        inline = var.public-inline
        connection {
          type = "ssh"
          user = "ubuntu"
          private_key = file("./saif.pem")
          host =self.public_ip


      }
    }
  tags = {
    Name = "web_instance-2"
  }

}


resource "aws_instance" "priv" {
  ami             = var.AMI  
  instance_type   = var.type
  key_name = var.Instancekey
  subnet_id = var.privsubnet0
  vpc_security_group_ids = ["${aws_security_group.webSG.id}"]

  provisioner "remote-exec" {
        inline = var.private-inline
        connection {
          type = "ssh"
          user = "ubuntu"
          private_key = file("./saif.pem")
          host =self.private_ip

          bastion_host = aws_instance.pub.public_ip
          bastion_user =   "ubuntu"
          bastion_host_key =  file("./saif.pem")
      }
    }
  tags = {
    Name = "web_instance-1"
  }

}

resource "aws_instance" "priv1" {
  ami             = var.AMI  
  instance_type   = var.type
  key_name = var.Instancekey
  subnet_id = var.privsubnet1
  vpc_security_group_ids = ["${aws_security_group.webSG.id}"]

  provisioner "remote-exec" {
        inline = var.private-inline
        connection {
          type = "ssh"
          user = "ubuntu"
          private_key = file("./saif.pem")
          host =self.private_ip

          bastion_host = aws_instance.pub1.public_ip
          bastion_user =   "ubuntu"
          bastion_host_key =  file("./saif.pem")
      }
    }
  tags = {
    Name = "web_instance-2"
  }

}


resource "aws_security_group" "webSG" {
  name        = "webSG"
  description = "Allow ssh  inbound traffic"
  vpc_id = var.vpcid

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]

  }
}


