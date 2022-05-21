#!/bin/bash
sleep 30

sudo yum update -y
sudo yum install unzip wget tree -y

#Install ansible 
sudo amazon-linux-extras install ansible2


