module Capybara::Poltergeist
  class Server
    attr_reader :fixed_port, :timeout

    def initialize(fixed_port = nil, timeout = nil)
      @fixed_port = fixed_port
      @timeout    = timeout
      start
    end

    def port
      @sync_socket.port
    end

    def socket
        raise "Deprecated Server#socket"
    end

    def timeout=(sec)
      @timeout = @sync_socket.timeout = sec
    end

    def start
      @sync_socket = SyncWebSocketServer.new(sync_port, timeout)
      @async_socket = AsyncWebSocketServer.new(async_port)
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

    private 

    def sync_port
        fixed_port
    end

    def async_port
        fixed_port ? fixed_port + 1 : nil
    end
  end
end
