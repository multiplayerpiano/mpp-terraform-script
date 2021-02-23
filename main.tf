terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "" // Your public key
}

resource "aws_instance" "multiplayerpiano_com" {
  ami           = "ami-05250bd90f5750ed7"
  instance_type = "t3.micro"
  key_name = "deployer-key"
  associate_public_ip_address = true

  tags = {
    Name = "multiplayerpiano.com2"
  }

  // testing if can do anything. Here potentially we should install docker
  user_data = "#!/bin/bash\ntouch test1"

  // We should run docker image here
  provisioner "remote-exec" {
    inline = [
      "docker run example"
    ]

    connection {
      type  = "ssh"
      host  = aws_instance.multiplayerpiano_com.public_ip
      user  = "ubuntu"
      port  = 22
      agent = true
    }
  }
}
