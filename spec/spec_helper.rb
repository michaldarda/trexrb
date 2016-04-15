$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'trexrb'
require 'socket'

RSpec.configure do |config|
  config.before(:suite) do
    raise "Start Trex on port 4040" unless trex_running?(4040)
  end
end

def trex_running?(port)
  Socket.tcp("localhost", 4040) {|sock|
    sock.print "PING\r\n"
    sock.close_write
    resp = sock.read
    resp == "PONG\r\n"
  }
rescue => e
  puts "Error #{e.inspect}"
  false
end
