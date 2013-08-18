require 'socket'
require 'websocket/driver'

module Capybara::Poltergeist
  class AsyncWebSocketServer
    HOST = '127.0.0.1'
    RECV_SIZE = 1024
 
    def initialize(port)
      @callbacks = []
      @server = TCPServer.open(HOST, port || 0)
      @driver = ::WebSocket::Driver.server(self)

      @driver.on(:connect) { |event| @driver.start }
      @driver.on(:message) { |e| execute_callbacks(e) }
      @driver.on(:close)   { |e| close_connection_after_writing }
      # @driver.on(:open) { |e| $stderr.puts "connection open" }

      Thread.abort_on_exception = true
      @thread = Thread.new do
         @socket = @server.accept
         loop do
           IO.select([@socket])
           data = @socket.recv(RECV_SIZE)
           # $stderr.puts "got #{data}" if data && !data.empty?
           @driver.parse(data)
         end
      end
    end

    def add_message_callback &blk
      @callbacks << blk
    end

    def execute_callbacks(e)
      @callbacks.each { |p| p.call(e) }
    end

    def close
      @thread.terminate
      @server.close_read
      @server.close_write
      @socket.close_read
      @socket.close_write
    end

    def port
      @server.addr[1]
    end

    def receive_data(data)
      @driver.parse(data)
    end

    def write(data)
      @socket.write(data)
    end
  end
end
