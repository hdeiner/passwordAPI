resource "aws_instance" "ec2_passwordAPI_sqlsvr" {
  count = 1
  ami = "ami-759bc50a"
  instance_type = "t2.small"
  key_name = "${aws_key_pair.passwordAPI_key_pair.key_name}"
  security_groups = ["${aws_security_group.passwordAPI_sqlsvr.name}"]
  provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    script = "terraformProvisionSqlSvr.sh"
  }
  provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    inline = ["(sleep 2 && sudo reboot now)&"]
  }
  tags {
    Name = "PasswordAPI SqlSvr ${format("%03d", count.index)}"
  }
}