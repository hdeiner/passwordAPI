output "aws_key_pair_name" {
  value = ["${aws_key_pair.passwordAPI_key_pair.key_name}"]
}

output "aws_key_public_key" {
  value = ["${aws_key_pair.passwordAPI_key_pair.public_key}"]
}

output "sqlsvr_dns" {
  value = ["${aws_instance.ec2_passwordAPI_sqlsvr.*.public_dns}"]
}

output "sqlsvr_ip" {
  value = ["${aws_instance.ec2_passwordAPI_sqlsvr.*.public_ip}"]
}

output "tomcat_dns" {
  value = ["${aws_instance.ec2_passwordAPI_tomcat.*.public_dns}"]
}

output "tomcat_ip" {
  value = ["${aws_instance.ec2_passwordAPI_tomcat.*.public_ip}"]
}