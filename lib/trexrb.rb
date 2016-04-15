require 'trexrb/version'
require 'socket'
require 'yaml'

class Trexrb
  DEFAULT_HOST = 'localhost'
  DEFAULT_PORT = 4040

  def initialize(host = nil, port = nil)
    @host = host || DEFAULT_HOST
    @port = port || DEFAULT_PORT
  end

  def get(key)
    with_connection do |conn|
      conn.print Request.new.get(key)

      Response.new(conn.read).body
    end
  end

  def set(key, value)
    with_connection do |conn|
      conn.print Request.new.set(key, value)

      Response.new(conn.read).body
    end
  end

  def keys
    with_connection do |conn|
      conn.print Request.new.list
      result = Response.new(conn.read).body

      result || []
    end
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  attr_reader :host, :port

  def with_connection
    socket = Socket.tcp(host, port)
    yield socket
  rescue => ex
    puts "Connection error: #{ex.inspect}"
  ensure
    socket.close_write
  end

  Response = Struct.new(:data) do
    def body
      return if no_data?

      YAML.load(cleaned_data)
    rescue => ex
      puts ex.inspect
      cleaned_data
    end

    private

    def no_data?
      data.to_s.strip.length == 0
    end

    def cleaned_data
      data.rstrip
    end
  end
  private_constant :Response

  Request = Class.new do
    FIELD_SEPARATOR = "\t"
    TERMINATOR = "\r\n"

    def get(key)
      build("GET", key)
    end

    def set(key, value)
      build("SET", key, YAML.dump(value))
    end

    def list
      build("LIST")
    end

    private

    def build(command_name, *params)
      ([command_name] + params).join(FIELD_SEPARATOR) + TERMINATOR
    end
  end
  private_constant :Request
end
