require 'mcollective'

# A plugin that triggers deployments
class Robut::Plugin::MCIptables
  include Robut::Plugin
  include MCollective::RPC

  def debug(msg)
    connection.config.logger.debug "MCIptables: #{msg}"
  end

  def error(msg)
    connection.config.logger.error "MCIptables: #{msg}"
  end

  def initialize(reply_to, private_sender = nil)
    super(reply_to, private_sender)
    debug "initialize"
  end

  def usage
    [
     "#{at_nick} ip listblocked - #{nick} will list blocked IPs",
     "#{at_nick} ip block <ip> -  #{nick} will block this IP on whole collective",
     "#{at_nick} ip unblock <ip> -  #{nick} will UNblock this IP"
    ]
  end

  def mc_call(action, args, &f)
    o =  MCollective::Util.default_options
    mc = rpcclient("iptables", {:options => o })
    debug "Discovery done."

    if block_given?
      mc.send(action, args) { |res| f.call(res) }
    else
      return mc.send(action,args)
    end

    # When disconnected, only 1 MC call will succeed.
    # mc.disconnect
    # debug "Collective disconnected."
  end

  def status(r)
    r[:body][:statuscode]
  end

  def ok?(r)
    status(r) == 0
  end

  # This uses direct handling of replies, as they arive.
  match /^ip listblocked/, :sent_to_me => true do |_|
    reply("Lets use MCollective to find out...")
    mc_call(:listblocked, {}) do |r|
      begin
        msg   = "#{r[:senderid]} - blocked IPs: #{r[:body][:data][:blocked].join(',')}" if ok?(r)
        msg ||= "#{r[:senderid]} - communication error: #{status(r)}"
        reply msg
      rescue => e
        reply "Got #{e.class} - Sorry."
        error "Got #{e.class}. #{e.message} - #{e.backtrace.join("\t\n")}"
      end
    end
    return true
  end

  # This uses the MCollective style, where RPC-Errors are handled by MCollective code
  def block_unblock(action, ipaddr)
    reply "Lets use MCollective to block #{ipaddr}."

    results = mc_call(action, {:ipaddr => ipaddr})
    oks = results.select {|r| r[:statuscode] == 0 or (r[:statuscode] == 1 and r[:statusmsg] =~ /was already #{action}ed/) }
    fails = results - oks

    if fails.empty?
      reply "IP #{ipaddr} #{action}ed on #{oks.length} host(s)."
    else
      fail_hosts = fails.map { |r| r[:sender] }
      reply "IP #{ipaddr} #{action}ed on #{oks.length} hosts, BUT #{fails.length} ERRORS: (#{fail_hosts.join(", ")})."
    end
  end

  match /^ip (block|unblock) ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/, :sent_to_me => true do |action, ipaddr|
    block_unblock(action.to_sym, ipaddr)
    return true
  end
end
