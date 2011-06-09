require 'puppet'
require 'json'
require 'yaml'
require 'pp'

begin
  require "xmlrpc/client"
rescue LoadError => e
  Puppet.info "You need the `xmlrpc/client` library to use the snmp report"
end

Puppet::Reports.register_report(:zenoss) do

  configfile = File.join([File.dirname(Puppet.settings[:config]), "zenoss.yaml"])
  raise(Puppet::ParseError, "zendesk report config file #{configfile} not readable") unless File.exist?(configfile)
  config = YAML.load_file(configfile)
  ZENOSS_USER        = config[:zenoss_user]
  ZENOSS_PASS        = config[:zenoss_pass]
  ZENOSS_SERVER      = config[:zenoss_server]
  ZENOSS_XMLRPC_PORT = config[:zenoss_xmlrpc_port]
  ZENOSS_EVENTCLASS  = config[:zenoss_eventclass]


  desc <<-DESC
  Send notification of failed reports to Zenoss and open new tickets.
  DESC


  def process

    failure = false

    #iterate through each log object and look for failures
    self.logs.each do |log|
      if log.level.to_s == 'err' || 'alert' || 'emerg' || 'crit'
        failure = true
      end
    end
  
    if failure == true
      Puppet.debug "Creating Zenoss event for failed run on #{self.host}."
      event = {}
      output = []
      self.logs.each do |log|
        output << log
      end
      url = "http://#{ZENOSS_USER}:#{ZENOSS_PASS}@#{ZENOSS_SERVER}:#{ZENOSS_XMLRPC_PORT}/zport/dmd/DeviceLoader"
      server = XMLRPC::Client.new2( url )
      event = {'device' => "u5_m5.sf.verticalresponse.com", 
               'eventclass' => "#{ZENOSS_EVENTCLASS}", 
               'severity' => 2, 
               'summary' => "Puppet run for #{self.host} failed at #{Time.now.asctime} #{output.join("\n")}" }
      ok, param = server.call2('sendEvent', event) 
      Puppet.err "Error sending Zenoss event: #{param}" unless ok
    end
  end
end
