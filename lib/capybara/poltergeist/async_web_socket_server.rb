require 'socket'
require 'websocket/driver'

module Capybara::Poltergeist
  class AsyncWebSocketServer
    HOST = '127.0.0.1'
 
    def initialize(port)
      @server = TCPServer.open(HOST, port || 0)
      @driver = ::WebSocket::Driver.server(self)

      @driver.start

      @driver.on(:message) { |e| @driver.text(e.data) }
      @driver.on(:close)   { |e| close_connection_after_writing }

      Thread.abort_on_exception = true
      @thread = Thread.new do
         @server.accept
      end
    end

    def close
      @thread.terminate
      @server.close_read
      @server.close_write
    end

    def port
      @server.addr[1]
    end

    def receive_data(data)
      @driver.parse(data)
    end

    def write(data)
      send_data(data)
    end
  end
end
