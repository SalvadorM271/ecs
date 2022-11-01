output "myAlbGr" {
    value = aws_alb_target_group.main_gr
}

output "myDNS" {
    value = aws_lb.main_lb.dns_name
}