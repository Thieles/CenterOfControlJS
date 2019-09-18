require 'soap/rpc/standaloneServer'

class HelloWorldServer < SOAP::RPC::StandaloneServer
  def on_init
    @log.level = Logger::Severity::DEBUG
    add_method self, 'hello_world', 'from'
  end

  def hello_world(from)
    "Olá mundo!, de #{from}"
  end
end


if $0 == __FILE__
  server = HelloWorldServer.new 'Hello', 'urn:Hello', '0.0.0.0', 2000
  trap(:INT) do
    server.shutdown
  end
  server.start
end