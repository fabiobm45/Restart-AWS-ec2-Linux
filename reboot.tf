provider "aws" {
  region              = "us-west-2"
  profile             = "test"
}

resource "aws_instance" "ec2" {
  ami                         = "ami-0f2176987ee50226e"
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  subnet_id                   = "subnet-45454566645"
  vpc_security_group_ids      = ["sg-45454545454"]
  key_name                    = "mytest-ec2key"
  tags = {
    Name = "Test EC2 Instance"
  }
}
resource "null_resource" "reboo_instance" {

  provisioner "local-exec" {
    on_failure  = "fail"
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
        echo -e "\x1B[31m Warning! Restarting instance having id ${aws_instance.ec2.id}.................. \x1B[0m"
        # aws ec2 reboot-instances --instance-ids ${aws_instance.ec2.id} --profile test
        # To stop instance
        aws ec2 stop-instances --instance-ids ${aws_instance.ec2.id} --profile test
        echo "***************************************Rebooted****************************************************"
     EOT
  }
#   this setting will trigger script every time,change it something needed
  triggers = {
    always_run = "${timestamp()}"
  }


}
