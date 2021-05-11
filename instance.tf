provider "aws" {
 access_key = "AKIA6GTT5VFCUZWPSUX7"
 secret_key = "OOPUZc+DAWTJKeJn4YakTpZUOpHr4fRvDtgN5S7v"
 region = "us-east-1"


}

resource "aws_instance" "terraform-example"{
    ami = "ami-0d5eff06f840b45e9"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.mytfsg.id]
    tags = {
      "Name" = "Terraformbuilt ec2 server"
      
     
    }
    key_name = "useast1.pem"

    user_data = <<EOF
            #!/bin/bash
            sudo yum update -y
            sudo yum install httpd -y
            echo "Deployed via Terraform" > /var/www/html/index.html
            sudo service httpd start
            sudo service httpd enable
            yum install java-1.8.0-openjdk-devel -y
    curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
    sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
    yum install -y jenkins
    systemctl start jenkins
    systemctl status jenkins
    systemctl enable jenkins
            EOF


}

resource "aws_security_group" "mytfsg" {

    name = "my terraform sg"
    description = "This sg is used by terraform instance"

     ingress {
    # SSH Port 80 allowed from any IP
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {

         # SSH Port 22 allowed from any IP
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

   

  ingress {
    # SSH Port 8080 allowed from any IP
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



output "public_ip" {

    value = "${aws_instance.terraform-example.public_ip}"
  
}
output "id" {

    value = "${aws_instance.terraform-example.id}"

  
}
output "subnet_id" {

    value = "${aws_instance.terraform-example.subnet_id}"

  
}
output "VPC_Security_group" {

    value = "${aws_instance.terraform-example.vpc_security_group_ids}"
  
}
output "public_dns" {

    value = "${aws_instance.terraform-example.public_dns}"
  
}
