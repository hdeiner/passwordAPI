resource "aws_instance" "ec2_passwordAPI_tomcat" {
  count = 1
  ami = "ami-759bc50a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.passwordAPI_key_pair.key_name}"
  security_groups = ["${aws_security_group.passwordAPI_tomcat.name}"]
  provisioner "remote-exec" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    script = "terraformProvisionTomcat.sh"
  }
  provisioner "file" {
    connection {
      type = "ssh",
      user = "ubuntu",
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    source      = "target/passwordAPI.war"
    destination = "/var/lib/tomcat8/webapps/passwordAPI.war"
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
    Name = "PasswordAPI Tomcat ${format("%03d", count.index)}"
  }
}