resource "aws_instance" "Jitsi" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
 
  key_name               = aws_key_pair.om_meet.key_name
  user_data              = data.template_file.install_script.rendered
 
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.Jitsi.id
  }
  tags = {
    Name = "jitsi-meet-server-${local.subdomain}"
  }
}

 
resource "random_id" "jibriauthpass" {
  byte_length = 8
}
resource "random_id" "jibrirecorderpass" {
  byte_length = 8
}
resource "random_id" "server_id" {
  byte_length = 4
}


resource "aws_key_pair" "om_meet" {
  key_name   = "om_meet-key"
  public_key = tls_private_key.rsa.public_key_openssh 
  }

  # RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "om_meet" {
  content  = 
  filename = "om_meet"
}
