class Poltergeist.Connection
  constructor: (@owner, @sync_port, @async_port) ->
    @sync_socket = new WebSocket "ws://127.0.0.1:#{@sync_port}/"
    @async_socket = new WebSocket "ws://127.0.0.1:#{@async_port}/"
    @sync_socket.onmessage = this.commandReceived
    @sync_socket.onclose = -> phantom.exit()

  commandReceived: (message) =>
    @owner.runCommand(JSON.parse(message.data))

  send: (message) ->
    @sync_socket.send(JSON.stringify(message))

  send_async: (message) ->
    @async_socket.send(JSON.stringify(message))
