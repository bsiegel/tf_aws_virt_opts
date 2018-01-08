#!/usr/bin/ruby
require 'net/https'
require 'json'

ebs_opt_forced_types = %w(c4. c5. d2. f1. g3. h1. i3. m4. m5. p2. p3. r4. x1. x1e.)
uri = URI.parse("https://raw.githubusercontent.com/powdahound/ec2instances.info/master/www/instances.json")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
request = Net::HTTP::Get.new(uri.request_uri)
res = http.request(request)
ami_types = Hash[JSON.parse(res.body).map { |tuple| [tuple['instance_type'], [tuple['linux_virtualization_types'], tuple['ebs_optimized']]] }]

output = {
 "variable" => {
    "prefer_pv" => {
      "description" => "If an instance type supports PV, should return 'pv', else 'hvm'",
      "default" => Hash[ami_types.map { |k, v| [k, v[0].include?('PV') ? 'pv' : 'hvm'] }]
    },
    "prefer_hvm" => {
      "description" => "If an instance type supports HVM, should return 'hvm', else 'pv'",
      "default" => Hash[ami_types.map { |k, v| [k, v[0].include?('HVM') ? 'hvm' : 'pv'] }]
    },
    "prefer_ebsopt" => {
      "description" => "If an instance type supports running with EBS Optimization, should return true, else false",
      "default" => Hash[ami_types.map { |k, v| [k, v[1]] }]
    },
    "prefer_noopt" => {
      "description" => "If an instance type supports running without EBS optimization, should return false, else true",
      "default" => Hash[ami_types.map { |k, v| [k, k.start_with?(*ebs_opt_forced_types)] }]
    }
  }
}

File.open('variables.tf.json.new', 'w') { |f| f.puts JSON.pretty_generate(output) }
File.rename 'variables.tf.json.new', 'variables.tf.json'

