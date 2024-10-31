resource "aws_key_pair" "ec2_ssh_key" {
  public_key = file("~/.ssh/ec2.pub")
  key_name = "ec2-ssh"
}