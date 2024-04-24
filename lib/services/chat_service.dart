// ignore_for_file: avoid_print

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:parking_finder_app_provider/models/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // สำหรับจัดการการเก็บ token

class ChatService {
  late io.Socket socket;
  Function(Message) onMessageReceived;
  Function(List<Message>) onHistoryReceived;
  Function(dynamic) onError;
  final String reserveID;
  final String senderID;
  final String receiverID;
  final storage =
      const FlutterSecureStorage(); // สร้าง instance ของ FlutterSecureStorage

  ChatService({
    required this.onMessageReceived,
    required this.onHistoryReceived,
    required this.onError,
    required this.reserveID,
    required this.senderID,
    required this.receiverID,
  }) {
    socket = io.io(
      'http://34.125.122.199:4700/?user_id=$senderID',
      io.OptionBuilder().setTransports(['websocket']).build(),
    );

    socket.on(
        'message',
        (data) => {
              // print(data),
              onMessageReceived(Message.fromJson(data['MessageLog'][0]))
            });

    // socket.onConnect((_) => print("Connected to Socket IO Server"));
    // socket.onDisconnect((_) => print("Disconnected from Socket IO Server"));
    // socket.onConnectError((data) => print("Connect error: $data"));
    // socket.onConnectTimeout((data) => print("Connection timeout: $data"));
    // socket.onError((data) => print("Error: $data"));
  }

  void sendMessage(String text) {
    if (text.trim().isNotEmpty) {
      var messageData = {
        'reservation_id': reserveID,
        'message': {'Type': 'Text', 'Text': text},
        'receiver_id': receiverID,
        'sender_id': senderID,
      };
      socket.emit('message', messageData);
    }
  }

  Future<void> retrieveMessageLog() async {
    final url = Uri.parse(
        '${dotenv.env['HOST']}/provider/retrieve_message_log?reservation_id=$reserveID&start=0&limit=100');

    // ดึง token จาก storage
    String? token = await storage.read(key: 'accessToken');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ใส่ token ใน header
      },
    );

    // print(response.body);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final messageLogs = data['data']['MessageLog'] as List;
      final List<Message> retrievedMessages = messageLogs.map((msg) {
        final timestamp = msg['Message']['time_stamp'];
        final DateTime time = DateTime.parse(timestamp.toString()).toLocal();
        return Message(
          senderId: msg['SenderID'],
          reciverId: msg['ReciverID'],
          text: msg['Message']['text'],
          time: time,
        );
      }).toList();

      onHistoryReceived(retrievedMessages.reversed.toList());
    }
  }

  Future<void> retrieveMessageList() async {
    final url =
        Uri.parse('${dotenv.env['HOST']}/provider/retrive_message_list');

    // ดึง token จาก storage
    String? token = await storage.read(key: 'accessToken');

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // ใส่ token ใน header
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      print(data);
    }
  }

  void dispose() {
    if (socket.connected) {
      socket.disconnect();
    }
  }
}
