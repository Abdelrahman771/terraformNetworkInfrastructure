output "pubsubnet0" {
  value = aws_subnet.pub[0].id
}

output "pubsubnet1" {
  value = aws_subnet.pub[1].id
}

output "privsubnet0" {
  value = aws_subnet.priv[0].id
}

output "privsubnet1" {
  value = aws_subnet.priv[1].id
}

output "vpcid" {
  value = aws_vpc.lab3.id
}
