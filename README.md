# tf_aws_virt_opts

Simple terraform module to allow you to look up the type of AMI
you need to use for a particular instance type.

You simply pass the module your ''instance_type'' and use its outputs to
configure your virtualization type and EBS optimization setting.

Use either ''prefer_hvm'' or ''prefer_pv'' to indicate your
virtualization preference, the value will be either 'hvm' or 'pv'
depending on which is permitted for the given preference and instance
type.

Use either ''prefer_ebsopt'' or ''prefer_noopt'' to indicate your EBS
optimization preference, the value will be either 'true' or 'false'
depending on which is permitted for the given preference and instance
type.

You can then use this in your AMI lookup module to work out which
AMI you need.

Data in this module is generated from:

    https://github.com/powdahound/ec2instances.info/blob/master/www/instances.json

Use this in your terraform code like this:

    module "virt_opts" {
        source = "github.com/bsiegel/tf_aws_virt_opts"
        instance_type = "m3.xlarge"
    }

And you can then reference:

    "${module.virt_opts.prefer_hvm}"

which will return either 'hvm' or 'pv', or

    "${module.virt_opts.prefer_ebsopt}"

which will return either 'true' or 'false'.

For each preference, both outputs are given because some instance types
(e.g. m3.large) support either type of virtualization and can run either
with and without EBS optimization enabled, so you can express a
preference by using one output or the other. Other instance types (e.g.
m4.large) support only running with HVM virtualization and EBS
optimization enabled; in this case, both outputs for each preference
will return the same value.

