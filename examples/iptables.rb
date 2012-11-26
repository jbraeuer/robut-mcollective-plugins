#!/usr/bin/ruby

#
# Simple example how to use MCollective from within Ruby.
#

require 'pp'
require 'mcollective'
include MCollective::RPC

options =  MCollective::Util.default_options
puts "opts: #{options.inspect}"

mc = rpcclient("iptables", {:options => options })

act = :listblocked
args = {}

act = :block
args = {:ipaddr => "1.2.3.4"}

 mc.send(act, args) do |resp, _|
   begin
     puts "response:"
     pp resp
   rescue RCPError => e
     puts "Got a RPC error. Whut?"
   end
end
mc.disconnect
