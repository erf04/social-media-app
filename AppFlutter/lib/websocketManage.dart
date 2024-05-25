import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/data.dart';
import 'package:flutter_application_2/loginSignUp.dart';
import 'package:flutter_application_2/splash.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  final String url;
  WebSocketChannel? channel;
  Timer? _reconnectTimer;
  final Duration reconnectInterval;
  bool _shouldReconnect = true;
  BuildContext? context;
  WebSocketManager({
    required this.url,
    this.reconnectInterval = const Duration(seconds: 5),
  });

  void connect() async {
    verifyToken? myVerify = await SplashScreenState.verifyAccess(this.context!);
    channel = null;
    if (myVerify == verifyToken.verified) {
      String? myAccess = await LoginState.getAccessToken();
      channel = WebSocketChannel.connect(Uri.parse(url + '?token=${myAccess}'));
      channel?.stream.listen(
        (message) {
          // Handle incoming messages
          print('Received: $message');
        },
        onDone: _onDone,
        onError: _onError,
      );
    }
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
