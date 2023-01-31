output "pubinst1" {
  value = aws_instance.pub.id
}

output "pubinst2" {
  value = aws_instance.pub1.id
}

output "privinst1" {
  value = aws_instance.priv.id
}

output "privinst2" {
  value = aws_instance.priv1.id
}