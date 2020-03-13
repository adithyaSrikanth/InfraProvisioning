output "public_instance_id" {
  value = "${aws_instance.web_server.id}"
}

output "public_instance_ip" {
  value = "${aws_instance.web_server.public_ip}"
}
