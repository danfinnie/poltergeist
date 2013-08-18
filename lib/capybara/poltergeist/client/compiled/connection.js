var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Poltergeist.Connection = (function() {
  function Connection(owner, sync_port, async_port) {
    this.owner = owner;
    this.sync_port = sync_port;
    this.async_port = async_port;
    this.commandReceived = __bind(this.commandReceived, this);
    this.sync_socket = new WebSocket("ws://127.0.0.1:" + this.sync_port + "/");
    this.async_socket = new WebSocket("ws://127.0.0.1:" + this.async_port + "/");
    this.sync_socket.onmessage = this.commandReceived;
    this.sync_socket.onclose = function() {
      return phantom.exit();
    };
  }

  Connection.prototype.commandReceived = function(message) {
    return this.owner.runCommand(JSON.parse(message.data));
  };

  Connection.prototype.send = function(message) {
    return this.sync_socket.send(JSON.stringify(message));
  };

  Connection.prototype.send_async = function(message) {
    return this.async_socket.send(JSON.stringify(message));
  };

  return Connection;

})();
