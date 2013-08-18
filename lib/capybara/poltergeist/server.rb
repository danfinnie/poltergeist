module Capybara::Poltergeist
  class Server
    attr_reader :fixed_port, :timeout

    def initialize(fixed_port = nil, timeout = nil)
      @fixed_port = fixed_port
      @timeout    = timeout
      start
    end

    def sync_port
      @sync_socket.port
    end

    def async_port
      @async_socket.port
    end

    def timeout=(sec)
      @timeout = @sync_socket.timeout = sec
    end

    def start
      @async_socket = AsyncWebSocketServer.new(nil)
      @sync_socket = SyncWebSocketServer.new(fixed_port, timeout)
    end

    def stop
      @sync_socket.close
      @async_socket.close
    end

    def restart
      stop
      start
    end

    def send(message)
      @sync_socket.send(message) or raise DeadClient.new(message)
    end

    def add_async_message_callback &blk
      @async_socket.add_message_callback(&blk)
    end
  end
end
