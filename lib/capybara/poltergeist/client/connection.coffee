class Poltergeist.Connection
  constructor: (@owner, @sync_port, @async_port) ->
    @sync_socket = new WebSocket "ws://127.0.0.1:#{@sync_port}/"
    @sync_socket.onmessage = this.commandReceived
    @sync_socket.onclose = -> phantom.exit()

    @async_open = false
    @async_queue = []
    # @async_socket = new WebSocket "ws://127.0.0.1:#{@async_port}/"
    # @async_socket.onopen = ->
    #   @async_open = true
    #   sendAsync message for message in messages

  commandReceived: (message) =>
    @owner.runCommand(JSON.parse(message.data))

  send: (message) =>
    @sync_socket.send(JSON.stringify(message))

  # sendAsync: (message) =>
  #   if @async_open
  #     @async_socket.send(JSON.stringify(message))
  #   else
  #     @async_queue[@async_queue.length] = message
