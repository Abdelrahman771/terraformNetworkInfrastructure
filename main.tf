module "VPC" {
  source = "./modules/VPC"
  vpc-cidr = "10.0.0.0/16"
  vpc-tag-name = "TerraformProject"
  subnet-cidr-pub = ["10.0.0.0/24","10.0.2.0/24"]
  subnet-cidr-prv = ["10.0.1.0/24","10.0.3.0/24"]
  NAT-name="NGW"
  igw-name = "IGW"
  GW-cidr="0.0.0.0/0"
  PubRT-name="PublicRouteTable"
  PrivRT-name="PrivateRouteTable"
  AZ-State="available"
}
module "ec2" {
  source = "./modules/ec2"
  AMI = "ami-00874d747dde814fa"
  Instancekey = "saif"
  type= "t2.micro"
  vpcid=module.VPC.vpcid
  pubsubnet0=module.VPC.pubsubnet0
  pubsubnet1=module.VPC.pubsubnet1
  privsubnet0=module.VPC.privsubnet0
  privsubnet1=module.VPC.privsubnet1
  count1 = 2

public-inline = [
      "sudo apt update -y",
      "sudo apt install -y nginx",
      "sudo echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://${module.LB.private_LB_DNS}; \n  } \n}' > default",
      "sudo mv default /etc/nginx/sites-enabled/default",
      "sudo systemctl restart nginx",
  ]

private-inline=[
    "sudo apt update -y",
    "sudo apt install nginx -y ",
    "private_ip=`sudo curl http://169.254.169.254/latest/meta-data/local-ipv4`",
    "sudo echo 'Hello from private instance ' > index.html",
    "sudo echo $private_ip >> index.html",
    "sudo mv index.html  /var/www/html/",
  ]

  
} 
module "LB"{
  source = "./modules/LB"
  VPC-ID-FOR-LB=module.VPC.vpcid
  pubsubnet1=module.VPC.pubsubnet0
  pubsubnet2=module.VPC.pubsubnet1
  privsubnet1=module.VPC.privsubnet0
  privsubnet2=module.VPC.privsubnet1
  pubinst1=module.ec2.pubinst1
  pubinst2=module.ec2.pubinst2
  privinst1=module.ec2.privinst1
  privinst2=module.ec2.privinst2
  publicalb-name = "public-alb"
  privatealb-name = "private-alb"
  load_balancer_type = "application"
  Port              = "80"
  Protocol          = "HTTP"
}