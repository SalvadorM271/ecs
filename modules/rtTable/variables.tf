variable vpc_id {}
variable environment {}
// to avoid errors if not pass the default would be null
variable gateway_id {
    default = null
}
variable subnet_id {}
variable nat_gateway_id {
    default = null
}