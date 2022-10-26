# creation instances
resource "aws_instance" "web1" {
  ami      = var.image_id
  instance_type  = var.instance_type
  key_name = aws_key_pair.test-key.key_name
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = ["${aws_security_group.securitygroup.id}"]
  tags = {
    Name = "myinstance-public"
  }
}

resource "aws_instance" "web2" {
  ami      = var.image_id
  instance_type  = var.instance_type
  key_name = aws_key_pair.test-key.key_name
  subnet_id = aws_subnet.private-subnet.id
  vpc_security_group_ids = ["${aws_security_group.securitygroup.id}"]
  tags = {
    Name = "myinstance-private"
  }
}

resource "aws_key_pair" "test-key" {
  key_name = var.key_name
  public_key = var.key
}