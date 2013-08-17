require 'socket'
require 'websocket/driver'

module Capybara::Poltergeist
  class AsyncWebSocketServer
    def initialize(port)
      @port = port
    end

    def close
    end
  end
end
