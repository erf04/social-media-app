import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String url;
  WebSocketChannel? channel;
  Timer? _reconnectTimer;
  final Duration reconnectInterval;
  bool _shouldReconnect = true;

  WebSocketManager({
    required this.url,
    this.reconnectInterval = const Duration(seconds: 5),
  });

  void connect() {
    channel = WebSocketChannel.connect(Uri.parse(url));
    channel?.stream.listen(
      (message) {
        // Handle incoming messages
        print('Received: $message');
      },
      onDone: _onDone,
      onError: _onError,
    );
  }

  void _onDone() {
    print('WebSocket connection closed');
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _onError(error) {
    print('WebSocket connection error: $error');
    if (_shouldReconnect) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectTimer != null) return;
    _reconnectTimer = Timer(reconnectInterval, () {
      connect();
      _reconnectTimer = null;
    });
  }

  void disconnect() {
    _shouldReconnect = false;
    channel?.sink.close();
    _reconnectTimer?.cancel();
  }

  void sendMessage(String message) {
    channel?.sink.add(message);
  }

  void dispose() {
    _shouldReconnect = false;
    channel?.sink.close();
    _reconnectTimer?.cancel();
  }
}