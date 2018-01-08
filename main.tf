variable instance_type {}

output "prefer_hvm" {
    value = "${lookup(var.prefer_hvm, var.instance_type)}"
}

output "prefer_pv" {
    value = "${lookup(var.prefer_pv, var.instance_type)}"
}

output "prefer_ebsopt" {
  value = "${lookup(var.prefer_ebsopt, var.instance_type)}"
}

output "prefer_noopt" {
  value = "${lookup(var.prefer_noopt, var.instance_type)}"
}
