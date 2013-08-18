var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Poltergeist.Connection = (function() {
  function Connection(owner, sync_port, async_port) {
    var _this = this;
    this.owner = owner;
    this.sync_port = sync_port;
    this.async_port = async_port;
    this.sendAsync = __bind(this.sendAsync, this);
    this.send = __bind(this.send, this);
    this.commandReceived = __bind(this.commandReceived, this);
    this.sync_socket = new WebSocket("ws://127.0.0.1:" + this.sync_port + "/");
    this.sync_socket.onopen = function() {
      return console.log("sync open on " + _this.sync_port);
    };
    this.sync_socket.onmessage = this.commandReceived;
    this.sync_socket.onclose = function() {
      _this.async_socket.close();
      return phantom.exit();
    };
    this.async_open = false;
    this.async_queue = [];
    return;
    this.async_socket = new WebSocket("ws://127.0.0.1:" + this.async_port + "/");
    this.async_socket.onopen = function() {
      var message, _i, _len, _results;
      console.log("async open on " + _this.async_port);
      _this.async_open = true;
      _results = [];
      for (_i = 0, _len = messages.length; _i < _len; _i++) {
        message = messages[_i];
        _results.push(sendAsync(message));
      }
      return _results;
    };
  }

  Connection.prototype.commandReceived = function(message) {
    console.log("recv " + message.data);
    return this.owner.runCommand(JSON.parse(message.data));
  };

  Connection.prototype.send = function(message) {
    console.log("sending " + JSON.stringify(message));
    return this.sync_socket.send(JSON.stringify(message));
  };

  Connection.prototype.sendAsync = function(message) {
    if (this.async_open) {
      return this.async_socket.send(JSON.stringify(message));
    } else {
      return this.async_queue[this.async_queue.length] = message;
    }
  };

  return Connection;

})();
