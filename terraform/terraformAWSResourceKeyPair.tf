resource "aws_key_pair" "passwordAPI_key_pair" {
  key_name = "passwordAPI_key_pair"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}